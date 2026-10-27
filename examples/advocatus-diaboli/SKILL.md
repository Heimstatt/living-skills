---
name: advocatus-diaboli
description: "Iterative adversarial review: dismantles assumptions, finds counterarguments, accumulates learnings across sessions. Use for ANY critical analysis — strategy, architecture, plans, documents."
metadata:
  type: "behavioral"
  living-checklist: "yes"
---

# Advocatus Diaboli — Iterative Adversarial Review

*Example skill, published as a template. Adapt the procedure to your own team and practice.*

**Trigger:** "advocatus diaboli" / "devil's advocate" / "review critically" / "challenge this" / "tear this apart"

---

## Two Modes

### Mode A: Full iteration (with filesystem access)
- Minimum 2, maximum 4 adversarial review iterations
- New patterns written back to `living-checklist.md` after each session
- The skill improves with each use
- Intermediate states are written down explicitly, so a long review does not depend on the context window

### Mode B: Single iteration (stateless environments)
- One adversarial review plus one revision
- No checklist read or write-back, so no learning across sessions
- Fine for quick sessions, not for complex analyses; say in the output that Mode B was used

The rest of this file describes Mode A.

---

## Session Start

1. Read `living-checklist.md` — load accumulated patterns from prior sessions
2. Output the Skill Activation Protocol:

```
SKILL ACTIVATED: advocatus-diaboli
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
Approach: [2–3 sentences on what this review will do in this session]
```

   This output is mandatory. Without it the session ritual is incomplete.
3. Apply relevant checklist entries (seed rules included) as additional review criteria in Step 2

## Process

### Step 1 — Receive the analysis
Confirm briefly what you received as input. Ask if needed:
- Entire analysis or specific section?
- Already-known weaknesses to focus on?
- Desired iteration depth (2–4)?

### Step 2 — Adversarial Review

Run each iteration using this structure:

```
ADVERSARIAL REVIEW — ITERATION [N]

STANDARD CHECKLIST:
1. UNCHECKED ASSUMPTIONS
   [Quote + counterargument]

2. MISSING COUNTERARGUMENTS
   [What's missing + why it matters]

3. CONFIRMATION BIAS
   [Narratives repeated instead of examined]

4. BLIND SPOTS
   [What's entirely absent]

5. OPERATIONAL WEAKNESS
   [Too generic / unrealistic / ignores risk]

SESSION-SPECIFIC CRITERIA (from living-checklist.md):
[Apply relevant entries from the living checklist]

WEAKNESSES TOTAL: [N]
STOP CRITERION MET: Yes / No
```

### Step 3 — Discussion
Which weaknesses are valid? What gets revised, to what depth?

### Step 4 — Revision
Revise the analysis. Append a revision log.

### Step 5 — Repeat until stop criterion met

### Step 6 — Update the living checklist
After the final iteration, run Session End below.

## Stop Criteria

| Category | Threshold |
|----------|-----------|
| Unchecked assumptions | ≤ 1 |
| Missing counterarguments | ≤ 1 |
| Confirmation bias | 0 |
| Blind spots | ≤ 1 |
| Operational weakness | ≤ 1 |

**STOP when:** All below threshold AND minimum 2 iterations completed. Maximum 4 iterations.

## Session End

After the final iteration:

1. Identify new patterns: What was systematically missed? Why?
2. Write entries to `living-checklist.md` using the format below — only patterns that would go
   wrong again without the reminder, in generic terms (no project names, no case data)
3. Git commit: `<Instance>: advocatus-diaboli — <what was reviewed> [YYYY-MM-DD]`

**Entry format:**

```
### [YYYY-MM-DD] — [Analysis type] · *unconfirmed (1 observation)*
**Learning:** What pattern was found / what failed
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check to apply in future sessions
**Evidence:** <commit, issue or PR where it happened>
**Observed by:** <instance> (YYYY-MM-DD)
```

---

## Iteration Log (required in final output)

```
## Revision Log

Iteration 1: [N] weaknesses — [main points] → [changes made]
Iteration 2: [N] weaknesses — [main points] → [changes made] / STOP
Remaining gaps: [name them honestly]
```

---

## Tone

- Direct, no hedging
- Quote specifically
- Distinguish weakness from acceptable gap
- Name uncertainty explicitly
