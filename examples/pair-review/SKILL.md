---
name: "Pair Review (Cross-Model Code Review)"
description: "Cross-model code review between team instances (e.g. a Codex instance reviews Claude-built code, or vice versa): structured findings, mandatory critical response with documented dispute, re-review against a named commit. Trigger: 'review the repo', 'respond to the review', a new Code-Review file appears in a project folder, or a builder instance finishes a milestone that needs independent eyes. NOT the built-in /code-review command — this is the team protocol around it."
type: "behavioral"
living-checklist: "yes"
---

# Pair Review — Cross-Model Code Review

Two instances with **different model families** pair up: one **builds**, the other
**reviews**. The value is uncorrelated blind spots — whoever builds something
verifies it with the same assumptions they built it with, so self-review
structurally misses the most dangerous error class. This applies to AI exactly as
it does to humans.

Three non-negotiables:

1. **The reviewer never fixes; the builder never reviews their own work.**
2. **The builder must respond critically** — accepting every finding unexamined is
   as much a protocol violation as ignoring one. Disagreement is a duty, in both
   directions, and it gets documented.
3. **Disputes are settled by runnable evidence** (a test, a reproduced failure, a
   rendered artifact), not by additional review rounds or seniority.

---

## Roles & Artifacts

| Role | Writes | Location |
|---|---|---|
| **Reviewer** | `Code-Review (<Model>) <ISO-timestamp>.md` — revision-numbered, replaces its own previous revision | Project folder (e.g. `Projects/<project>/`) |
| **Builder** | Response doc per review revision | Own `Team Memory/<instance>/` folder |

Both reference a **named commit** — a review without a commit hash, or a response
without one, is incomplete.

---

## Procedure — Reviewer

1. **Pin the target:** `git pull`, note the exact commit hash under review and the
   comparison base (previous reviewed commit, if any).
2. **Verify, don't assume:** run every check available on the host (typecheck,
   lint, build, tests, audit, template rendering). Record what could NOT be run
   and why — that list is part of the review, not a footnote.
3. **Findings:** each with severity (P1 = release blocker, P2 = before handover),
   exact location (file:lines), the failure scenario, and a **binding
   remedy**. Separate genuinely accepted residual risks from defects — mixing
   them dilutes both.
4. **Own your errors:** if a finding from a previous revision was wrong, retract
   it explicitly and visibly ("zurückgezogen, weil …"). Revisions replace earlier
   revisions completely.
5. **Verdict:** release recommendation + the ordered remediation sequence.

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
