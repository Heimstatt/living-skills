# Living Skills — Known Gaps and Open Questions

Open design questions without a resolved solution.
Do not implement without thinking through the implications first.

---

## Human-Readable Layer as Two-Way Channel

**Status:** Addressed for Obsidian by a Markdown mirror (see below and
[`setup/obsidian-sync.md`](setup/obsidian-sync.md)). The Siyuan approach recorded here is
**deprecated** and kept as a historical example — open for other tools

**Problem:** The sync between Git and a human-readable knowledge base (Siyuan, Obsidian, Notion)
was one-directional: agents write to Git, sync pushes to the knowledge base, but human
edits in the knowledge base never flow back to agents.

**Solution (Obsidian, current):** A Markdown-only mirror between repository and vault
(`scripts/sync-obsidian-mirror.py`) with a three-way comparison against the last common state:
a file changed only in the vault is imported, one changed only in the repository is exported,
one changed on both sides stops the run without overwriting anything. A file deleted in the
vault is restored from the repository; a file deleted in Git is moved to
`.obsidian-sync-trash/` in the vault. A scheduled wrapper (`scripts/sync-obsidian-git.sh`)
commits vault edits with the human as author and the agent instance as committer, and commits
nothing when more than 15 files changed or anything was deleted or renamed. Human edits thus
reach agents as ordinary commits — no timestamp heuristics. Remaining limitation: renaming or
moving folders inside Obsidian looks like new files to the sync; renames belong in the
repository (`git mv`). See [`setup/obsidian-sync.md`](setup/obsidian-sync.md).

**Former solution (Siyuan, deprecated):** Two mechanisms working together:

1. **Diff-before-write sync** (`sync-to-siyuan.sh`): Only updates documents whose content
   actually changed (word fingerprint comparison). Unchanged documents keep their Siyuan
   timestamp. This is the key enabler — without it, every sync refreshes all timestamps
   and human edits become invisible.

2. **Human edit detection** (`check-siyuan-edits.sh`): At session start, compares Siyuan
   document timestamps against the last Git commit timestamp (+ 2-minute buffer for sync
   delay). Any document with a newer timestamp was edited by a human. The agent reads the
   edits, incorporates them into the session, and the normal session-end flow (git push →
   sync) writes the merged result back to both Git and Siyuan.

```
Session start:  git pull → check-siyuan-edits.sh → agent sees human edits
Session work:   agent incorporates human input into its work
Session end:    git push → sync-to-siyuan.sh → complete state in both systems
```

**Known limitation:** Some documents have Markdown roundtrip differences (Siyuan's
parser changes formatting on export). These get rewritten every sync and show as false
positives in the edit check. See `Infrastructure/skills/siyuan/SKILL.md` for details.

**Design caveat:** Timestamp-based edit detection is only sound if both compared timestamp
sources are provably in the same timezone. Knowledge bases that store bare, offset-less
local timestamps must be normalized explicitly before comparison, and shell pipelines in
the check must not silently abort under `set -o pipefail` on large inputs — either defect
turns the check into noise or truncates its results.

**Residual note:** The edit check also reports knowledge-base folder/container nodes that
carry content but have no corresponding source file. This is likely not a bug: a human can legitimately write
content directly into a container node of the knowledge base, and flagging that as a
human edit is defensible behavior. Tracked here as an open, by-design-uncertain
question rather than something to fix.

**Operational caveat:** The sync script writes the **full repository
state** to the knowledge base — whoever syncs last writes everything. The sync must
therefore be chained strictly after a successful `git push` (`… && sync-script`), never
run standalone: an instance that syncs without having pushed (or pulled) first can
overwrite newer knowledge-base content with its stale local state. Last-push-wins is
acceptable only because Git remains authoritative and push fails on a non-fast-forward.

**Notion / Logseq:** Same problem, different APIs. For tools that work on plain Markdown
files, the Obsidian mirror pattern should carry over; otherwise the timestamp-based approach
should work if the knowledge base exposes document modification timestamps
and supports content comparison before write. Contributions welcome.

---

## Cursor Does Not Reliably Execute Session Rituals

> This gap is one instance of a general point: instructions are not guarantees.
> See "Software 3.0: Text Is the Program, Code Is the Guard Rail." in the README and
> "Instruction or Enforcement" in framework.md.

> Cursor: not actively tested in recent releases; generator kept for reference.

**Status:** Known limitation — no solution at the framework level

**Problem:** Cursor reads `.cursor/rules/*.mdc` files correctly, but does not enforce
session rituals (pull before starting, commit after finishing) with the same reliability
as Claude Code.

Claude Code loads `CLAUDE.md` as context on every session and follows it reliably in
practice. That is instruction-following, not enforcement; enforcement needs a hook.
Cursor has no equivalent lifecycle hook. The rules
are loaded as guidelines, not enforced pre/post-conditions.

