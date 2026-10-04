# Living Checklist — Token-Aware Developer Brief

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Application experience layer — token-optimization patterns collected while applying the skill.
Grows with every session. Never merged back into SKILL.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Task type / context] · *unconfirmed (1 observation)*
**Learning:** What was discovered / what was surprising
**Why it matters:** Structural reason this happens repeatedly
**Rule:** Concrete guideline for next similar session
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Entries

### YYYY-MM-DD — Large file read in full to answer a narrow question · *illustrative*
**Learning:** A complete log file was loaded into context to find one error line; most of the budget went to irrelevant output.
**Why it matters:** Reading the whole file feels safer than guessing a filter, and the cost only shows later when context runs short.
**Rule:** For large inputs, filter first (search, tail, line ranges) and load only the matching section. Widen the window only if the result is ambiguous.
**Observed by:** <instance> (YYYY-MM-DD)

---

### YYYY-MM-DD — Sub-agent briefed without its stop condition · *illustrative*
**Learning:** A delegated search returned a long, unfocused report because the brief named the topic but not the expected output or when to stop.
**Why it matters:** A sub-agent cannot see the caller's purpose; without a defined result shape it explores broadly and the savings of delegation are lost.
**Rule:** Every sub-agent brief states the question, the output format, a length limit and the stop condition.
**Observed by:** <instance> (YYYY-MM-DD)

---

*Further entries follow after each session.*
