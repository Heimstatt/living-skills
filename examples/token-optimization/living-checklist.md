# Living Checklist — Token-Aware Developer Brief

*Template example. The seed rules below are generalised from long use of this skill; add your own entries below them.*

**Purpose:** Application experience layer — token-optimization patterns collected while applying the skill.
Grows with every session. Never merged back into SKILL.md.

---

## Management

- **Entry threshold:** Only concrete, repeatable insights that would go wrong again without the reminder — no obvious things
- **Archive rule:** When entries exceed ~50, move older entries without current relevance to `## Archive`
- **Boundary:** `SKILL.md` contains the procedure (changes rarely); this file contains the experience (grows each session)

---

## Entry Format

```
### [YYYY-MM-DD] — [Task type / context] · *unconfirmed (1 observation)*
**Learning:** What was discovered / what was surprising
**Why it matters:** Structural reason this happens repeatedly
**Rule:** Concrete guideline for next similar session
**Observed by:** <instance> (YYYY-MM-DD)
**Evidence:** <commit, issue or PR where it happened>
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Run the cheapest decisive probe before reading broadly · *seed rule*
**Rule:** Start with the narrowest check that can settle the question: the exact error string and its guard, a filtered log window, an endpoint list, a count. Batch these probes into one call and read full content only where a probe points.
**Why it matters:** Repositories mix source, build output and runtime state. A broad search or recursive listing fills the context with noise while the deciding fact sits in one small place.

### Read narrow boundaries before whole subsystems · *seed rule*
**Rule:** In code reviews, read the parts that decide behaviour first: outer middleware before route checks, a shared helper's body before its call sites, the code after the main write (side effects, queued work), and the expected outcomes of security tests. Expand only where one of these leaves an open effect.
**Why it matters:** Names compress several decisions into one label, and early guards decide whether later checks are reachable at all. Reading everything evenly spends the budget on correct mechanics and misses the one inverted expectation.

### Review the final state against acceptance criteria, not the history · *seed rule*
**Rule:** For a patch series, apply it on its named base and review the resulting tree. For a large review, map each acceptance criterion to the newest artifact that settles it or to an explicit gap; use the chronology only to resolve conflicting claims.
**Why it matters:** Commit series and long threads repeat superseded states. Reading them in order mixes fixed defects with live ones and lets the noisiest part of a project dominate the review.

### Fix the reviewed artifact before you start · *seed rule*
**Rule:** Name the exact commit, release tag or mirror you review and state its limits. For adoption decisions, verify each deciding capability on the newest stable release, not on the moving default branch.
**Why it matters:** A moving target can change between review and trial, and a verdict without a pinned artifact cannot be checked or reused later.

### Resume from the current work record, not from the conversation · *seed rule*
**Rule:** After a restart or handover, read the current state of the work item first (its issue, claim or status record), then compare it with the last handoff's open questions. Read older history only to resolve a specific mismatch.
**Why it matters:** Restart prompts and chat lag behind the real state. Replaying them reloads settled work, may reopen finished items and can trigger questions that were already answered.

### Stop rereading code once the open question is runtime-only · *seed rule*
**Rule:** When the source behaviour is settled and what remains depends on the running system, stop static analysis. Ask for one evidence packet with a fixed shape from whoever can run it, and keep the verdict marked provisional until it arrives.
**Why it matters:** Rereading looks like progress but cannot show which configuration actually ran or whether a test reached the operation it claims to test.

### Prove liveness before diagnosing the last error · *seed rule*
**Rule:** For a quiet service or monitor, first name what each check actually watches, then test a liveness signal that must advance (heartbeat, cursor, lease, fresh probe). Read a "last changed" timestamp as a state change, not as a heartbeat.
**Why it matters:** Error-only logs make healthy silence and a dead loop look the same, which invites a long investigation of an error that is no longer current.

### Check the inner result, not only the transport status · *seed rule*
**Rule:** Treat an HTTP 200 or a clean run exit as delivery, not as evidence. Validate the payload's own status and required fields, and the output contract (allowed sources, limits) before a result opens a gate or feeds the next stage.
**Why it matters:** Many APIs and pipelines separate request delivery from the actual work. A green outer status can wrap an empty or out-of-scope result, and every downstream stage then builds on it.

### Switch to a narrower primitive when a command stalls · *seed rule*
**Rule:** If a broad command stalls or is impossible here, do not retry it. Use a narrower primitive: compare refs, read a blob with `git show <commit>:<path>`, hash only the changed paths, look for a runtime in task-local directories before declaring a test blocked.
**Why it matters:** Retrying reproduces the same bottleneck and fills the context with diagnostics; a missing PATH entry is weaker evidence than a runtime inventory.

### Verify what a sub-agent quotes before you cite it · *seed rule*
**Rule:** Before using a sub-agent's quotes or line references, check each one you will use against the source in one batched search (`grep -n -F`). Treat a line number beyond the reported file length as a sign that all its numbering for that file is wrong.
**Why it matters:** Extracted quotes look precise and survive review. Wrong references end up in documents that others cite.

### Measure where tokens go before redesigning memory · *seed rule*
**Rule:** Before adopting a memory or retrieval system to save tokens, measure input size at the first call, after grounding and near the limit. Optimise retrieval only for the startup share; handle growth during the session with checkpoints, compaction or shorter sessions.
**Why it matters:** Each tool round resends a growing context, so within-session growth often dominates startup cost. Judging by the final context size blames the wrong layer.

---

## Entries

*Add your own entries here, newest first.*

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
