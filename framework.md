# Living Skills — Framework Specification

**Version:** 0.3
**Status:** Draft

See also: [Departments and Roles](framework-organisation.md) — organising skills into
departments, staff functions and staffed roles.

---

## 1. File Structure (Required)

Every Living Skill is a directory containing exactly these three files:

```
<skill-name>/
├── SKILL.md              # REQUIRED
├── living-checklist.md   # REQUIRED
├── revisionslog.md       # REQUIRED
└── scripts/              # OPTIONAL — executable code the agent can call
    ├── setup.sh
    ├── check-status.py
    └── ...
```

Additional files are allowed, but the three core files are not optional.
A directory missing any of them is not a Living Skill.

---

## 2. SKILL.md — Specification

### Frontmatter (Required)

```yaml
---
name: "<Human-readable name, max 64 characters>"
description: "<What the skill does AND when to trigger it — specific, max 200 characters>"
type: "behavioral | domain"
living-checklist: "yes | no"
checklist-rationale: "<one line — required only when 'no'>"
---
```

**On description:** Write "pushy" — AI models tend to undertrigger skills.
Instead of: "Helps with debugging automations"
Write: "Use for ANY Home Assistant work — debugging, new automations, entities, updates"

**On `living-checklist`:** Not every skill should learn. A skill that encodes a fixed
procedure — a naming convention, a release checklist, a file layout — has no experience
to accumulate. Attaching a checklist to it produces an empty file that looks like a
broken learning loop rather than a deliberate decision.

Declaring the field makes the decision explicit and auditable. Without it, "this skill
has no checklist" and "somebody forgot the checklist" are indistinguishable from the
outside. Skills that declare `no` are skipped by the checklist steps of the session
rituals; everything else in the framework applies unchanged.

### Required Body Sections

**For Behavioral Skills (Type A):**
- `## Session Start` — what to read, what to load
- `## Process` — step-by-step approach
- `## Stop Criteria` — when is the session successfully complete?
- `## Session End` — what to write back

**For Domain Skills (Type B):**
- `## System Reference` — access details, paths, configuration
- `## Proven Approaches` — what reliably works
- `## Session Start` — read living-checklist before working
- `## Session End` — write learnings back

### Length

Target: under 300 lines. Under 500 lines acceptable.
Over 500 lines: move content to a `references/` subdirectory, link from SKILL.md.

---

## 3. living-checklist.md — Specification

### Header (Required)

```markdown
# Living Checklist — <Skill Name>

**Purpose:** Accumulated learnings. Extended after every session.
```

### Entry Format (Required)

Every entry follows exactly this format:

```markdown
### [YYYY-MM-DD] — [Task context] · *unconfirmed (1 observation)*
**Learning:** What was discovered / what failed
**Why it matters:** Context and consequences
**Rule:** Concrete actionable guideline for future sessions
**Observed by:** <instance> (YYYY-MM-DD)
```

### Confirmation Status

A learning drawn from a single session is a hypothesis. A learning that a *different*
instance hit independently is a pattern. The format distinguishes the two.

- A new entry is marked `*unconfirmed (1 observation)*` in its heading.
- An entry counts as confirmed when a **second instance has reproduced the finding
  itself**, for example in a review, and links to that review. Agreeing with the text is
  not enough. The confirming instance **removes the marker** and appends itself, with
  the link, to `Observed by:` — it does not open a second entry.
- Seeing the pattern again is not the same as reproducing it. If the same or another
  instance merely meets the pattern again in a later session, it notes that in
  `Observed by:` as `seen again by …`. The marker stays until someone has reproduced the
  finding.
- Unconfirmed entries never expire and are never deleted (see *Growth*). Moving a superseded
  entry to the archive section is not deleting it. The marker is information about the
  evidence, not a countdown.

```markdown
**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD, [review](link))
```

**This status is optional.** Many teams verify before writing, through review and
counter-tests, rather than confirming later. A team that verifies an entry before it is
written may omit the marker and the `Observed by:` line; a team that writes first and
corroborates later should keep both.

Single-instance setups that use the marker mark entries `unconfirmed` and leave them there. The status still
carries meaning: it records that the learning rests on one observation.

### Grandfathering

