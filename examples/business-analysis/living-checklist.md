# Living Checklist — Business Analysis

*Template example. It starts with seed rules instead of illustrative entries; record your own observations under Entries.*

**Purpose:** Application experience layer — patterns collected while applying the BABOK procedure. Grows with every session. Never merged back into SKILL.md.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded — NOT because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** Application experience stays here permanently. SKILL.md contains the BABOK method itself — only update it when the method changes, not because of what you learned applying it.
**Shareable:** Entries describe generalisable method patterns. Project names, decision IDs and client details stay in the project's own files.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / domain context] · *unconfirmed (1 observation)*
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete heuristic for the next session
**Evidence:** <commit, issue or PR where it happened>
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Name the decision before tuning the delivery · *seed rule*
**Rule:** Before another trial, iteration or build round, name the decision owner, the decision question, the evidence that decision needs and the existing alternative it competes with. In any retrospective, report output quality, operating cost and decision value as three separate findings; decision value stays "unknown" until the owner used a defined comparison and recorded a choice.
**Why it matters:** Every failed run offers a concrete technical variable to change, while the purpose of the service stays implicit. Teams then optimise machinery that cannot change the decision it was meant to support.

### Elicit stakeholders before packaging options · *seed rule*
**Rule:** Map actual and possible stakeholder groups with the sponsor before framing direction options. Record each group as a candidate with its evidence status, state the change or service boundary for this analysis pass, and distinguish users, payers, affected parties, authorities and suppliers. Treat "the market" as a search space, not as one stakeholder with one need. Derive stories only after needs are confirmed.
**Why it matters:** Available solution evidence is concrete while the human landscape is an assumption, so needs get assigned to stakeholders nobody asked, and stakeholder relationships shift silently whenever the implied scope shifts.

### Keep stakeholder aims visible as options · *seed rule*
**Rule:** When the proposed next step narrows an aim a stakeholder stated earlier, show the alternatives and their costs as an explicit decision. Label the preferred step a hypothesis until the owner chooses; do not move the earlier aim to Out-of-Scope on your own.
**Why it matters:** The cheapest next experiment easily becomes the working definition of the whole service, and the original aims disappear without anyone having decided against them.

### Derive the capability contract before shrinking a test · *seed rule*
**Rule:** Before designing a smaller probe, derive the minimum capability from the user stories and state which requirements the probe can and cannot verify. If the probe removes a must-have capability, call it a component test and never count it as acceptance of the service.
**Why it matters:** Testability and cost pressure push towards smaller probes, and a probe keeps its original name long after it stopped containing what the stories require.

### Judge every case against every precommitted condition · *seed rule*
**Rule:** Evaluate each case against each acceptance condition fixed in advance, separately. A favourable sub-signal with a missing cost or outcome measure is reported as partial. For every comparison, name the alternatives, the task, who saw what, the result and the missing outcome; never transfer a later, integrated result back to an earlier component test or average across cases.
**Why it matters:** A visible vote or preference is easier to report than the full condition, and a shared label like "positive comparison" hides that two results concern different objects with different causal limits.

### Separate kinds of evidence · *seed rule*
**Rule:** Keep problem evidence, purchase intent, sponsor targets and trial progress in distinct fields. For every trial, state which target or need it actually tests, which human outcome remains unmeasured and whose correction effort belongs in the total cost. A reported problem from peers or adjacent operators is market evidence, not demand; a differentiator stays a hypothesis until its value to a target group is shown.
**Why it matters:** Targets and trials recorded in neighbouring sections read as causally linked, and missing buying evidence either inflates or wrongly dismisses what real problem reports reveal.

### Split stories by the decision they support · *seed rule*
**Rule:** Before promoting a "trust" or "verification" story, identify the decision it serves. Split proof that one action was performed, coverage of a test set and freshness of the underlying data into separate stories when different people, moments or counterexamples are involved; link them to the shared need, but give each its own acceptance criteria.
**Why it matters:** These concerns all sound like "can I trust the result", yet they arise at different decision points and need different evidence. A merged story gets acceptance criteria that no single test can satisfy.

### Write negative capabilities for roles that own shared context · *seed rule*
**Rule:** When a role mechanically owns shared state or routing (an inbox, a board, a dispatcher), separate mechanical ownership from authority in the requirements. Add enforced negative-capability NFRs ("cannot act on behalf of others, cannot decide, cannot alter content, no access without a declared capability", checked server-side, binary pass/fail), a matching Out-of-Scope entry and an overreach risk. Keep routing and authority rules deterministic policy, not model or operator judgement.
**Why it matters:** Holding the context looks like holding power. Positive requirements ("routes messages") never forbid the abuse, so authority accrues to the role by default.

### Let influence follow formal decision rights · *seed rule*
**Rule:** After any governance or decision-rights change, re-check the stakeholder register: influence ratings follow formal decision rights, not activity or visibility. When roles exist only in practice, document them in one table with an "explicitly not responsible for" column, and mark superseded role names as history.
**Why it matters:** Influence columns are filled by intuition when the register is first written, governance rules arrive later in other sections, and nobody reconciles the two. Undocumented negative scope is how a role quietly becomes a backdoor.

### Label applicability after a pivot · *seed rule*
**Rule:** When the implementation platform or architecture changes, separate durable needs from retired implementation prescriptions. Keep requirement IDs and signed historical contributions, but label each one's applicability. Compare documentation against the version actually under test, and never let one passing slice stand in for an overall go.
**Why it matters:** Accepted decisions and requirements keep the old architecture's vocabulary, so recent-looking notes are mistaken for verified capabilities of the new one.

### Close linked documents in the same pass · *seed rule*
**Rule:** When a comparison or decision closes, update every linked intake, status field and next action in the same pass. When resuming after a break, verify each open question in a handoff note against the current analysis before asking it again, and mark superseded handoff lines as history.
**Why it matters:** Results and next actions live in different documents. The older one keeps an obsolete open question and remains a plausible starting point after a cold restart, so stakeholders get asked things they already answered.

### Separate method artefacts from field execution · *seed rule*
**Rule:** When a case is underspecified, a reusable method artefact and an internal dry run can still be built, with explicit assumptions and listed missing inputs. Field execution requires a named actor, access, measures and limits first. A dry run never counts as outcome evidence.
**Why it matters:** The acceptance gate of one case is easily carried over to the reusable template, which either blocks useful preparation or, the other way round, lets a rehearsal pass as a result.

---

## Entries

*Your own observations go here, in the Entry Format above.*

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
