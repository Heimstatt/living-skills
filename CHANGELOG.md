# Changelog

All notable changes to this project will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
at the repository level:

- **MAJOR** — breaking changes to the framework spec (existing `SKILL.md` /
  `living-checklist.md` / `revisionslog.md` files stop being valid under the new
  spec, or a session ritual changes shape).
- **MINOR** — new examples, non-breaking framework additions, new templates or
  setup docs.
- **PATCH** — documentation fixes, typo corrections, clarifications that do not
  change behavior.

Per-skill `revisionslog.md` files version each Skill's own evolution and are
independent of the repository version.

> **Note:** The repository was re-created with version 2.0.0. Earlier versions listed below
> are kept as a description of how the framework evolved; their tags and releases are no
> longer available.

## [2.0.0] — 2026-10-04

### Changed — breaking file name
- **`Skill.md` → `SKILL.md`** everywhere (examples, templates, `Infrastructure/`), with every
  reference updated. Reason: Claude Code only discovers skills whose entry file is named
  exactly `SKILL.md`; on case-sensitive file systems `Skill.md` is never found.
  `revisionslog.md` keeps its name. Existing repositories should rename with `git mv`.

### Added
- `examples/playwright/` (domain skill) and `examples/strategy/` (a department with a head
  skill and two roles), both as templates with illustrative entries.
- `setup/obsidian-sync.md`, `scripts/sync-obsidian-mirror.py`, `scripts/sync-obsidian-git.sh`:
  Obsidian as the human-readable layer. Markdown-only, three-way mirror between repo and vault
  (vault-only change → imported, repo-only change → exported, both → stop without
  overwriting; deleted in the vault → restored, deleted in Git → `.obsidian-sync-trash/`).
  The git wrapper commits vault edits with the human as author and the agent instance as
  committer, and commits nothing above 15 changed files or on any deletion/rename. Scheduling
  example as a macOS LaunchAgent. `setup/sync-setup.md` points to it.
- `setup/skill-mapping.md`, `scripts/generate-claude-skills.sh`: skills mapped into
  `~/.claude/skills/<name>/` as symlinks into the repo — a card index, not a copy.
- `framework-organisation.md`: new chapter on departments and roles — line departments vs
  staff functions, department heads as the human entry point, staffing status, and the rule
  that a vacant role is reported as `Vacant` and never silently simulated. Linked from
  `framework.md` and `README.md`.
- `examples/pair-review/` and `examples/skill-creator/`. The latter fixes the dead link in
  `setup/quickstart.md`.
- Examples are published as **templates**: every example `living-checklist.md` holds two
  illustrative entries (dated `YYYY-MM-DD`, marked `*illustrative*`), every `revisionslog.md`
  a single template row. No real observations are published; adopters replace the entries
  with their own.
