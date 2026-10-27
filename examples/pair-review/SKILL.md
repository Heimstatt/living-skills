---
name: pair-review
description: "Cross-model code review between team instances (e.g. a Codex instance reviews Claude-built code, or vice versa): structured findings, mandatory critical response with documented dispute, re-review against a named commit. Trigger: 'review the repo', 'respond to the review', a new Code-Review file appears in a project folder, or a builder instance finishes a milestone that needs independent eyes. NOT the built-in /code-review command — this is the team protocol around it."
metadata:
  type: "behavioral"
  living-checklist: "yes"
---

# Pair Review — Cross-Model Code Review

Two instances pair up: one **builds**, the other **reviews**. The rule is that
they come from **different model families**. The value is uncorrelated blind
spots — whoever builds something verifies it with the same assumptions they built
it with, so self-review structurally misses the most dangerous error class. This
applies to AI exactly as it does to humans. A reviewer from the same family is a
visibly marked exception with less of that value, never the default (see
"Independence").

Three non-negotiables:

1. **The reviewer never fixes; the builder never reviews their own work.**
2. **The builder must respond critically** — accepting every finding unexamined is
   as much a protocol violation as ignoring one. Disagreement is a duty, in both
   directions, and it gets documented.
3. **Disputes are settled by runnable evidence** (a test, a reproduced failure, a
   rendered artifact), not by additional review rounds or seniority.

---

## Independence

A pair review in the full sense needs a reviewer from a **different model family**
than the builder. Every review states which case it is:

- **`other lab`** — different model family. Only this counts as a pair review.
- **`same lab (exception)`** — same family, different instance. A visibly marked
  exception for limited internal reviews, not a full pair review. A subagent the
  builder starts itself falls here, and so does a same-family reviewer inside a
  worker pipeline; a later gate approval does not turn it into `other lab`.
- **No review** is not a value of this field. Work closed unreviewed gets no review
  header; it appears in the log as `no review` with a reason and is excluded from
  round and finding counts.

**P1-relevant work needs `other lab`.** Classify before the review order is
written. An order is P1-relevant when it touches permissions, secrets, possible
data loss, anything public, or a network boundary (firewall rules, new outside
exposure, new access to production). When in doubt, it is P1-relevant. If
`other lab` is not available, escalate the deviation with a named risk acceptance
(who carries it, by when the review is caught up).

---

## Roles & Artifacts

| Role | Writes | Location |
|---|---|---|
| **Reviewer** | `Code-Review (<Model>) <ISO-timestamp>.md` — revision-numbered, replaces its own previous revision | Project folder (e.g. `Projects/<project>/`) |
| **Builder** | Response doc per review revision | Own `Team Memory/<instance>/` folder |
| **Gate owner** (optional) | Approval to go live, gate findings | Wherever your process records go-live decisions |

Both reviewer and builder reference a **named commit** — a review without a commit
hash, or a response without one, is incomplete.

---

## Procedure — Reviewer

1. **Pin the target:** `git pull`, note the exact commit hash under review and the
   comparison base (previous reviewed commit, if any). The target is the
   builder-named aggregate commit; child fix commits are neither a target nor a
   round, and waiting for the aggregate is a state, not a round.
2. **Verify, don't assume:** run every check available on the host (typecheck,
   lint, build, tests, audit, template rendering). Record what could NOT be run
   and why — that list is part of the review, not a footnote.
3. **Write the header and the verdict block** (see "Review as Data"). Every row
   is filled in.
4. **Findings:** each with severity (P1 = release blocker, P2 = before handover),
   exact location (file:lines), the failure scenario, and a **binding
   remedy**. Separate genuinely accepted residual risks from defects — mixing
   them dilutes both.
5. **Own your errors:** if a finding from a previous revision was wrong, retract
   it explicitly and visibly ("retracted, because …"). Revisions replace earlier
   revisions completely.
6. **Verdict:** release recommendation + the ordered remediation sequence.
   **Zero findings is a valid result** — do not pad a clean review to look
   rigorous. Hardening suggestions without a requirement behind them are listed
   apart from findings.
7. **From round 2 on,** put the "Since round" block before the findings.
8. **On close,** write the one log line for the order.

## Review as Data

Three fixed pieces per review and one log line per order, so reviews can be
counted and not only read.

### Header

```
Review:        <ticket or order id> · round <n>
Kind:          code | plan | release
Target:        <builder-named aggregate commit> (base: <commit or "none">)
Builder:       <instance> (<model family>)
Reviewer:      <instance> (<model family>)
Independence:  other lab | same lab (exception)
Ran myself:    <checks, with counts and skipped count>
Not run:       <checks, each with reason>
```

### Verdict block

```
| Criterion                                   | Verdict | Scope and evidence |
|---------------------------------------------|---------|--------------------|
| Does what the order or requirement asks     |         |                    |
| Adjacent contracts checked                  |         | <named scope>      |
| Failure paths are loud                      |         |                    |
| Tests prove the claim                       |         | <entry point, last real effect> |
| Stays inside the order's scope              |         |                    |
| Real data through the real path             |         |                    |
| Permissions and grant provenance (if AuthZ) |         |                    |
```

