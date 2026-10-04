# Living Checklist — Surgical Changes

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Collected learnings from applying the skill. Extended after every session.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded — NOT
because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** SKILL.md holds the procedure (contract → edit → diff audit → noticed-list).
Only change it when the procedure itself needs revision. Application experience stays here.

---

## Entry Format

```
### [YYYY-MM-DD] — [Context] · *unconfirmed (1 observation)*
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check for the next session
**Observed by:** <instance> (YYYY-MM-DD)
```

---

## Entries

### [YYYY-MM-DD] — Formatting changes hidden in a functional diff · *illustrative*
**Learning:** A small fix arrived together with reformatted lines and reworded comments in the
same file. The reviewer had to separate cosmetics from the real change.
**Why it matters:** Editing tools make adjacent lines cheap to touch, and tidying them feels like
diligence rather than scope creep.
**Rule:** In the diff audit, formatting-only and comment-only hunks are class **U** by default.
They become **R** only if the request named them.
**Observed by:** <instance> (YYYY-MM-DD)

---

### [YYYY-MM-DD] — Verification named in the contract but not run · *illustrative*
**Learning:** The scope contract listed a test command, the change was reported as done, and the
command had never been executed.
**Why it matters:** Writing the intention down makes it feel as if the check already happened.
**Rule:** The diff audit must quote the command and its actual result. If verification was
skipped or impossible, say so explicitly in the report.
**Observed by:** <instance> (YYYY-MM-DD)

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
