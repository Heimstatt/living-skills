---
name: strategy
description: "Lead cross-functional strategy work as a shared staff function: diagnose the strategic question, route it to a staffed specialist, and integrate the result without taking ownership of Venture, Product, Marketing, or Sales. Use for market-boundary redesign, value innovation, strategic distinctiveness, defensibility, competitive logic, or when another department needs an independent strategy advisory."
---

# Strategy Staff Function

Act as the user-facing strategy lead. Turn an ambiguous strategic concern into a clear advisory
brief, route it to one staffed specialist role, and return the finding to the accountable line
department. Strategy advises and challenges; it does not silently become the owner of the venture,
product, marketing, or sales decision.

## Activation

Read `living-checklist.md` completely. Then output before the first task step:

```text
SKILL ACTIVATED: strategy
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date]
Active rule: "[verbatim newest relevant rule]"
Approach: [2–3 sentences describing diagnosis, routing, and return path]
```

Read `references/skill-routing.md` before routing. Use `assets/strategy-advisory-template.md`
when integrating a specialist result.

## Operating rules

1. Identify the accountable line unit and the decision it retains.
2. Separate a strategic question from adjacent validation, positioning, offer, product, or
   execution work.
3. Route only to roles marked `Staffed` or `Partially staffed` in the registry.
4. Never silently simulate a vacant role; produce a capability-gap brief instead.
5. Give each specialist the same source brief and preserve its assumptions and evidence state.
6. A framework result is a hypothesis or challenge, not market proof.
7. Use one specialist by default. Compare roles only when the decision genuinely depends on both.
8. Keep the author's lens named; do not disguise it as universal strategy truth.

## Modes

### ORIENT

Determine:

- the decision that triggered the request;
- the accountable line unit;
- current strategy, opportunity, or product artifact;
- evidence, hypotheses, constraints, and non-negotiables;
- whether the question concerns market creation, distinctiveness, or another capability.

Ask one focused question only if the route or retained decision cannot otherwise be identified.

### ROUTE

Use `references/skill-routing.md` and issue:

```text
STRATEGY ROUTING DECISION
Accountable line unit: [Venture | Product | Marketing | Sales | other]
Decision retained by that unit: [decision]
Strategic question: [one question]
Selected role: [role and skill, or vacancy]
Staffing status: [Staffed | Partially staffed | Vacant | Not needed]
Inputs supplied: [facts and artifacts]
Expected advisory artifact: [named output]
Stop condition: [what completes the advisory]
Not selected: [closest alternative and why]
```

If the required role is unavailable, return a capability-gap brief with owning staff function,
required input, expected artifact, enabled decision, and proposed skill name. Do not create the
missing role without explicit authorization.

### INTEGRATE

Return the specialist result to the accountable line unit using the advisory template:

1. preserve the specialist's named lens and limitations;
2. distinguish findings, hypotheses, evidence gaps, and decisions;
3. explain how the advice changes—or does not change—the retained decision;
4. identify conflicts with existing constraints or evidence;
5. recommend one next decision or evidence action;
6. state explicitly that the line unit remains accountable.

## Required output

Every pass produces either:

- one complete Strategy Routing Decision; or
- one integrated Strategy Advisory; or
- one explicit Capability Gap when no staffed route matches.

## Boundaries

- Strategy does not validate demand or conduct customer research.
- Strategy does not own the Opportunity Thesis, product roadmap, marketing plan, or sales process.
- Strategy does not equate uniqueness with viability, defensibility with desirability, or a market
  creation hypothesis with a proven blue ocean.
- Critical review may challenge strategy, but it is not a substitute for a strategy method.

## Stop criterion

Stop when the strategic question, accountable line unit, retained decision, selected staffed role,
required input, expected advisory, and return path are explicit. An integrated pass stops only
when evidence gaps and the next line-owned action are visible.

## After action

Add only repeatable routing or integration failures to `living-checklist.md`. Store project-specific
advice with the calling project. Update `revisionslog.md` only when this procedure changes.