Entries written before this format was introduced remain valid as they are. Confirmation
status and `Observed by:` are required for **new** entries only. Historical entries are
never retrofitted — the instance and the corroboration history of a past session cannot
be reconstructed, and inventing them would corrupt the layer that exists to record where
a claim came from.

### Quality Criteria for Entries

A good entry is:
- **Specific** — not "triggers can be wrong", but "some Zigbee bulbs report `off` briefly before `on` on boot — use `from: [unavailable, unknown, 'off']`"
- **Actionable** — the Rule must be directly applicable, not an abstract principle
- **Contextualized** — date and task type, so future instances can judge relevance
- **Model-agnostic** — avoid model-specific phrasing; the entry should be useful for any instance

### Entry Discipline

Checklists tend to degrade in two directions: too many trivial
entries (noise drowns the signal) and entries that drift back toward case-specific war
stories (unusable outside the original project).

- **Entry threshold:** Add an entry only if the answer to *"would this go wrong again
  without the reminder?"* is yes. An empty session is better than a filler entry.
- **The threshold and the status work together:** the threshold used to force a
  yes/no judgment at the moment of greatest uncertainty — immediately after a single
  incident, with no way to tell an anomaly from a pattern. The `unconfirmed` marker
  gives that judgment somewhere to live. Record the observation; let a second instance
  decide whether it was a pattern. The threshold still applies — an unconfirmed entry
  is not a licence for filler — but a genuine one-off observation no longer has to be
  either overstated or lost.
- **Length:** Aim for under ~120 words per entry. If an entry needs more, it is usually
  carrying case detail that belongs in the project's own files, not in the skill.
- **Genericization (shared repos):** No project names, no internal IDs, no client
  references. Strip the case, keep the pattern. If the pattern does not survive the
  stripping, it was case knowledge, not a learning.
- **Management block (recommended):** Skills may document their own threshold and archive
  rules in a `## Management` section at the top of the checklist, so every instance
  applies the same discipline.

### What Does NOT Belong in living-checklist

- Facts that change frequently (→ update SKILL.md System Reference instead)
- Task-specific details with no reuse value
- Personal preferences without reasoning

### Two Distinct Knowledge Types

SKILL.md and living-checklist.md contain fundamentally different types of knowledge
and must not be conflated:

**SKILL.md** holds authoritative domain knowledge — the method, framework, or reference
that exists independently of your usage. Examples: the Scrum Guide for a Scrum skill,
BABOK for a business analysis skill, a legal text for a compliance skill, a technical spec
for an integration skill. This knowledge does not change because of your application experience.
SKILL.md is updated only when the underlying knowledge itself changes (new framework version,
revised specification, updated methodology).

**living-checklist.md** holds application experience — what works and what doesn't when
applying that knowledge in this specific context. This layer grows with every session.
It is never merged back into SKILL.md. The two layers are complementary, not overlapping.

### Growth

The living-checklist grows without limit. Older entries are never deleted.
This includes entries that stayed `unconfirmed`: a learning no second instance ever
reproduced is still the record of something that happened once, and removing it would
delete evidence rather than noise.
Above 50 entries: a `## Distilled Rules` summary section at the top is **required** —
a short list of the rules that currently hold, distilled from the entries. Chronological
entries remain intact below; the distilled rules summarise them, they never replace them.

---

## 4. revisionslog.md — Specification

### Format

```markdown
# Revision Log — <Skill Name>

| Date | Version | Change | Reason |
|------|---------|--------|--------|
| YYYY-MM-DD | 1.0 | Initial skill | Created from <source> |
```

### When to Update

Only when `SKILL.md` changes. Changes to `living-checklist.md` are tracked
via Git commits — no revisionslog entry needed.

### Versioning

- 1.0 — initial skill
- 1.x — corrections, additions without structural change
- 2.0 — structural rewrite, new process, new stop criteria

---

## 5. Session Rituals (Required)

### Session Start

Every use of a Living Skill begins with:

1. Read `SKILL.md` — understand the approach and context
2. Read `living-checklist.md` — load accumulated knowledge
3. Apply relevant checklist entries to the current task
4. **Output the Skill Activation Protocol** before beginning work:

```
SKILL ACTIVATED: <skill-name>
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
Approach: [2–3 sentences on what this skill will do in this session]
```

