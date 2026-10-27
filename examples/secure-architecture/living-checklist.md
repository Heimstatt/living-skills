# Living Checklist — Secure Architecture

*Template example. It starts with seed rules instead of illustrative entries; record your own observations under Entries.*

**Purpose:** Application experience layer — patterns collected while reviewing authorization models. Grows with every session. Never merged back into SKILL.md.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded — NOT because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** Application experience stays here permanently. SKILL.md contains the review method itself — only update it when the method changes, not because of what you learned applying it.
**Shareable:** Entries describe generalisable patterns. Project names, internal field names and decision IDs stay in the project's own files.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / system context] · *unconfirmed (1 observation)*
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check for future sessions
**Evidence:** <commit, issue or PR where it happened>
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Calculate effective authority, not the visible role · *seed rule*
**Rule:** Inventory authority as the union of explicit grants, role and membership defaults, privileged-role bypasses, negative role checks ("anything that is not read-only"), active keys and sessions. Before adding a role, search every check that compares against the restrictive role; before activating a least-privilege role, prove the platform can actually express empty defaults. When demoting or deactivating a principal, revoke and read back every source, and report stored-but-dormant grants as reactivation risk.
**Why it matters:** Grant tables look exhaustive while role-derived allow branches live elsewhere in the code. A lower role label or a short explicit-grant list routinely understates what the principal can do.

### Trace a grant through all its side effects and payload fields · *seed rule*
**Rule:** For every create, comment, stop or status grant, trace all synchronous and fire-and-forget effects after the primary write (wake-ups, retries, recovery, successor jobs, reopened state) and every optional field the endpoint accepts. Either authorise each downstream capability separately or build an inert path whose end state is only the named record plus audit. Before reusing a helper on a new policy path, list every control and write it performs. Count approvals in actual executions, not only in business steps.
**Why it matters:** Permission review stops at accepted input and the primary write, while lifecycle orchestration and administrative payload modes accumulate behind the same route and helper names.

### A composite action takes the strongest primitive's tier · *seed rule*
**Rule:** Expand every composite action into its typed primitives before approval and assign the highest required authorization tier to the whole. Neither a benign headline, a cleanup or rollback step, nor a disposable target downgrades a reserved primitive.
**Why it matters:** Reviewers classify intent and expected outcome; the executor acts through individual primitives whose authority and failure modes differ. Policy that keys on the value of the target instead of the operation creates a precedent for automation.

### An approval layer is a gate only at an exclusive choke point · *seed rule*
**Rule:** Every protected effect must pass through one independently enforcing, least-privileged executor, and negative tests must prove requesters hold no equivalent direct path. Before acting, verify that each approver has authority for the action class. Verify a forwarded approval at its source (stable actor ID, chronology, the exact proposal it answered); never accept a quote as the artefact and never backdate approval after a violation.
**Why it matters:** Approval logic can be correct and still bypassable when requesters keep direct credentials. Multi-party approval feels like shared liability, so each participant assumes another checked the outer boundary.

### A negative test must attempt the forbidden operation, through the real path · *seed rule*
**Rule:** Every negative test names the attempted operation, the expected denial and the unchanged end state. Ask "would this test fail if I deleted the guard?"; if not, it is an invariant check. For each new grantable capability, at least one test enters through the real transport route with a real actor and database and asserts allowed and forbidden end states.
**Why it matters:** "Nothing happened" looks the same for a safe final state and a successful denial. Service tests with a real database and route tests with mocks each pass alone while the security property lives in the untested composition between them.

### Isolation is defined by the effective principal and execution target · *seed rule*
**Rule:** Before calling workers isolated, trace the effective OS user, group, ACLs, database principal and final execution target of each. Give mutually untrusted principals private temporary directories, not just private file modes. Re-prove every boundary when the execution target changes; controls installed on a different target are not defense in depth.
**Why it matters:** Separate agent records, directories, containers or sandboxes look like separate principals while sharing one runtime identity, and two "isolation" mechanisms may in fact select different places to run.

### Name the adversary for every credential and every input · *seed rule*
**Rule:** For each credential, state who it must be protected from and test readability and exfiltration from inside the process that could be compromised. File mode `0600` protects against other users, not against untrusted code running as the owner. Propagate the untrusted label through extracts, summaries and handoffs; every consumer of tainted output needs the same restrictions as the ingress worker, or the handoff passes a trusted sanitisation or human step. Treat declared file types as claims and validate content.
**Why it matters:** Hardening follows the component that touches the network, while the property belongs to the whole information flow. An isolation suite can turn credential readability into a green test.

### Safety modes and network allowlists are not authorization · *seed rule*
**Rule:** Prove that the principal itself lacks the forbidden privileges. A read-only session flag, a kill switch with a caller-selectable bypass, a loopback listen address or a single allowed port do not restrict what the principal could do. Enumerate every route reachable through an allowed destination under valid, invalid and absent credentials; if the surface is broader than intended, add a narrow authenticated adapter.
**Why it matters:** Runtime modes produce the desired behaviour on the happy path and are easy to demonstrate, while effective authority is decided by grants across every possible session and route.

### Every temporary or dedicated identity gets minimal grants and a distinct revoker · *seed rule*
**Rule:** Before a time-boxed privileged workflow starts, name the separate, available principal who will revoke it and read back that principal's grant. Give automation and integration accounts a supported enrolment path, stable identity, minimum task grants and explicit expiry; repository access must not carry a host shell. When downgrading a privileged integration to a normal user, provision the factors that normal users need instead of relaxing the global policy, and prove both the allowed and the denied endpoints.
**Why it matters:** Self-revocation is usually forbidden by design, and privileged accounts are often exempt from controls such as MFA. Both constraints stay invisible until the least-privilege step is taken.

### A terminal row is not a stopped executor · *seed rule*
**Rule:** For every interrupt or cancellation, prove per runtime lane that exactly one caller wins, the real owner was signalled and settled, and only then the owned lock is released. Propagate the final compare-and-set outcome to API and audit; never report a lost final transition as success by rereading the current row.
**Why it matters:** The database transition looks like the authoritative event, while process ownership and lock release are treated as cleanup. Database state and running execution are separate facts.

### Attribution is not authorization · *seed rule*
**Rule:** Bind the responsible principal to the protected object, or resolve it through an immutable reference, and check it before every terminal mutation. Keep attribution, queue routing and authorization as separate controls; evidence in a log cannot replace a deny-capable gate. When only one principal can reach a protected runtime, make a schema-fixed evidence bundle a mandatory output of each run.
**Why it matters:** Provenance, routing and authorization reuse similar identity fields, so an audit-only reference looks like enforced ownership, and exclusive access makes verification depend on the executor's own summary.

### Scope holds and approvals to the exact surface · *seed rule*
**Rule:** For every security hold, name the principal, capability and effect it protects, and apply it only to workflows that use that surface. When a later approval intersects an active hold, compare principal, capability, resource boundary and operating mode field by field; supersede only the overlap and keep every other finding open.
**Why it matters:** Holds and approvals are phrased at different levels of abstraction. A global "no live work until review passes" either blocks unrelated progress or, read as superseded, silently drops controls that still apply.

---

## Entries

*Your own observations go here, in the Entry Format above.*

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
