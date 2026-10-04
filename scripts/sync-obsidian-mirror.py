#!/usr/bin/env python3
"""Conflict-safe Markdown bridge between this Git repo and the Obsidian vault."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
from datetime import datetime


DEFAULT_VAULT = (
    Path.home()
    / "Library/Mobile Documents/iCloud~md~obsidian/Documents/<Your Vault>"
)
IGNORED_PARTS = {".git", ".obsidian", ".obsidian-sync-trash", "node_modules"}


def digest(path: Path | None) -> str | None:
    if path is None or not path.is_file():
        return None
    # iCloud sometimes holds a file locked while it syncs (EDEADLK); retry, then
    # let the caller skip the file for this run instead of crashing the whole sync.
    for attempt in range(4):
        try:
            hasher = hashlib.sha256()
            with path.open("rb") as handle:
                for chunk in iter(lambda: handle.read(1024 * 1024), b""):
                    hasher.update(chunk)
            return hasher.hexdigest()
        except OSError:
            if attempt == 3:
                raise
            time.sleep(2)


def markdown_files(root: Path) -> dict[str, Path]:
    if not root.exists():
        return {}
    files: dict[str, Path] = {}
    for path in root.rglob("*.md"):
        relative = path.relative_to(root)
        if not any(part in IGNORED_PARTS for part in relative.parts):
            files[relative.as_posix()] = path
    return files


def repository_markdown_files(root: Path) -> dict[str, Path]:
    result = subprocess.run(
        [
            "git",
            "ls-files",
            "--cached",
            "--others",
            "--exclude-standard",
            "-z",
            "--",
            "*.md",
        ],
        cwd=root,
        check=True,
        capture_output=True,
    )
    return {
        relative: root / relative
        for relative in result.stdout.decode("utf-8").rstrip("\0").split("\0")
        if relative
    }


def copy_file(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.with_name(f".{target.name}.obsidian-sync-tmp")
    shutil.copy2(source, temporary)
    os.replace(temporary, target)


def repo_root() -> Path:
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        check=True,
        capture_output=True,
        text=True,
    )
    return Path(result.stdout.strip()).resolve()


def load_state(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}
    data = json.loads(path.read_text(encoding="utf-8"))
    return data.get("files", {})


def save_state(path: Path, mirror: Path, files: dict[str, str]) -> None:
    payload = {
        "version": 1,
        "mirror": str(mirror),
        "updated_at": datetime.now().astimezone().isoformat(timespec="seconds"),
        "files": dict(sorted(files.items())),
    }
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    os.replace(temporary, path)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Reconcile Markdown files with the iCloud Obsidian vault."
    )
    parser.add_argument(
        "--export-only",
        action="store_true",
        help="Only publish repository changes; never import Obsidian changes.",
    )
    parser.add_argument(
        "--vault",
        type=Path,
        default=None,
        help="Obsidian vault root (defaults to iCloud Drive/Obsidian/<Your Vault>).",
    )
    args = parser.parse_args()

    repository = repo_root()
    configured_vault = args.vault or os.environ.get("OBSIDIAN_VAULT_ROOT")
    vault = Path(configured_vault).expanduser().resolve() if configured_vault else DEFAULT_VAULT
    if configured_vault is None and not DEFAULT_VAULT.parent.is_dir():
        print("Obsidian mirror skipped: no local iCloud Obsidian container.")
        return 0
    mirror = vault / os.environ.get("OBSIDIAN_MIRROR_DIR", "Repo Mirror")
    git_dir = repository / ".git"
    state_path = git_dir / "obsidian-mirror-state.json"
    lock_path = git_dir / "obsidian-mirror.lock"

    try:
        lock_fd = os.open(lock_path, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o600)
        os.close(lock_fd)
    except FileExistsError:
        print(f"Obsidian mirror already running: {lock_path}", file=sys.stderr)
        return 1

    try:
        vault.mkdir(parents=True, exist_ok=True)
        (vault / ".obsidian").mkdir(exist_ok=True)
        mirror.mkdir(parents=True, exist_ok=True)

        state = load_state(state_path)
        repo_files = repository_markdown_files(repository)
        mirror_files = markdown_files(mirror)
        paths = sorted(set(state) | set(repo_files) | set(mirror_files))
        actions: list[tuple[str, str]] = []
        conflicts: list[str] = []
        skipped: list[str] = []

        for relative in paths:
            repo_path = repo_files.get(relative)
            mirror_path = mirror_files.get(relative)
            try:
                repo_hash = digest(repo_path)
                mirror_hash = digest(mirror_path)
            except OSError:
                skipped.append(relative)
                continue
            base_hash = state.get(relative)

            if repo_hash == mirror_hash:
                continue

            if base_hash is None:
                if repo_hash and not mirror_hash:
                    actions.append(("export", relative))
                elif mirror_hash and not repo_hash and not args.export_only:
                    actions.append(("import", relative))
                else:
                    conflicts.append(relative)
                continue

            repo_changed = repo_hash != base_hash
            mirror_changed = mirror_hash != base_hash

            if repo_hash is None and mirror_hash == base_hash:
                actions.append(("trash-mirror", relative))
            elif mirror_hash is None and repo_hash:
                actions.append(("export", relative))
            elif repo_changed and not mirror_changed:
                actions.append(("export", relative))
            elif mirror_changed and not repo_changed and not args.export_only:
                actions.append(("import", relative))
            else:
                conflicts.append(relative)

        if conflicts:
            print("Mirror stopped: both sides differ for:", file=sys.stderr)
            for relative in conflicts:
                print(f"  - {relative}", file=sys.stderr)
            print("No file was changed; please resolve the conflict manually.", file=sys.stderr)
            return 2

        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        for action, relative in actions:
            repo_path = repository / relative
            mirror_path = mirror / relative
            if action == "export":
                copy_file(repo_path, mirror_path)
            elif action == "import":
                copy_file(mirror_path, repo_path)
            elif action == "trash-mirror":
                trash_path = vault / ".obsidian-sync-trash" / stamp / relative
                trash_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.move(mirror_path, trash_path)

        final_repo = repository_markdown_files(repository)
        final_mirror = markdown_files(mirror)
        final_state: dict[str, str] = {}
        for relative in sorted(set(final_repo) | set(final_mirror)):
            try:
                repo_hash = digest(final_repo.get(relative))
                mirror_hash = digest(final_mirror.get(relative))
            except OSError:
                if relative not in skipped:
                    skipped.append(relative)
                if relative in state:
                    final_state[relative] = state[relative]
                continue
            if repo_hash and repo_hash == mirror_hash:
                final_state[relative] = repo_hash
            elif relative in state:
                final_state[relative] = state[relative]
        save_state(state_path, mirror, final_state)

        counts = {"export": 0, "import": 0, "trash-mirror": 0}
        for action, _ in actions:
            counts[action] += 1
        print(
            "Obsidian mirror done: "
            f"{counts['export']} exported, {counts['import']} imported, "
            f"{counts['trash-mirror']} removed (recoverable)."
        )
        if skipped:
            print(f"Skipped (iCloud locked, next run): {len(skipped)}", file=sys.stderr)
            for relative in skipped:
                print(f"  - {relative}", file=sys.stderr)
        print(f"Vault: {vault}")
        return 0
    finally:
        lock_path.unlink(missing_ok=True)


if __name__ == "__main__":
    raise SystemExit(main())