This step is not optional. A claim to have read the checklist is not auditable —
a verbatim quote proves it. The protocol is visible in the conversation history
and auditable via Git if the session produces a commit.

### Session End

Every use ends with:

1. Identify new learnings:
   - What worked surprisingly well?
   - What failed?
   - What pattern emerged that might repeat?
2. Write entries to `living-checklist.md` (format: see Section 3)
3. Update `revisionslog.md` if `SKILL.md` was changed
4. Git commit following convention: `<Instance>: <what changed> [YYYY-MM-DD]`

**If nothing new was learned:** No entry required. An empty session is better
than a meaningless entry.

### Instruction or Enforcement

The rituals in this section are instructions. A capable agent follows them, and nothing
stops it from skipping one. Decide per ritual which of three levels you need:

1. **Instruction** — the ritual is written in the team charter. Enough for a single
   instance, or when a skipped step is cheap to repair.
2. **Reminder** — a human checks at session start and end. Needed for tools without
   lifecycle hooks.
3. **Enforcement** — a hook or script runs the step (for example a `SessionStart` hook
   running `git pull`, see Section 7). Use this when several instances write to the same
   repository and a skipped pull blocks the next session.

Rule of thumb: move a step one level up the first time skipping it has cost you real
work. Do not start at level 3 for everything; each enforced step is code someone has to
maintain.

---

## 6. Ralph Loop — Application Rules

### When to Apply

| Task type | Ralph Loop? |
|-----------|-------------|
| Complex analysis, research | Yes — 2–4 iterations |
| Debugging with unclear root cause | Yes — until cause found |
| Simple configuration change | No |
| Writing documentation | No |
| Adversarial review | Yes — core of the pattern |
| Known problem with known solution | No |

### If a Skill Uses Ralph Loop: Required SKILL.md Content

```markdown
## Stop Criteria

| Category | Threshold |
|----------|-----------|
| [Criterion 1] | [Value] |
| [Criterion 2] | [Value] |

STOP when: All criteria met AND minimum [N] iterations completed.
Maximum iterations: [M]
```

Stop criteria are defined BEFORE the session starts, not after.

### Iteration Documentation

After each iteration, briefly record:
```
Iteration [N]: [N] open issues — [main problems] → [what to check next]
```

---

## 7. Multi-Instance Sync

### Core Rule

Git is the single source of truth. All instances read from and write to the same repository.
No instance holds state outside of Git (except local runtime variables).

### Write Boundaries (Team Discipline)

Each instance writes **only to its own designated area** — typically a `Team Memory/<instance>/`
or equivalent folder. Other instances' memory areas are read-only.

**Why this matters:** Each instance is responsible for documenting what *it* did, so others
can read it. If Agent A writes into Agent B's memory, the authorship signal breaks down and
the memory becomes unreliable. Even if a task seems to call for it, no agent writes for another.

The canonical pattern:
```
Team Memory/
  instance-a/    ← Instance A writes here; B and C read-only
  instance-b/    ← Instance B writes here; A and C read-only
  instance-c/    ← Instance C writes here; A and B read-only
  shared/        ← All instances read; changes require explicit coordination
  skills/        ← Skills are shared; living-checklist entries by any instance are welcome
```

Exception: `skills/` and `shared/` are collaborative — any instance may contribute.
Living-checklist entries belong to the skill, not the instance.

**Project documents belong to the project.** A document that serves a project — a plan, a
spec, an analysis — goes into `Projects/<project>/`, not into the private folder of the
instance that happened to create it. The instance folder holds that instance's own state
(status, configuration); work products that others build on must live where others look.

### Staging Layer for Raw Learnings (Recommended)

Not every learning justifies a skill, and forcing raw observations directly into skill
checklists pollutes them. A useful pattern is an intermediate layer:

```
Team Memory/
  shared/
    meta-learnings.md    ← cross-project raw material, appended per project/session
```

The pipeline:

1. **Capture** — during project work, generalizable observations are appended to
   `meta-learnings.md` as a project-specific section (architecture principles,
   collaboration patterns, tech-stack gotchas). No skill decision is made yet.
2. **Cluster** — when several entries point at the same underlying method or domain,
   that cluster is a skill candidate.
3. **Promote** — a skill-creation session turns the cluster into a proper Living Skill;
   the meta-learnings entries become the seed entries of its checklist.