As a result, Cursor can start work without pulling first and complete sessions without
committing — even when the rules explicitly require both.

**Root cause:** Structural gap in Cursor's execution model, not a configuration problem.
The `.cursor/rules/` format and content are correct. Cursor simply does not enforce
them the way Claude Code enforces `CLAUDE.md`.

**Impact:** In multi-instance setups with Cursor, uncommitted local changes can block
a `git pull` on the next session. This requires manual conflict resolution and loses
the seamless handoff the framework is designed to provide.

**Mitigation:** Human oversight at session start and end when Cursor is involved.
A brief reminder ("pull first", "commit now") is usually sufficient.
Documented in [agent-configuration.md](setup/agent-configuration.md).

**What would fix it:** A Cursor feature equivalent to Claude Code's `UserPromptSubmit`
hook — a mechanism to execute commands before Cursor responds. Not available today.

---

## Context-Dependent Tool Identity

**Status:** No general solution — workarounds documented

**Problem:** Global agent configuration (e.g. `~/.cursor/rules/identity.mdc` with `alwaysApply: true`)
applies the team identity in ALL repositories — including private projects without team context.

**Desired behavior:**
```
Private repo    → no team identity, normal agent behavior
Team repo       → team identity activated
```

**Root problem:** The trigger must come from the repo ("I am a team repo"),
the identity must come from global config ("that is who I am") —
but the connection between them is missing.

**Possible approaches:**
- Marker file in repo (`.living-skills-team`) + conditional rule description — reliability untested
- Repo-scoped global rules — not natively supported by most tools
- Manual activation at session start — simple but not automatic

**Scope:** Affects any user running this framework alongside private projects.
Requires tool-specific testing.

---

## Checklist Conflict Resolution at Scale

**Status:** Conflict handling open — the attribution question is answered

**Problem:** When multiple instances write to the same `living-checklist.md` in parallel,
Git can produce merge conflicts. The append-only convention reduces this significantly,
but does not eliminate it entirely.

**Current guidance:** Keep both versions — never delete another instance's entries.
See `setup/sync-setup.md` for conflict resolution steps.

**Resolved:** Yes. Entries carry instance attribution in the `Observed by:`
line — see `framework.md` §7, which reverses the earlier rule that commit history was
sufficient. Two reasons decided it: commit provenance does not survive a checklist being
copied into a published example or packaged export (see *Skill Distribution Drift* below),
and the confirmation status introduced in §3 cannot express "a different instance hit this
independently" without naming instances. Traceability was the smaller benefit.

**Still open:** the merge-conflict handling itself. Attribution makes a conflict easier to
read, but the resolution is still manual and still governed by convention rather than
tooling.

---

## Learning-Loop Observability — a Silent Checklist Is Ambiguous

**Status:** Open — optional mitigation proposed, not yet part of the spec

**Problem:** The framework claims that skills improve through use, and deliberately has
no lifecycle management (see `framework.md` §11: a dormant skill is not stale). The cost
of that stance: a `living-checklist.md` that has not changed in months is
**indistinguishable** from a skill that is not being used at all — or one that is used
but whose write-back ritual silently stopped happening. From inside the system, "it
works quietly" and "the loop is broken" look identical.

This shows up when the framework is reviewed against actual use: some checklists grow
steadily under project pressure while others stay silent for months, and nothing in the
repository can tell the two failure modes apart.

**Proposed mitigation (optional, non-breaking):** At session end, when a skill was
applied but produced no new learning, update a single header line in the checklist:
`Last applied: YYYY-MM-DD (no new learnings)`. Usage becomes visible without forcing
meaningless entries. Not yet adopted into `framework.md` — needs testing for noise
(one-line diffs on every session) versus value.

**Partial answer:** For **domain skills only**, the activation output now states
the date of the most recent checklist entry and its age in days (`framework.md` §8). That is
a real observable signal where it applies: a domain skill whose knowledge has not moved in
months now says so out loud instead of looking identical to one that was updated yesterday.
It does not close this gap. The line reports the age of the newest *entry*, not whether the
skill was *applied* — a skill used weekly without producing learnings still shows a growing
number. And **behavioral skills carry no such line at all** (methodology does not age against
an external clock), which is where the silent-checklist ambiguity matters most. For Type A skills the gap is untouched, and the `Last applied:` mitigation above
remains the only candidate.

**Check for reviewers:** For any claimed automatic/emergent property, ask: "What
observable signal would distinguish 'it works silently' from 'it stopped happening'?"

---

## Skill Distribution Drift — No Canonical Source Across Copies

**Status:** Guidance documented — automation open

