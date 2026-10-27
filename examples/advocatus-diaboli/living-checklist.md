# Living Checklist — Advocatus Diaboli

*Template example. The seed rules below are generalised from long use, not observations; the Entries section is yours to fill.*

**Purpose:** Application experience layer — review patterns collected while applying the skill.
Grows with every session. Never merged back into SKILL.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Analysis type / domain] · *unconfirmed (1 observation)*
**Learning:** What pattern was found / what failed
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check to apply in future sessions
**Evidence:** <commit, issue or PR where it happened>
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Separate context is not independent judgement · *seed rule*
**Rule:** For every delegated judgement (a second agent, a sub-agent, a "reviewer role"), name which dependence the mechanism actually removes: conversation history, briefing bias, model bias or shared evidence. If independence is decision-critical, require a neutral handoff plus a different model or a human challenge, or mark the result provisional. Disclosing the missing independence does not replace it.
**Why it matters:** Organisational metaphors make a fresh context feel like a different person. The same model with the same briefing still shares tendencies, framing and evidence gaps.

### A role change must carry every behaviour of the old role · *seed rule*
**Rule:** When an actor moves to a different category (service account to user, agent to reviewer, job to webhook), list every behaviour the old role supplied (wake-up, context continuity, single-writer guarantee, hierarchy, scoped authority) and map each to a concrete mechanism in the new design. A behaviour that is only deferred stays an open gate; it is not satisfied because the interface changed.
**Why it matters:** A simpler, cheaper role makes the requirements that only the old role met disappear from view.

### Success in one role does not certify the whole platform · *seed rule*
**Rule:** Before a platform-level go, split the product into its roles (execution engine, system of record, identity and communication, governance gate, effect executor) and give each its own verdict. A pass in one role never transfers to another without its own evidence.
**Why it matters:** One product name covers several architectural claims. Visible success in the busiest role makes the untested roles feel like details.

### Usefulness does not authorise or verify the path that produced it · *seed rule*
**Rule:** When a result arrives after a scope expansion, split the verdict into three: functional result, authorisation provenance, reproducible safety evidence. A valuable output can pass the first while the other two stay failed or unknown. Summarised "tests are green" is not acceptance evidence until the exact controls that fired are named.
**Why it matters:** Speed and visible utility answer "did work happen"; review asks "which controls fired and what authority remained". Merged into one story, the desired answer wins before the safety claim is falsifiable.

### Run counts hide human nudges · *seed rule*
**Rule:** Pair every run or step count with an intervention count and a causal event timeline. Call a workflow autonomous only when assignment, wake-up, decision and handoff complete without human comments, status changes or manual recovery between the measured runs.
**Why it matters:** Metrics count executions, not control-plane interventions. A nudge creates no extra run and vanishes from the tidy one-run-per-step summary.

### Recovery is a state change, not a delivered message · *seed rule*
**Rule:** For recovery automation (watchdogs, retry nudges), key idempotency to the failed transition or stage episode, not to the ticket or object id. Store the marker on the authoritative side, re-check the mutable preconditions right before acting, and verify the downstream state change afterwards. Bound retries and escalate visibly.
**Why it matters:** "Posted once per ticket" looks idempotent, but an object can re-enter the same stage, a crash after the call can duplicate it, and an accepted comment or event does not prove that anyone started work.

### Compensation after a transition is not prevention · *seed rule*
**Rule:** When a safety step reads "after X, immediately set Y", trace whether X itself commits or queues the forbidden effect. Require a guard that is in force before X, or an atomic transition. A fast compensating action is not prevention.
**Why it matters:** Plans are written as a human sequence and hide the transaction and event ordering inside the platform; the compensating actor can always arrive too late, even when it works perfectly.

### Skipping a failed gate needs proven absence · *seed rule*
**Rule:** A pilot may proceed around a failed approval or governance mechanism only if it names the exact mechanism it does not invoke, proves the matching route, credential and effect are unreachable, and defines the first scope change that brings the gate back. Otherwise call it what it is: a waiver.
**Why it matters:** Scope reductions are written in prose, while dormant routes and credentials keep the excluded authority reachable.

### A marker is an attestation, not evidence · *seed rule*
**Rule:** For every compliance marker (commit trailer, checkbox, label, "done" flag), ask which independent repository or runtime fact proves its claim. If none exists, treat it as an override or attestation and never give it the meaning of an observed change.
**Why it matters:** Structured metadata is deterministic and easy to test, so being enforceable as syntax is mistaken for being true as fact.

### Coalescing distinct requests is not idempotency · *seed rule*
**Rule:** When a concurrency guard returns an existing operation for a request with a different idempotency key, ask whether the payloads and intended effects are provably interchangeable. If not, reject the competing request explicitly. Reuse a receipt only for a replay of the same logical request, and test both paths under the same lock.
**Why it matters:** Bounded run count and correct request semantics look like one property. Silently discarding a distinct payload makes the caller believe its intent was accepted.

### Superseded steps must leave the document · *seed rule*
**Rule:** After revising a runbook or procedure, search every old principal, variable and expected result through the whole file. Delete or visibly quarantine superseded executable steps, so exactly one canonical procedure and one acceptance matrix remain.
**Why it matters:** Operational documents are executed top to bottom. A "this replaces section N" notice does not remove the old commands, and an executor following the full file cannot reach an unambiguous pass.

### Re-check selectors after a model migration · *seed rule*
**Rule:** After the data model gains a durable field that replaces an older loose one (for example a scope column replacing a value inside a JSON blob), compare every selector in your change against the new binding, then check producer and trigger invariants before treating a record as reachable.
**Why it matters:** A clean rebase and green focused tests do not reveal a semantic change in selection when the changed schema sits outside the diff hunks.

---

## Entries

*Your own entries go here, in the Entry Format above.*

---

## Archive

*Entries move here when their context fundamentally changed or a more precise entry superseded them.*
