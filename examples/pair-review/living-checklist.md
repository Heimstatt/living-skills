# Living Checklist — Pair Review

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Experience layer for cross-model review cycles. Permanent experience layer — not a staging area for SKILL.md.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded — NOT because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** Application experience stays here permanently. SKILL.md contains the protocol itself — only update it when the protocol changes.

---

## Entry Format

```
### [DATE] — [Context]
**Insight:** [What was learned]
**Why it matters:** [Context]
**Rule:** [Concrete heuristic for the next session]
```

---

## Entries

### YYYY-MM-DD — Correct finding, wrong suggested fix · *illustrative*
**Insight:** The builder accepted a valid finding together with the reviewer's proposed remedy. The remedy introduced a new problem that was worse than the original defect.
**Why it matters:** Accepting a finding feels like accepting its fix; the protocol treats them as two separate decisions.
**Rule:** Classify the finding and the suggested remedy separately. Verify the chosen fix against the requirement, not against the reviewer's text.

---

### YYYY-MM-DD — Review without a pinned commit · *illustrative*
**Insight:** A review referred to "the current state" of a branch. By the time the builder responded, new commits had changed several of the cited lines, and nobody could tell which findings still applied.
**Why it matters:** Branches move during a review cycle; line references are only meaningful against a fixed revision.
**Rule:** Every review and every response names the exact commit hash it refers to. A finding without a commit reference is returned for clarification.

---

## Archive

*Entries moved here when context fundamentally changed or superseded.*