**Problem:** A successful skill ends up existing in several places: the working copy
in a team repository, the published example in this repository, and packaged variants
for stateless environments (plugin bundles, ZIP exports for chat-based tools). These
copies diverge silently — different language, different modes, one copy loses the
learning layer entirely. Exactly the drift problem that `generate-cursor-rules.sh`
solves for `TEAM.md` is unsolved at the skill level.

**Current guidance:**
- Declare **one** copy canonical — normally the working copy in the team repository,
  because it is the only one attached to a living checklist.
- Treat every published or packaged copy as a **snapshot** and mark it as such in the
  file itself (e.g. "snapshot of `<repo>` `<skill>` as of YYYY-MM-DD"), so a reader can
  tell which version they are holding and where the current one lives.

**Open question:** A generator/check script (canonical → snapshots, or at least a drift
warning) analogous to the Cursor rules generator. Contributions welcome.

**Partly solved for Claude Code:** Within one team, `scripts/generate-claude-skills.sh`
maps every skill in the repository into `~/.claude/skills/<name>/` as a **symlink**, not a
copy, so the tool reads the canonical files directly and no local copy can drift. Each instance
re-runs it when skills are added, renamed or removed. This does not cover published examples
or packaged exports outside the repository — those remain snapshots. See
[`setup/skill-mapping.md`](setup/skill-mapping.md).

---

## Multi-Agent Coordination Needs a Host-Level Team Charter

**Status:** Framework gap clarified — partially solved only when the host repo adds it

**Problem:** Living Skills defines skills, checklists, revision logs, and generic write
boundaries, but a real team still needs repository-specific coordination rules:
- who the active instances are
- who writes where
- what is collaborative vs. read-only
- which commands define session start and session end in that environment
- how identity, local paths, and credentials are configured

Without that layer, the framework is strong enough for a single user or a loose setup,
but multi-agent collaboration becomes underspecified.

**Important distinction:** This is not an argument for a hidden orchestration system.
The missing piece is not a selection engine or hardcoded routing logic. It is an explicit,
human-readable team charter in the host repository.

**Current guidance:** Add a host-specific `TEAM.md` (or equivalent) to any real multi-agent
repository using Living Skills. The framework now documents this requirement in `README.md`
and `framework.md`, but does not try to standardize one universal team model.

**Why this remains a framework gap:** The public framework originally described the knowledge
architecture more clearly than the team-operating layer. Teams may discover this
only after they run multiple agents against the same repo.

---

## External Knowledge Layer for Knowledge-Bearing Skills

**Status:** Open — deliberately not solved; decision deferred to evidence

**Problem:** A domain skill (Type B) asserts facts about a live external system: a version,
an endpoint, a path, an upgrade procedure. Those facts can stop being true without anyone
touching the file, and the file's own silence is what hides it. This framework's learning
loop cannot catch it: the loop records what happened during the team's own application of the skill,
and nothing happens when a third-party system changes and the team simply does not use the
skill that week. The framework's only current answer is disclosure — `framework.md` §8 states the
age of the knowledge in the activation output, and `framework.md` §11 stops there on
purpose. Disclosure is not a mechanism. It relies entirely on a human reading a number and
drawing the right conclusion.