- `framework.md` §7: project documents belong in `Projects/<project>/`; instance names
  (recorded in the instance's grounding document and the team table); optional reflection
  loop in `Team Memory/shared/reflections/`; SessionStart hook as a reference.

### Changed
- Siyuan skill marked **deprecated** — kept as an optional example of a human-readable layer.
  README, `known-gaps.md` and `TEAM.md` no longer call the human layer solved for Siyuan.
- `known-gaps.md`: *Human-Readable Layer* updated for the Obsidian mirror; *Skill
  Distribution Drift* notes that the symlink mapping partly solves it for Claude Code.
- `TEAM.md` Session End runs `generate-claude-skills.sh` instead of `generate-cursor-rules.sh`.
- Cursor instructions marked "not actively tested in recent releases; generator kept for reference".
- `## Distilled Rules` is now a rule for checklists with more than 50 entries.
- `unconfirmed` / `Observed by:` is now **optional** — verifying before writing, through
  review and counter-tests, is often more practical than confirming later.
- Domain skills state `Knowledge checked: <date>, against <system/version>` instead of the
  knowledge-age line; added to the domain-skill template.

## [1.4.0] — 2026-08-09

### Added
- `examples/surgical-changes/`: new behavioral example. Keeps edits traceable to the request
  through three artifacts — a **scope contract** written before the first file is touched
  (naming the files, what changes in each, what is explicitly out of scope, and the
  verification), a **diff audit** afterwards that classifies every hunk as **R**equested,
  **O**rphan-cleanup or **U**nrequested and reverts all U, and a **noticed-list** that gives
  adjacent problems a destination other than the diff. Includes a threshold table, so the
  procedure is not spent on typos, and a *How to know it's working* section naming the
  observable signals by which the skill can be judged.
- `README.md` *Intellectual Foundation*: row for
  [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)
  by Forrest Chang (MIT), which condenses
  [Karpathy's observations on LLM coding pitfalls](https://x.com/karpathy/status/2015883857489522876)
  into four principles. Three of them are the substance of the new example. Marked in the
  table as a content source for one example rather than a framework concept — the first
  entry of that kind.
- `TEAM.md`: `surgical-changes` added to *Available skills*; `.cursor/rules/living-skills.mdc`
  regenerated from it.

### Changed
- `CONTRIBUTING.md` *A Note on Attribution*: states that individual examples may carry their
  own sources, credited in the `## Source` section of their `Skill.md` and in the README table.

### Note
- The new example's `living-checklist.md` entries are **seeded** from the source material,
  not drawn from sessions that applied the skill, and are marked `unconfirmed` accordingly.
  Both the checklist and the README say so explicitly. This is a documented exception to the
  contribution rule against pre-filled checklists, not a silent one — the alternative was an
  empty learning layer, which teaches the format worse.

## [1.3.0] — 2026-07-26

### Added
- `known-gaps.md`: new entry **Tamper-Evidence and the Value/Knowledge Layer Split**. Reframes
  the framework's instruction/values firewall as a *consequence* of where an external anchor
  ends rather than a first principle, and opens the question it surfaces: what protects the
  shared record itself from silent alteration. Names the relevant property as *tamper-evidence*
  (not immutability) and records three concrete sub-questions — (A) commit **signing** as
  tamper-evidence, with SSH signing and an in-repo `allowed_signers` file that is itself a
  signed constitutional artifact; (B) structurally **separating** the change-expensive values
  layer from the freely-growing knowledge layer; (C) a documented, visible **amendment path**
  for the values layer. Design question only — nothing in the framework spec changes.

### Meta
- Commits and tags in this repository are now **SSH-signed** where produced by a
  signing-capable instance; an `allowed_signers` file is tracked in-repo so any clone can
  verify signatures locally. Note: agent/bot committer identities that map to no GitHub
  account are verifiable locally but do not receive GitHub's "Verified" badge.

## [1.2.0] — 2026-07-25

### Added
- `framework.md` §3: **Confirmation status** for checklist entries. A new entry is marked
  `*unconfirmed (1 observation)*`; the marker is removed when a **different** instance hits
  the same pattern independently and appends itself to `Observed by:`. Unconfirmed entries
  never expire — the marker describes the evidence, not a countdown. Adapted from the
  PRIMARY/SECONDARY source tiering in
  [allexp1/living-skills](https://github.com/allexp1/living-skills) by Alex Pritsert, with
  the axis moved from *sources* to *instances*: this framework's knowledge comes from its
  own application, so corroboration means a second observer, not a second document.
- `framework.md` §2: **`living-checklist: yes | no`** frontmatter field (plus
  `checklist-rationale` when `no`). Not every skill should learn — a purely procedural skill
  has no experience to accumulate, and an empty checklist attached to it is indistinguishable
  from a broken learning loop. Directly adopted from allexp1/living-skills.
- `framework.md` §8: **Knowledge age** in the activation output of Type B (domain) skills —
  date of the most recent checklist entry and its age in days, stated without judgement.
  Adopted from that project's K4 invariant ("honest staleness"), narrowed to domain skills:
  methodology does not age against an external clock.
- `known-gaps.md`: new entry **External Knowledge Layer for Knowledge-Bearing Skills** —
  records the sourced-knowledge-layer question, and why the fully worked solution in
  allexp1/living-skills was not adopted here.

### Changed
- `framework.md` §7 (*Instance Identity in Entries*): **reverses an earlier rule.** Entries
  now carry instance attribution via `Observed by:`. The previous rule called attribution
  unnecessary because identity is visible in the Git commit; that fails once a checklist is
  copied into a published example or packaged export, and confirmation status is not
  expressible without naming instances. Published examples use neutral placeholders
  (`instance-a`, `instance-b`).
- `framework.md` §11: the "no lifecycle management" stance is now scoped explicitly. It holds
  for methodology; for domain skills asserting facts about live external systems, the
  framework's answer is **disclosure, not control** — a stated date, no threshold, no warning,
  no scheduled review, no automatic refresh.
- `known-gaps.md`: *Checklist Conflict Resolution at Scale* — its open question on instance
  attribution is answered by §7. *Learning-Loop Observability* — the §8 knowledge-age line is
  a partial answer for domain skills; the gap stays open for behavioral skills.

### Fixed
- `Infrastructure/skills/siyuan` example — `scripts/check-siyuan-edits.sh`: false positives in
  human-edit detection fixed (timestamps without timezone offset are now interpreted explicitly;
  pipelines no longer fail under `set -o pipefail` on large inputs; title sanitization is applied
  consistently in both scripts).

### Changed
- `known-gaps.md` — the *Human-Readable Layer as Two-Way Channel* entry: roundtrip-noise
  estimate corrected, plus a residual note on container nodes that hold content without a
  source file.

### Notes
- **Grandfathering:** confirmation status and `Observed by:` apply to **new** entries only.
  Existing entries remain valid unchanged and are never retrofitted — the instance and
  corroboration history of a past session cannot be reconstructed, and inventing them would
  corrupt the layer that exists to record where a claim came from. No existing skill,
  checklist, or example becomes invalid under this release.
- Attribution for the three adopted concepts is recorded in the *Intellectual Foundation*
  table in `README.md` and in `CONTRIBUTING.md`, as committed to in
  [allexp1/living-skills#1](https://github.com/allexp1/living-skills/issues/1). The two
  projects share a name by coincidence and were developed independently.

## [1.1.0] — 2026-07-10

### Version history note

The GitHub release `v1.0.0` (2026-04-25) predates the adoption of SemVer in this
repository. When SemVer was introduced on 2026-06-20, the then-current state was tagged
`v0.3.0` — which is therefore **newer content than v1.0.0** despite the lower number.
This release restores a monotonic version line: `v1.0.0` (Apr) → `v0.3.0` (Jun,
pre-SemVer numbering anomaly) → `v1.1.0` (this release). The `v1.0.0` tag is kept
as-is to avoid breaking existing links.

### Added
- Additional `living-checklist.md` entries in all four behavioral examples
  (`advocatus-diaboli`, `secure-architecture`, `business-analysis`,
  `token-optimization`). Superseded in 2.0.0, where all example entries became
  illustrative template entries.
- `framework.md` 0.3:
  - **Entry Discipline** (§3): entry threshold ("would this go wrong again?"), ~120-word
    length guidance, genericization rules for shared repos, recommended `## Management`
    block per checklist.
  - **Staging Layer for Raw Learnings** (§7): the `Team Memory/shared/meta-learnings.md`
    pattern — capture → cluster → promote pipeline that answers "when does a learning
    justify a skill?".
- `known-gaps.md`: two new entries — **Learning-Loop Observability** (a silent checklist
  is indistinguishable from a broken write-back loop; optional `Last applied:` mitigation
  proposed) and **Skill Distribution Drift** (no canonical source across production copy,
  published example, and packaged variants; snapshot-marker guidance).
- `known-gaps.md`: operational caveat on the sync entry — full-state knowledge-base sync
  must be `&&`-chained after a successful `git push` (last-push-wins).
- `setup/team-charter-setup.md`: new **Operational guardrails** section — the charter as
  the living checklist of the environment itself (snapshots before risky work, regenerate
  generated files, sync ordering).
- `TEAM.md`: `secure-architecture` and `business-analysis` added to the available-skills
  table (they existed as examples since 0.3.0 but were missing from the table).

### Changed
- `README.md` Status section: corrected the claim that session rituals are "enforced via
  CLAUDE.md hooks". `CLAUDE.md` is context, not a hook — reliable in practice, but
  instruction-following, not a technical guarantee. Real enforcement via Claude Code's
  hook system is referenced as a host-setup option. The Cursor claim is now
  aligned with `known-gaps.md`.
- `README.md` Problem Definition: acknowledges that newer agent tools ship file-based,
  inspectable memory and native skill formats; sharpened what remains missing (cross-tool
  team layer, method learning loop, versioned shared state).
- `README.md` Example Skills note updated for the additional entries.

## [0.3.0] — 2026-06-20

### Added
- New behavioral example skill: [`examples/secure-architecture/`](examples/secure-architecture/).
  Seven-layer authorization design checklist: AuthN vs AuthZ separation,
  authorization anchored on stable IDs (not mutable fields), Separation of Duties
  enforced in the data model rather than the UI, protection of authorization
  records themselves, architectural coherence across ADRs, explicit demo facade
  vs. production foundation, and Interface + Adapter isolation for external
  dependencies. Ships with an illustrative `living-checklist.md` covering OTP
  misuse, mutable-field auth anchors, UI-only SoD, and unprotected grant/revoke
  endpoints.
- New behavioral example skill: [`examples/business-analysis/`](examples/business-analysis/).
  Seven-step BABOK/CBAP procedure: Executive Summary & Business Need →
  Stakeholder Analysis → User Personas → Epics and User Stories with binary
  acceptance criteria → Functional and Non-Functional Requirements (with
  measurable criteria, not intent) → Gap Analysis (As-Is → To-Be) → Risk
  Register and Out-of-Scope. Ships with an illustrative `living-checklist.md`
  covering security NFRs at the wrong altitude, empty Out-of-Scope sections,
  non-UI stakeholders mis-templated as portal users, and late glossaries.
- `CHANGELOG.md` (this file).

### Changed
- `README.md`: replaced the "Extensions (Untested)" section with a single
  "Example Skills" reference table. `token-optimization` is now listed as a
  standard example alongside `advocatus-diaboli`, `secure-architecture`,
  `business-analysis`, and `home-assistant`. The "untested" caveat on the
  proactive-activation rule was removed.

### Notes
- All `living-checklist.md` entries in the public examples are **illustrative**:
  plausible patterns shown in the correct format, not entries copied from real
  client or internal work. This is now stated explicitly in the README.
- The framework spec (`framework.md`) is unchanged in this release.
