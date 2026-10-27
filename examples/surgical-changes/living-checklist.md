# Living Checklist — Surgical Changes

*Template example. The seed rules below are generalised rules, not observations. Add your own entries in the Entry Format.*

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

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### O means orphan, nothing else · *seed rule*
**Rule:** For every hunk marked **O**, name the code that this change made unused. If you cannot, the hunk is **U** (revert it, or get it added to the contract) or **R** if the contract really requires it. Read `git diff --stat` first: a diff with zero deletions and only new files cannot contain an O.
**Why it matters:** O is easily read as "optional" or "other". Then extras land under O, the U row stays empty, and the revert step never fires, including for security-relevant additions.

### Code appended after a script's last command changes its exit code · *seed rule*
**Rule:** When you add lines after the last command of a script or function, capture the original status first (`rc=0; cmd || rc=$?` … `exit "$rc"`) and test the failure path, not only the success path.
**Why it matters:** The script's exit status is the status of its last command. An added cleanup line (`… || true`) turns every earlier failure into success, while the diff looks harmless and the happy path still works.

### A new refusal in a shared helper must be scoped to its caller · *seed rule*
**Rule:** Before a shared helper gets a new refusal, exit code or side effect, list all its callers (grep the scripts, scheduled jobs, hooks). Scope the new path to the caller it is meant for, and test that an error inside the new check cannot block the old path.
**Why it matters:** The diff of the helper does not show who calls it. A rule that is right for one caller can silently drop work for all others.

### A guard in one selector does not protect the other consumers · *seed rule*
**Rule:** When you add a hold, ownership or scope check, trace every place that reads or drains the same data and apply the check where the action actually happens (inside the lock, right before the write). Test a stale item followed by a valid one.
**Why it matters:** A correct candidate query constrains only itself. A shared release or delivery path with wider visibility can still act on the items the new check was meant to exclude.

### Test fixtures must be states the real write path can produce · *seed rule*
**Rule:** Before adding a synthetic row or fixture, trace the producer that writes it: stored column values, schema checks, triggers and admission rules. Use the exact stored shape. A fixture the producer cannot create is labelled legacy or corruption test, or removed.
**Why it matters:** A selector keyed on a value the database never stores passes its tests and never selects a real row. An unreachable fixture proves the code reacts to the fixture, not that the bug can occur.

### Assert the positive outcome at real cardinality · *seed rule*
**Rule:** A test for a handoff or cleanup asserts the outcome the user needs (the successor actually queued or running), not only the absence of the old state. If the change claims to cover a set, the test uses at least two matching items and checks each.
**Why it matters:** Negative assertions also pass when nothing happens at all. A single matching row hides `LIMIT 1` and first-match bugs that leave the rest of the set untouched.

### The verification command includes its working directory · *seed rule*
**Rule:** Write the verification in the contract as directory plus command. If it fails before any test runs (collection, import, missing fixture), report it as a harness failure, find the canonical invocation, rerun, and report both results.
**Why it matters:** The same suite can fail from the repository root and pass from its own directory. Without the context, an invocation error is reported as a regression, or a real check is dropped.

### A noticed hazard on your own test path is in scope · *seed rule*
**Rule:** Before running the verification, check the noticed-list for anything the test path will touch. If a parked hazard lies on that path, fix it first (it is now in scope) or design the test around it.
**Why it matters:** The noticed-list means "later", but a parked bug is still live during your own test and can abort or falsify the verification of a correct change.

### Know when an edit goes live · *seed rule*
**Rule:** Before editing, find out how the code is activated. If a scheduler or service runs straight from the working tree, the edit is the deployment: keep the live mode off until tests pass. If a long-lived process loaded the code at start, the edit is not live: verify the process start time after the restart before claiming the behaviour.
**Why it matters:** "Edit, test, then deploy" is the assumed order. Run-from-checkout collapses it into one step, and a long-lived interpreter adds a hidden one; both make the report about live behaviour wrong.

### Narrow a broad fix by removing whole behaviour paths · *seed rule*
**Rule:** When a scoped change is cut out of a larger working fix, remove the excluded branches together with their tests as units. Then audit every remaining hunk against the narrower contract and rerun the failure and retry tests.
**Why it matters:** A small-looking filter can keep hidden dependencies on the excluded paths, and falling back to an older narrow patch can bring back bugs the large fix had already solved.

### A new file name can break existing code · *seed rule*
**Rule:** Before naming a new module or helper in an importable directory, check for collisions with the standard library and existing packages, and run one neighbouring test immediately.
**Why it matters:** Many runtimes put the local directory first on the import path. A small new helper named like a standard module (`typing.py`, `logging.py`) breaks suites that the change never touched.

### New access paths are their own scope items · *seed rule*
**Rule:** List new listeners, tunnels, ports, forwarding rules and credentials as separate lines in the scope contract. If what they expose is wider than the capability that was asked for, stop at that boundary and get explicit approval or build a narrower interface.
**Why it matters:** A convenient access path can feel like plumbing while it changes who can reach a powerful interface. That turns a small task into an authorization decision the requester never made.

---

## Entries

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