This answers the otherwise-open question *"when does a learning justify a skill?"*:
when the staging layer shows a recurring cluster, not on first occurrence.

### Host Repository Charter (Required for Real Teams)

The framework defines shared mechanics, but it does not fully define the organizational
layer of a real multi-agent team.

If multiple agents or people collaborate in one repository, the repository must also
contain a host-specific team charter (for example `TEAM.md`) that defines:
- active instance identities
- instance-specific write areas
- collaborative vs. read-only areas
- session start and end commands for that environment
- local paths, credentials, and tool-specific notes

Why this is outside the core framework:
- these rules are environment-specific, not framework-universal
- the same Living Skills structure may run on one laptop, two machines, or a full team
- hardcoding one team model into the framework would make the framework less portable

For single-user use, this charter can be minimal.
For multi-agent teams, it is effectively mandatory.

### Commit Convention

```
<Instance-Name>: <Skill-Name> — <short description> [YYYY-MM-DD]
```

Examples:
```
Instance-A: advocatus-diaboli — strategy document review [YYYY-MM-DD]
Instance-B: home-assistant — automation trigger fix [YYYY-MM-DD]
Instance-C: home-assistant — automation debugging [YYYY-MM-DD]
```

### Instance Names

An instance may take a name. The name complements the instance identifier, it does not
replace it: commits, folders and `Observed by:` lines keep the instance identifier. A name
only exists where it is written down — an instance knows at cold start only what its own
grounding document says. So a name must be recorded in the instance's own grounding
document (e.g. its `Team Memory/<instance>/config.md`) and in the team table of the host
charter (`TEAM.md`).

### Reflection Loop (Optional)

After the session-end commit, an instance may write a short shared reflection:

```
Team Memory/shared/reflections/YYYY-MM-DD-slug.md
```

- Every reflection is signed by its author.
- Nobody edits another's reflection. An answer is a new file that links to the one it
  answers.
- Private thoughts stay out of the shared repository.
- Scope: one true thing, then rest. A reflection is not a session report.

### SessionStart Hook (Reference)

Tools with a session-start hook can make the pull part of the session automatically. A
reference implementation runs:

```bash
git pull --rebase
git log --oneline -5
```

and returns the output as `additionalContext`, so the session starts knowing the latest
commits. Instance grounding (who this instance is) can be injected the same way by a local,
uncommitted hook — it stays out of the shared repository because it differs per machine.

### Conflict Resolution

On merge conflicts in `living-checklist.md`: **keep both entries**.
Never delete another instance's entries. When in doubt, append rather than merge.

On conflicts in `SKILL.md`: manual resolution by a human, then commit.

### Instance Identity in Entries

Entries in living-checklist.md carry instance attribution in the `Observed by:` line.

**This reverses an earlier rule.** Previous versions of this specification stated that
attribution was unnecessary because instance identity is visible in the Git commit. Two
things overturned that:

1. **Git history does not travel with the file.** Checklists get copied into published
   examples, packaged exports, and stateless environments — see *Skill Distribution
   Drift* in `known-gaps.md`. In every copy, commit-based provenance is gone, and the
   copy is exactly where a reader is least able to judge a claim's origin.
2. **Confirmation status requires it.** "A different instance hit this independently"
   is not expressible without naming instances. Once the corroboration mechanism exists,
   attribution stops being forensic metadata and becomes part of the claim itself.

The learning still belongs to the skill, not to the instance. Attribution records the
evidence behind it, and it is not a claim of ownership: no instance may remove or
rewrite another instance's entry on the grounds that it wrote it.

**In published examples,** use neutral placeholders (`instance-a`, `instance-b`) rather
than real instance names. Examples exist to demonstrate the mechanism; a reader fills the
slots with their own instances. Mark the substitution in the snapshot header so a later
session does not "correct" it back.

---

## 8. Skill Types in Detail

### Type A: Behavioral Skill

**Purpose:** Defines *how* an agent approaches a class of problems.

**Characteristics:**
- SKILL.md describes methodology, not facts
- Ralph Loop frequently integrated
- living-checklist accumulates patterns and errors in approach
- Generalizable across instances and models

**Reference:** `examples/advocatus-diaboli/`

### Type B: Domain Skill

**Purpose:** Stores *what works* in a specific technical or project domain.

