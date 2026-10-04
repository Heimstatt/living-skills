---
name: "Skill Creator (Team Edition)"
description: "Creates new Living Skills for the team. Trigger: 'create a new skill', 'turn this workflow into a skill', 'build a skill for X', 'set up X as a skill'."
type: "behavioral"
living-checklist: "yes"
---

# Skill Creator — Team Edition

Extends the official Anthropic skill system with **Living Skills**: skills that learn across sessions, use filesystem access and improve themselves.

**Core difference from static skills:**
- Static (plugin/Cowork): SKILL.md is loaded into context — done. No memory.
- Living Skill: reads before the session, writes back after the session. Grows with every use.

---

## Two skill types

### Type A: Behavioral skill
*For: Claude working methods, review methods, analysis workflows*
Example: Advocatus Diaboli — defines HOW Claude does something.

### Type B: Domain skill
*For: infrastructure components, shared project documentation (`Projects/`), recurring subject areas*
Example: Home Assistant — stores WHAT worked and WHAT did not.

Both types use the same file structure.

---

## Living Skill structure (standard)

```
<location-in-repo>/skills/<skill-name>/
├── SKILL.md             ← behavior / reference / procedure (static core)
├── living-checklist.md  ← accumulated insights (grows with every session)
└── revisionslog.md      ← what was changed when, and why
```

**Location in the repo:**
- Behavioral skills:  `Team Memory/skills/<name>/`
- Business department heads: `Team Memory/skills/<department>/`
- Internal business specialist roles: `Team Memory/skills/<department>/roles/<name>/`
- Infrastructure:     `Infrastructure/skills/<name>/`
- Projects:           `Projects/<project>/skills/<name>/`

---

## Creation process

### Step 1 — Clarify intent

Ask:
1. Behavioral skill or domain skill?
2. Is there existing documentation (`.md`) to use as a basis?
3. What is the trigger? (When should this skill be active?)
4. What is the stop criterion for a session? (When is the job done?)

### Step 2 — Write the entry file

The entry file is `SKILL.md`, so the skill is also recognised by standardised
skill systems (e.g. Codex). Older Living Skills may still use `Skill.md`. On
case-insensitive filesystems, never create both side by side.

**Frontmatter:**
```yaml
---
name: "<Name>"
description: "<What the skill does + when it triggers — concrete and 'pushy', max. 200 characters>"
type: "behavioral | domain"
living-checklist: "yes | no"
---
```

**Body structure by type:**

Behavioral skill:
- Session-start ritual (what to read)
- Procedure with concrete steps
- Session-end ritual (what to write back)
- Stop criterion

Domain skill:
- System reference (configuration, access, paths)
- Proven approaches
- Session start: read `living-checklist.md`
- Session end: write new insights to `living-checklist.md`

### Step 3 — Create living-checklist.md

Initial content: known pitfalls, bug fixes, proven solutions from existing documentation.

Format:
```
# Living Checklist — <Skill-Name>

**Purpose:** Accumulated experience applying this skill. Grows with every session.

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded —
  NOT because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** Application experience stays here permanently. SKILL.md contains
  the authoritative domain knowledge (method, framework, spec) — it is not changed by
  what you learn applying it. Only update SKILL.md when the underlying knowledge itself
  changes (new version of the framework, updated law, revised methodology).

## Entry Format

### [DATE] — [Context/Task type]
**Insight:** [What was learned]
**Why it matters:** [Context]
**Rule:** [Concrete heuristic for the next session]

## Entries

[Initial entries from existing documentation]

## Archive

[Archived entries with date of archiving]
```

### Checklist Management Rules

**Architecture:** SKILL.md contains authoritative domain knowledge — the method, framework,
or reference that exists independently of this team's usage (e.g. the Scrum Guide, BABOK,
a legal text, a technical specification). This knowledge does not change because of your
application experience. The living checklist is the permanent experience layer: what works
and what doesn't when applying that knowledge in this specific context.
These are two fundamentally different types of knowledge and must not be conflated.

**When to add an entry (a):**
- A situation occurred that would go wrong again without a reminder
- The effect was measurable: wrong decision, lost time, repeated mistake
- Do NOT add: general observations, things already in SKILL.md, one-off context-specific events

**When to archive/remove an entry (b):**
- Context fundamentally changed (tool replaced, architecture redesigned) → remove
- Superseded by a more precise entry on the same topic → remove old, keep new
- Do NOT archive because "it hasn't triggered recently" — that may be exactly because
  the checklist is working as intended

**SKILL.md is updated only when the method itself needs revision** — not because
application experience accumulated. New application insights always go to the checklist.

### Step 4 — Create revisionslog.md

```
# Revision Log — <Skill-Name>

| Date | Version | Change | Reason |
|------|---------|--------|--------|
| YYYY-MM-DD | 1.0 | Initial skill | Created from <source> |
```

### Step 5 — Anchor the session-end ritual in the entry file

**Every Living Skill ends with:**
> After completing the task: write new insights, pitfalls or patterns to
> `living-checklist.md`. Format: date, context, insight, rule.
> Update `revisionslog.md` if `SKILL.md` was changed.

### Step 6 — Git commit

```bash
git add <skill-directory>/
git commit -m "<Instance>: <skill-name> Living Skill created [DATE]"
```

### Special case — business organisation

Do not organise business skills as a flat, human-unreadable list of experts:

1. Line departments such as Venture, Product, Marketing and Sales own a visible
   department-head skill at the department root.
2. Specialist roles live under `<department>/roles/` and may stay directly addressable; the
   user does not need to know their names, however.
3. Method competencies such as Business Analysis can exist as a cross-departmental staff
   unit. Being invoked by a department does not imply subordination.
4. Every route states `Staffed`, `Partially staffed`, `Vacant` or `Not needed`.
5. For a vacancy, output a capability-gap brief; neither simulate the missing competency
   nor create it as a new skill unasked.

The binding organisation rules are in
[`framework-organisation.md`](../../framework-organisation.md).

---

## Session-Start Ritual (when using a Living Skill)

Before using a Living Skill:
1. Read `SKILL.md` — understand the procedure and structure
2. Read `living-checklist.md` — load accumulated knowledge
3. **Output the Skill Activation Protocol** (visible in chat, before the first step):

```
SKILL ACTIVATED: <skill-name>
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule/insight]"
Approach: [2–3 sentences on what this skill will do in this session]
```

This output is mandatory. The verbatim quote proves the checklist was read — "I read it" is not auditable, a literal quote is.

---

## Quality criteria for a good Living Skill

- [ ] Trigger description is concrete and "pushy" (not too narrow)
- [ ] Session-start ritual is explicitly described
- [ ] Session-end ritual is explicitly described
- [ ] living-checklist.md has at least one initial entry (not empty)
- [ ] revisionslog.md exists with an initial entry
- [ ] Location in the repo matches the type (Team Memory / Infrastructure / Projects)

---

## Cowork ZIP (optional, if needed)

Only create if the static part of the skill should also be used in claude.ai.
Limitation: no filesystem access → no living-checklist mechanism → static use only.

```bash
mkdir -p cowork/<skill-name>
cp SKILL.md cowork/<skill-name>/
cd cowork && zip <skill-name>.zip <skill-name>/SKILL.md
```

---

## Related skills

→ `Team Memory/skills/advocatus-diaboli/` — reference implementation (behavioral skill)
→ `Infrastructure/skills/home-assistant/` — reference implementation (domain skill)
