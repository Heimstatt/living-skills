---
name: assess-strategic-distinctiveness
description: Pressure-test whether a business, product, or strategy concept is meaningfully distinctive, independently reasoned, distributable, defensible, and durable. Use when a team claims it is creating something new, escaping competition, has a contrarian insight or unfair advantage, or wants a declared Zero to One lens applied without treating that lens as proof of viability.
---

# Assess Strategic Distinctiveness

Challenge the strategic delta between a concept and its alternatives. Use Peter Thiel and Blake
Masters' *Zero to One* as a named diagnostic lens, expose narrative-only claims, and return a
review that separates distinctiveness from demand, desirability, and moral worth.

## Activation

Read `living-checklist.md` completely. Then output before the first task step:

```text
SKILL ACTIVATED: assess-strategic-distinctiveness
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date]
Active rule: "[verbatim newest relevant rule]"
Approach: [2–3 sentences describing the challenge and bias controls]
```

Read `references/zero-to-one-lens.md`. Use
`assets/strategic-distinctiveness-review-template.md` for the final artifact.

## Required inputs

- the concept and decision it is intended to support;
- claimed difference from real alternatives, including doing nothing;
- evidence supporting the difference and customer relevance;
- proposed mechanism for defensibility and durability;
- distribution or market-access assumptions;
- material constraints and the accountable line unit.

## Workflow

### 1. Establish the comparison

Name the actual alternative set and the dimension on which the concept claims to differ. Do not
accept “no competitors” without checking substitutes, workarounds, internal solutions, and
nonconsumption.

### 2. State the zero-to-one claim

Ask what qualitatively new capability, value, or business logic is claimed, versus merely scaling
or copying an existing one. Treat both outcomes as legitimate descriptions; incremental does not
mean unviable.

### 3. Expose the independent thesis

State the important belief the team holds that conventional actors appear not to hold, why it may
be true, and what observable result would falsify it. A provocative sentence without a causal
mechanism is narrative, not an insight.

### 4. Challenge the strategic mechanism

Inspect separately:

- meaningful customer or system delta;
- proprietary capability, network, learning, scale, brand, switching, regulatory, or other
  defensibility mechanism;
- access and distribution mechanism;
- timing and enabling change;
- durability if competitors respond.

Classify each as evidence, hypothesis, or absent. Do not infer defensibility from uniqueness alone.

### 5. Control for lens bias

State where the lens may distort the case: technology and venture-capital orientation, preference
for category dominance, aversion to competition, or underweighting a sound incremental business.
Never reject a concept solely because it is not a monopoly-like opportunity.

### 6. Issue the review

Use one verdict:

- `Distinctive hypothesis`: a meaningful delta and mechanism exist but still require evidence;
- `Incremental but potentially viable`: little zero-to-one delta, without implying business failure;
- `Narrative only`: claims lack a causal mechanism or comparison;
- `Insufficient evidence`: the classification cannot yet be supported.

Return the artifact through `strategy` when called by the staff lead.

## Boundaries

- Do not claim demand, product-market fit, market size, monopoly, or superior economics.
- Do not equate strategic distinctiveness with ethical desirability or social value.
- Do not rewrite the concept merely to make it sound contrarian.
- Do not use the verdict as an automatic investment or stop decision.
- Do not substitute this role for customer discovery, positioning, or market-creation design.

## Stop criterion

Stop when the real alternatives, qualitative delta, independent thesis and falsifier, defensibility,
distribution, timing, durability, evidence gaps, lens bias, and calibrated verdict are explicit.

## After action

Add only repeatable review failures to `living-checklist.md`. Keep concept-specific evidence with
the project. Update `revisionslog.md` only when this procedure changes.