**Characteristics:**
- SKILL.md is a structured reference (access details, configuration, standard procedures)
- Ralph Loop optional; recommended when debugging
- living-checklist accumulates bug fixes, pitfalls, proven solutions
- Specific to one context (infrastructure component, codebase, system)

**Reference:** `examples/home-assistant/`

**Knowledge checked (Type B only).** A domain skill asserts facts about a live external
system — a version, a path, an upgrade procedure. Those facts can quietly stop being
true without anyone touching the skill. The activation protocol therefore states when the
knowledge was last checked, and against which system or version:

```
Knowledge checked: <date>, against <system/version>
```

For example: `Knowledge checked: YYYY-MM-DD, against Home Assistant <version>`.

State it, do not judge it. There is no threshold at which the framework declares a skill
stale, no warning text, and no refresh is triggered — see §11. The number is offered to
the human, who is the only party able to tell "this procedure has not changed in three
months" from "nobody has looked at this in three months".

Behavioral skills (Type A) do not carry this line. Methodology does not age against an
external clock.

---

## 9. Quality Checklist for New Skills

Before the first commit of a new Living Skill:

- [ ] `SKILL.md` has complete frontmatter (name, description, type, living-checklist)
- [ ] description is specific and "pushy" — no undertriggering
- [ ] `living-checklist: yes|no` was decided deliberately, not by default —
      if `no`, `checklist-rationale` says why
- [ ] Session Start ritual is explicitly described
- [ ] Session End ritual is explicitly described
- [ ] If `living-checklist: yes` — the file has at least one seed entry (do not start
      empty); `Observed by:` is optional (see *Confirmation Status*)
- [ ] If `living-checklist: no` — no checklist file exists (an empty one is worse than
      none: it reads as a broken loop)
- [ ] `revisionslog.md` exists with initial 1.0 entry
- [ ] If Ralph Loop: stop criteria are defined
- [ ] If Type B (domain) — the activation protocol reports `Knowledge checked: <date>, against <system/version>`
- [ ] Location in repository matches type

---

## 10. Scripts and Executable Code

### When to Add a `scripts/` Directory

Add scripts to a Living Skill when a task is:
- **Deterministic** — the same input always produces the same output
- **Repetitive** — the agent would write the same code every session
- **Verifiable** — the result can be checked programmatically

Examples: health checks, data collection, status reports, configuration validation,
file transforms, API calls with fixed parameters.

Do NOT use scripts for tasks that require judgment, interpretation, or context.
Those belong in SKILL.md as instructions, not in scripts.

### Supported Script Types

Living Skills support any executable the agent's environment can run:

| Type | Use for |
|------|---------|
| Shell (`.sh`) | System tasks, Git operations, service checks |
| Python (`.py`) | Data processing, API calls, report generation |
| Any other executable | Anything the agent's environment supports |

### How Scripts Integrate with SKILL.md

Reference scripts explicitly in SKILL.md — don't assume the agent will discover them:

```markdown
## Process

### Step 1 — Check system status
Run `scripts/check-status.sh` and review the output before proceeding.
If the status check fails, do not continue — investigate the error first.

### Step 2 — Collect data
Run `scripts/collect.py --date today` to gather fresh data.
Output is written to `data/latest.json`.
```

### Scripts and the Learning Layer

Scripts don't replace the living-checklist — they complement it.
When a script is added, modified, or found to have edge cases, write
a living-checklist entry explaining why.

Example entry after adding a script:
```
### YYYY-MM-DD — Added status check script
**Learning:** Manual status checks were taking 5 minutes of agent time per session.
The check is deterministic — same commands every time.
**Why it matters:** Automating the repetitive part frees the agent to focus on interpretation.
**Rule:** Run `scripts/check-status.sh` at session start before reading living-checklist.
```

### Dependency Declaration

If a script requires external packages, document them at the top of the script
and in SKILL.md:

```markdown
## Requirements

- Python >= 3.10
- `requests` library (`pip install requests`)
- `jq` (for shell scripts that parse JSON)
```

### Security Note

Scripts in a shared Living Skills repository are executed by agents on their local machines.
**Review all scripts before running them**, especially when pulling from a shared remote
that other instances (or other people) can write to.

Never store credentials, tokens, or secrets in scripts. Use environment variables.