**A worked solution exists elsewhere.** Alex Pritsert raised this question and answered it
in [allexp1/living-skills](https://github.com/allexp1/living-skills): the skill stays
immutable, and a sidecar layer beside it holds world knowledge drawn from curated primary
sources, with trust tiers over those sources, a refresh cycle driven by a staleness clock,
and a provenance changelog recording where each fact came from and when it was last
verified. It is a coherent design and it addresses exactly the failure mode described
above. Attribution note: the three concepts this framework *did* adopt from that project
are credited in `README.md`.

**Why it has not been adopted here:**

1. **It is a second subsystem, not a commit.** Sidecar files, source curation, tiering,
   a refresh procedure and a provenance log are an ongoing operational surface. Adding it
   is a build, and it has to be maintained for as long as it exists.
2. **It collides head-on with `framework.md` §11.** "Not a RAG system", "no review
   schedules", "no automatic refresh" are stated commitments, not oversights. Adopting a
   refresh cycle would not be an extension of this framework; it would change what the
   framework is. That is an identity decision and should be taken as one, in the open —
   not arrived at by accretion.
3. **It is unproven.** Not only here: the originating repository is at one commit with one
   example. Two projects independently identifying a problem is evidence that the problem
   is real. It is not evidence that this particular solution works over time.
4. **There are no measurements.** It is unknown how often domain knowledge in a skill is
   actually wrong, how the errors surface, or what they cost. Building a correction mechanism
   before knowing the error rate risks paying a permanent maintenance cost for a rare
   failure.

**What would move this:** evidence. Concretely — instances recording, when a domain skill
misleads them, that the cause was stale knowledge about the external system rather than a
gap in the skill. If that pattern accumulates in real checklists, the case for a knowledge
layer is made from the team's own data and the §11 question can be reopened honestly. If it does
not accumulate, disclosure was enough. Either way the decision should fall on evidence, not
by quietly introducing refresh machinery through a side door.

---

## Tamper-Evidence and the Value/Knowledge Layer Split

**Status:** Open — design question

**The principle.** This framework already forbids the machine from autonomously rewriting its
own instructions/method, while allowing it to update its beliefs (see `framework.md` on the
checklist boundary). The sharper way to state *why*: a layer may be safely self-mutated only
when it has an external ground truth to snap back to. Beliefs anchored to primary sources are
self-correcting; the method/values layer has no such anchor, so an error there is permanent and
self-propagating. The firewall is therefore not a first principle — it is a *consequence* of
where the anchor ends.

That reframing surfaces a gap the framework does not yet address: **what protects the shared
record itself from silent, illegitimate alteration?** The relevant property is not
*immutability* but *tamper-evidence* — not "the record cannot be changed" but "it cannot be
changed *silently*." Immutability is brittle (it freezes a wrong entry forever, un-correctable);
a freely and silently editable record is the Ministry-of-Truth failure mode. The target is
change that is *possible but expensive, visible, attributed, and reversible*. A corollary worth
stating plainly: a base assumption does not have to be *correct* to be valuable — it only has to
stay *findable*. A wrong-but-dated-and-attributed entry can be corrected while showing the path
of the correction; a "correct" one whose origin was smeared cannot. **Provenance is the anchor
the un-anchorable layer can actually have.**

**Three concrete sub-questions:**

- **(A) Signing as tamper-evidence.** Git gives provenance and tamper-evidence for free at the
  *mechanical* level (who/when/what) — but only to the degree the commit chain is actually
  **signed**. Recommended approach for multi-instance teams: **SSH commit signing** (Git ≥ 2.34;
  `gpg.format ssh`, `commit.gpgsign true`), which is far lower-friction than GPG for a fleet of
  agent identities (no keyring, agent, expiry, or web-of-trust). Cross-instance verification uses
  an OpenSSH `allowed_signers` file kept **in the repository**, one line per identity, so every
  instance can verify every other's commits locally, offline, with no central authority. **The
  recursive catch:** that `allowed_signers` file is *itself* the tamper surface (add a rogue key
  → forge anyone), so it must itself be a signed constitutional artifact governed by the same
  rule as the instruction files — its history *is* the chain of trust. This is the firewall
  argument applied to its own root: the trust root has no external anchor either, so it is
  anchored by being treated as constitution. **Honest limitation:** a forge's "Verified" badge
  (e.g. GitHub's) only validates signatures against a real account whose verified email matches
  the committer; agent/bot identities that map to no such account can be verified *locally* via
  `allowed_signers` but will not show "Verified" on the forge. The forge badge is therefore not
  the tamper-evidence mechanism — local verification is.

- **(B) Separating the value floor from the knowledge layer.** The instruction/values layer and
  the mutable-knowledge layer typically live in the same repository flow, undifferentiated. They
  need *different* treatment: hard, signed, change-*expensive* rules for the values layer; light,
  provenance-tracked, freely-growing entries for the knowledge layer. Making the seam explicit is
  "the firewall goes where the anchor ends" made buildable — and it is the same seam the External
  Knowledge Layer gap (above) gestures at. **Note:** the knowledge layer must **not** be made
  immutable — freezing it would kill the learning loop; it needs provenance + detectability, not
  rigidity.

- **(C) A visible amendment path.** If the values layer is change-hard, the framework still needs
  a documented *front door* for the rare legitimate change — otherwise "hard" degrades into
  either brittleness or silent side-door edits. Candidate shape: a change to a boundary rule
  requires a signed commit + a written rationale + human sign-off, and never flows through the
  learning loop. This operationalizes upgrading the firewall from a *policy* ("we promise not to
  change the method") to a *property* ("the method cannot be changed silently").

**The line that ties A/B/C together:** build the values layer to be **tamper-evident and
amendment-hard, not amendment-impossible.**

**Caution against over-building.** The dependence on custodial good faith has no purely
structural fix, and that is acceptable — the goal is not a lock but to make abuse *visible,
costly, and answerable*, which A+B+C deliver. Chasing an "impossible" immutability would only
freeze the wrong floor forever. Sub-parts B and C also touch the `framework.md` §11 commitments
at the edges and are an identity decision to be taken deliberately, in the open — not by
accretion. (A) is the smallest, cleanest first step: a real integrity gain requiring no identity
decision.