Four verdicts, no fifth:

- **`pass`** — checked, with evidence (command, line, count). No evidence, no pass.
- **`finding`** — points to the finding below.
- **`not checked`** — could have been checked and was not. A real gap; never
  counts as passed.
- **`not applicable`** — does not apply to this order, with the reason (e.g. real
  data in a pure plan review; the AuthZ row for work without permissions).

Row notes:

- *Adjacent contracts checked* names which neighbouring contracts were looked at;
  a global "breaks nothing" cannot be evidenced. For `Kind: release` this includes
  executable artifacts outside the diff.
- *Tests prove the claim* names each acceptance test's actual entry point and its
  last real effect.
- *Permissions and grant provenance* is mandatory as soon as the order touches
  authorization: exact key and provenance of the winning decision, every positive
  fixture, plus a negative test with only the broader key.
- For `Kind: plan`, a contract corrected at a named source commit with runtime
  proof deferred (owner, deadline, no-go consequence) is recorded as such. It is
  not a `pass`.

For small orders that add or change no guard (no permission check, safety check
or fail-closed path), header and log line are enough.

### Re-review block (round 2 and later)

```
Since round <n-1>:
  Compared:   <diff range, files, suites re-run>
  Fixed:      <finding ids>
  Improved:   <what got better beyond the findings>
  Worsened:   <what got worse, or "nothing found in the compared scope">
  Retracted:  <own findings withdrawn, with reason, or "none">
  Still open: <finding ids>
```

`Compared` bounds everything below it. `Worsened` and `Retracted` are mandatory;
an empty line is not a statement.

### Log line

One line per order in a review log (a `review-log.md` table next to this skill,
created on first use), however many rounds it took:

```
| Date closed | Ticket | Builder | Reviewer | Independence | Rounds | P1 | P2 | Gate findings missed in review | Found after close |
```

- **The reviewer writes it** on close. The gate owner supplies gate findings with
  link and time; the reviewer enters them with that origin.
- **A `no review` line has no reviewer to write it.** Whoever closes the order
  writes it: the gate owner, or the builder if there was no gate. Without these
  lines a later evaluation has no denominator.
- If gate owner and builder are the same instance, mark `gate = builder`. That
  mark is not independent gate evidence.
- A fix the gate owner makes at the gate is entered as
  `gate fix by <instance>, <commit>` and counts as checked only after a second
  instance has looked at it.
- Later discoveries go into the last column as a dated addendum with source. The
  rest of the line is never silently edited.
- P1/P2 count reported findings, not closure claims.

Evaluate the log after a fixed period (for example four weeks): rounds per order,
share of `same lab (exception)` and `no review`, number of gate findings missed in
review.

## Procedure — Builder (responding)

1. **Read the full review first.** No fixing while reading.
2. **Classify every finding individually** — three buckets, no fourth:
   - **Accept → fix** (with commit ref and how the fix was verified),
   - **Reject/restrict → justify** (technical reasoning, ideally with runnable
     evidence; never silent),
   - **Defer → owner + deadline + documented risk acceptance.**
3. **Never blind-remediate.** Evaluate the reviewer's *suggested* remedy
   separately from the *finding* — a correct finding can come with a wrong fix
   (e.g. a dependency downgrade suggestion that is worse than the vulnerability).
4. **Verify each fix against the requirement, not against the implementation** —
   re-derive the expected behavior from the spec/requirement document, then test.
5. **Write the response doc** with exactly the three sections from step 2 —
   "Rejected/Disputed" is a mandatory section even when empty ("no
   rejections" is a statement, absence of the section is not).
6. **State verification scope honestly:** list what was tested AND what was not
   testable on this host. Never claim "closed" beyond what the checks actually
   cover.
7. **Request re-review against the new named commit.**

## Dispute Protocol

- One point, **max two rounds** of written disagreement without new evidence.
- After that: build the **arbiter** — a test or reproduction that makes the
  disputed claim executable. Whoever asserts a behavior writes the test for it.
- If no arbiter is buildable on available infrastructure, escalate to the human
  with both positions summarized in ≤5 lines each.
- Retractions and lost disputes are documented by the side that was wrong — in
  their own artifact, not silently edited away.

## Stop Criterion

The cycle for one revision is done when: every P1 is fixed-or-rejected-with-
agreement, every P2 is fixed or has owner/deadline/risk-acceptance, the response
doc is pushed, and re-review against a named commit is requested. The overall
pairing ends with a release recommendation both sides carry.

---

## Session-Start Ritual

1. Read this `SKILL.md`.
2. Read `living-checklist.md` — load accumulated knowledge.
3. Output the Skill Activation Protocol (mandatory, with verbatim quote of the
   most recent relevant rule).

## Session-End Ritual

Write new insights to `living-checklist.md`: every reviewer error class you fell
for, every dispute and how it resolved, every fix that a later revision refuted.
Format: date, context, insight, rule. Update `revisionslog.md` if `SKILL.md`
itself changed.