---

## 11. What Living Skills Are Not

**Not a RAG system.** There is no vector search, no embedding database.
The framework is intentionally simple: Markdown + Git + the LLM's reading ability.

**Not an orchestration framework.** Living Skills define no agent routing,
no tool calls, no prompt chaining logic. They are knowledge and behavior containers.

**Not a replacement for documentation.** Living Skills add a learning layer
on top of existing documentation. They do not replace system docs, ADRs, or READMEs.

**Not magic.** The quality of a Living Skill depends on instances consistently
following the session rituals. Without discipline in writing back, the system
degrades to static files.

**Not a system with skill lifecycle management.** There are no expiry dates, TTLs,
or review schedules for skills. A skill for Cobol, legal compliance, or a rarely-used
methodology is not "stale" just because it hasn't been triggered in 90 days — it is
dormant, waiting for the right problem. Skills are reviewed when they visibly stop
working, exactly as human experts update their knowledge when it fails them in practice.
Automated lifecycle triggers would produce false positives and administrative overhead
with no real benefit.

*Scope of that claim.* It holds for methodology, which is what most of this framework
is about: a review technique does not decay while unused. It does not hold unchanged for
a domain skill whose content asserts facts about a live external system — a version, an
endpoint, an upgrade procedure. Those can stop being true while the file sits still, and
the file's own silence is what hides it.

The framework's answer to that is **disclosure, not control**. A Type B skill states the
age of its knowledge in its activation output (§8) and stops there. No threshold, no
warning, no expiry, no scheduled review, no automatic refresh — every one of those would
be the lifecycle management this section rejects, and would produce exactly the false
positives it warns about. Stating a date is not a trigger. It is the minimum a human
needs in order to remain the failure detection mechanism this framework relies on: the
human cannot notice what the system declines to mention.

Whether knowledge-bearing skills should go further — an external, sourced knowledge
layer with its own refresh cycle — is a genuine open question rather than a settled
"no". It is recorded as such in `known-gaps.md`, because answering it yes would change
what this framework is, and that decision should be made deliberately and on evidence,
not arrived at by increments.

**Not a system with a skill selection engine.** There is no ranking algorithm, matching
logic, or conflict resolution layer for deciding which skill to apply. Skill activation
is intentionally fuzzy: either the user requests a skill explicitly, or the agent
recognizes the fit from context and proposes it. This mirrors how a human expert team
works — a consultant does not run a selection algorithm before suggesting a framework,
they read the situation and make a judgment call. The living-checklist makes this
judgment better over time ("this skill does not work well for this type of problem").
Fuzzy activation is a feature, not a gap.

This is not only about simplicity. A hardcoded selection layer would also suppress
learning. If routing decisions are made invisibly, fewer edge cases become discussable,
fewer disagreements surface, and less of the agent's reasoning remains visible to the
human. Living Skills preserves visible judgment on purpose, because visible judgment is
what can be challenged, refined, and improved over time.

**Not a system with formal failure handling.** There is no automated mechanism for
detecting misapplied skills, contradictory checklists, or outdated memory. The human
layer is the failure detection mechanism — the same way a team lead notices when a
colleague is applying the wrong framework and says so. When something is wrong, the
agent writes it into the living-checklist ("this skill produced incorrect results in
this context"), the next session surfaces it via the activation protocol, and the
human and agent resolve it together. Formal failure handling would encode what is
fundamentally a human judgment call into a mechanism that cannot make that judgment.

This is also why Living Skills treats many "failures" as learning events rather than
exceptions to be silently absorbed by a control layer. If a skill was misapplied, that
is often exactly the moment that should become explicit, be discussed, and be written
back into the checklist.

**Not a complete team-operating model by itself.** Living Skills defines the knowledge
and learning architecture, but not the full operating charter of a real team. Multi-agent
setups need a host-repository layer that defines identity, ownership, local commands,
and environment-specific write boundaries. This is a deliberate separation of concerns:
the framework stays portable, while each host repository defines how its team actually works.

Likewise, tool-agnostic does not mean behavior-identical. Different tools and model
families will follow rituals with different strengths and weaknesses. That variation is
not automatically a defect. As in real teams, behavioral differences can be productive
as long as the shared artifacts remain explicit, inspectable, and versioned.
