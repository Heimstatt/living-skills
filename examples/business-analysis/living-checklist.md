# Living Checklist — Business Analysis

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Application experience layer — patterns collected while applying the BABOK procedure. Grows with every session. Never merged back into SKILL.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / domain context] · *unconfirmed (1 observation)*
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete heuristic for the next session
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Entries

### YYYY-MM-DD — Out-of-Scope section left empty · *illustrative*
**Learning:** The requirements were complete for what the product does, but nothing stated what it deliberately does not do. Reviewers later read missing features as forgotten requirements.
**Why it matters:** Scope boundaries feel obvious to the author while writing and are invisible to everyone else.
**Rule:** Fill Out-of-Scope during Step 1, not at the end. Every exclusion gets a one-line reason, and an empty section blocks handoff.
**Observed by:** <instance> (YYYY-MM-DD)

---

### YYYY-MM-DD — Security NFR without a measurable criterion · *illustrative*
**Learning:** An NFR read "the system must be secure". It could not be tested, so it was never checked and no design decision referred to it.
**Why it matters:** Quality attributes are easy to state as intentions and hard to phrase as observable conditions.
**Rule:** Rewrite every NFR as a measurable acceptance condition (who, what, threshold, how verified) and link it to the risk or decision it serves.
**Observed by:** <instance> (YYYY-MM-DD)

---

*Further entries follow after each session.*
