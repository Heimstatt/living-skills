---
name: "Surgical Changes"
description: "Scope contract before the edit, hunk-by-hunk diff audit after. Use for ANY change to existing code — implement, fix, refactor, add a feature, before a PR, or when asked 'why did you change that?'."
type: "behavioral"
living-checklist: "yes"
---

# Surgical Changes — Traceable Edits to Existing Code

**Applies to:** All instances with repo access + Git
**Trigger:** Every change to code that already exists. Not needed for new files in an empty
directory, and not for single-line typo fixes (see Threshold).

**The one test this skill enforces:** every changed line traces to something the user asked for.

---

## Threshold — when this skill applies

| Situation | Apply? |
|-----------|--------|
| Change touches ≥ 2 existing files, or ≥ 20 lines | Yes, full procedure |
| Single existing file, small edit | Steps 3 + 4 only (contract can stay in your head) |
| Typo, obvious one-liner, brand-new file | No |

This skill biases toward caution over speed. Applying it to a trivial edit is itself a
failure of judgment — the cost is real, so spend it where a wrong diff is expensive.

---

## Session Start

1. `git pull`
2. Read this `SKILL.md`
3. Read `living-checklist.md`
4. Output the Skill Activation Protocol (Step 1 below)

---

## Process

### Step 1 — Output the Skill Activation Protocol

```
SKILL ACTIVATED: surgical-changes
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
Approach: [2–3 sentences on what this skill will do in this session]
```

### Step 2 — Write the scope contract (before touching a file)

List what you intend to change, and nothing else:

```
SCOPE CONTRACT
Requested: [restate the request in one sentence]
Files I will touch:
  - path/to/file.ts  → [what changes there]
  - path/to/other.py → [what changes there]
Out of scope (explicitly not touching): [adjacent things you noticed]
Verification: [the command or check that proves it worked]
```

Two gates before you proceed:

- **Ambiguity gate:** if the request has more than one reasonable reading, stop and present
  the readings. Do not pick one silently. Picking silently is the expensive failure — an
  hour of work against the wrong interpretation costs more than one question.
- **Simplicity gate:** state the simplest approach that satisfies the request. If you are
  planning an abstraction for code with one call site, configurability nobody asked for, or
  error handling for a state that cannot occur, cut it now. "Would a senior engineer call
  this overcomplicated?" — if yes, shrink the contract before writing code.

### Step 3 — Edit inside the contract

While editing existing code:

- Do not improve adjacent code, comments, or formatting.
- Do not refactor what is not broken.
- Match the surrounding style even where you would do it differently.
- Unrelated dead code: write it on the noticed-list (Step 5), do not delete it.

Orphans are the one exception: imports, variables, or functions that **your** change made
unused get removed. Pre-existing dead code does not.

### Step 4 — Diff audit (mandatory, before reporting done)

Read the actual diff — `git diff` — and classify **every hunk**:

| Class | Meaning | Action |
|-------|---------|--------|
| **R** | Requested — traces to the scope contract | keep |
| **O** | Orphan cleanup caused by this change | keep |
| **U** | Unrequested — improvement, reformat, drive-by | **revert** |

Output the audit:

```
DIFF AUDIT
[file:line-range]  R  [one line: which contract item]
[file:line-range]  O  [what became unused]
[file:line-range]  U  → reverted
Hunks: [N] total — R:[n] O:[n] U:[n] (all U reverted)
Verification: [command run] → [result]
```

Reading the diff is not optional and cannot be replaced by remembering what you did. The
classification is only auditable because it quotes real line ranges.

### Step 5 — Hand over the noticed-list

Everything you saw and did not touch goes to the user as a separate list — dead code,
inconsistencies, missing tests, adjacent bugs. This is the release valve that makes Step 3
sustainable: noticing is useful, acting on it uninvited is not.

```
NOTICED, NOT TOUCHED
- [file:line] [what] — [why it might matter]
```

---

## Stop Criteria

Done when **all** hold:

- Zero **U** hunks remain in the diff.
- The verification named in the contract ran and passed — or its failure is reported verbatim.
- The noticed-list is handed over (empty is a valid answer, silence is not).

---

## Session End

1. New patterns into `living-checklist.md` in the format required by `framework.md` §3
   (`unconfirmed` marker, `Observed by:`).
2. Update `revisionslog.md` only if this `SKILL.md` itself changed.
3. Commit.

---

## How to know it's working

Observable signals, so the skill can be judged instead of believed:

- Diffs contain no hunks the user has to ask about.
- Clarifying questions arrive **before** implementation, not after a wrong build.
- Reverts of "improvements nobody asked for" drop toward zero.
- The noticed-list becomes the place adjacent problems get raised — the user decides, not the agent.

If none of these change over several sessions, the skill is decoration. Say so and revise it.

---

## Related skills

→ `Team Memory/skills/token-optimization/` — activate first; scope discipline and context
  budget are the same decision made twice
→ `Team Memory/skills/advocatus-diaboli/` — use on the scope contract when the request
  itself looks wrong, not just its implementation

---

## Source

Adapted from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
(its README states MIT), which condenses [Andrej Karpathy's observations on LLM coding pitfalls](https://x.com/karpathy/status/2015883857489522876)
into four principles. All four are in this skill: *Simplicity First*, *Surgical Changes*
and *Goal-Driven Execution* as its substance, *Think Before Coding* as the ambiguity gate.

What was added here: the principles were turned into a procedure with an auditable
output. The scope contract makes the intended blast radius reviewable before the edit,
the R/O/U hunk classification makes the actual blast radius checkable after it, and the
noticed-list gives "I saw something adjacent" a destination other than the diff. The
original is a set of principles to hold; this is a loop that produces artifacts a human
can check.
