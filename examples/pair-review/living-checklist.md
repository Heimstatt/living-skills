# Living Checklist — Pair Review

*Template example. The seed rules below are generalised rules, not observations. Add your own entries in the Entry Format.*

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
**Evidence:** [commit, issue or PR where it happened]
```

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Review only the builder-named aggregate · *seed rule*
**Rule:** Re-review and close findings only against the aggregate commit the builder names, together with the full patch and its verification evidence. Child fix commits and partial subsets are progress signals. Urgency changes when you review, not what you review. While the aggregate is missing, record a waiting state once instead of pinging again; resume when the artifact arrives.
**Why it matters:** Later fixes often touch the same shared helpers, so piecemeal closures can be invalidated without any single child commit looking wrong. Repeated pings add pressure toward presenting an unstable tree and add no evidence.

### Trace each test's real entry point and last real effect · *seed rule*
**Rule:** For every acceptance test, name where it actually enters (HTTP route, service call, function) and the last real effect it observes. For a route-to-state claim, require at least one unmocked request-plus-database test, and require that background work started by the request is stopped or awaited before teardown.
**Why it matters:** Suite names describe dependencies, not boundaries. A real-database suite that calls services directly and a route suite that mocks them can both be green while the seam between them is never exercised, and late background work leaks into the next test.

### Positive fixtures show which authority is accepted · *seed rule*
**Rule:** When a requirement names a specific permission, compare every positive test fixture's exact permission key and scope to that requirement, and assert which grant made the decision, not just `allowed`. Add a negative test where only a broader, compatible permission is present.
**Why it matters:** Resolvers often merge several grants for compatibility. A green end-to-end test that uses the broad grant proves the bypass the review was meant to rule out.

### Enumerating today's values does not make tomorrow's fail closed · *seed rule*
**Rule:** When a change classifies values (status codes, reasons, event kinds), positively select the class it is meant for, add an unknown or newly added member as a red test, and keep the expected classification independent of the production list.
**Why it matters:** An exclusion list grows the destructive set whenever a new value appears. A test that iterates the same production enum as the code agrees with it by construction.

### Force every gate of the same kind · *seed rule*
**Rule:** When the contract says "a lost compare-and-set means conflict" (or any per-step rule), list every such step in the workflow and force a failure at each one, especially the last one after external effects.
**Why it matters:** A test titled after the rule can cover only the first of several identical gates. The untested later gate is exactly where a foreign result gets returned as success.

### Success must come from the atomic transition · *seed rule*
**Rule:** Destructive state-transition helpers return whether their own compare-and-set won. Derive the response and the audit event from that result, never from an earlier precheck or from re-reading the final row.
**Why it matters:** If "I applied it" and "it was already terminal" share one return value, a race lets the route report success and write an audit record for an action it never performed.

### A partly valid finding is restricted at its boundary · *seed rule*
**Rule:** When a finding is only partly right, or its remedy would remove a needed effect, list the effects of the code in question one by one. Keep what restores an invariant, drop what the finding correctly rejects, add a negative test for the retained part, and ask for re-review of that restriction.
**Why it matters:** Helpers often combine one required cleanup with several forbidden side effects. Accepting or rejecting the finding wholesale turns a sound finding into an unsafe fix, or loses it.

### Local proof of a gate is not proof the host runs it · *seed rule*
**Rule:** For a server hook, policy plugin or deployment gate, give two verdicts: source (the logic is right in tests) and cutover (a real authenticated positive and negative attempt through the installed service, on every write path). For a plan review, mark the contract fixed at a named commit and defer runtime proof with owner, deadline and no-go consequence.
**Why it matters:** Tests that supply the identity themselves and call the script directly cannot show that the real service invokes it or passes the identity it trusts. Calling the finding closed from good prose fabricates execution evidence.

### Stacked PRs are gated head by head · *seed rule*
**Rule:** Run the required checks on each proposed publication head, then on the combined head. Move a prerequisite fix into the earliest branch that needs it and rebase the rest.
**Why it matters:** The combined head can pass while the first PR, which upstream review and CI see on its own, still fails.

### A toy task does not prove a real-work gate · *seed rule*
**Rule:** Pin the task and its real acceptance purpose before execution. If an easier task is useful as a wiring check, label it as one and still require the original task before the gate passes.
**Why it matters:** Mechanism checks and outcome checks both end in "tests green". Swapping in an easier artifact after the gate is defined yields an honest test result and an invalid verdict.

### Before disputing "it is only metadata", find every reader · *seed rule*
**Rule:** Before the builder disputes that a changed field or side effect matters, search for every read of it (filters, sort orders, cutoffs, sync cursors). Ask the reviewer for the concrete consumer; if it holds, concede in writing in your own response.
**Why it matters:** "Only a timestamp" is a typical builder blind spot. A column is state as soon as any query filters or sorts on it.

### The builder's own extra findings need their own red run · *seed rule*
**Rule:** Any additional defect the builder claims and fixes during remediation gets a red run with a test that tells exactly the two behaviours apart, before it enters the response. If the red run disproves it, say so in the response as an own error instead of silently keeping the change.
**Why it matters:** Fixes made "while I was at it" carry the builder's original blind spots and bypass review. A red run only proves something if the test can distinguish the behaviours.

---

## Entries

---

## Archive

*Entries moved here when context fundamentally changed or superseded.*
