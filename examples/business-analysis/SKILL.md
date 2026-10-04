---
name: "Business Analysis"
description: "BABOK/CBAP-oriented business analysis procedure. Trigger: 'create a requirements doc', 'document stakeholders', 'write user stories', 'what are the requirements for X', 'gap analysis', 'risk register', building a new product or feature from scratch, onboarding into a new domain."
type: "behavioral"
living-checklist: "yes"
---

# Business Analysis — BABOK/CBAP Procedure

*Example skill, published as a template. Adapt the procedure to your own team and practice.*

**Applies to:** New product/feature definition, product discovery, requirements elicitation, project scoping.

---

## When to Activate

- Starting a new feature, product, or project from scratch
- "What are the requirements for X?"
- "Document the stakeholders / user stories / acceptance criteria"
- "Do a gap analysis between what we have and what we need"
- Onboarding into a new domain (what exists, what's missing, who needs what)
- Preparing for a demo or stakeholder presentation
- Risk identification before building starts

---

## Session-Start Ritual

1. Read this `SKILL.md`
2. Read `living-checklist.md` — load accumulated patterns
3. Output the Skill Activation Protocol:

```
SKILL ACTIVATED: business-analysis
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
```

---

## The BABOK Chain — Seven Steps in Order

Complete each step before proceeding to the next. Each step's output feeds the next.

---

### Step 1 — Executive Summary & Business Need

**Questions:**
- What problem does this solve? What is the business need (BN)?
- What triggered this project? (compliance, tech debt, market need, user pain)
- What are the business goals (BG)? What does success look like?
- What is the current status? (greenfield / replacement / MVP / enhancement)

**Output:**
- 1–2 paragraphs of context
- Business Needs table: `BN-ID | Business Need | Cause`
- Business Goals table: `BG-ID | Goal`

---

### Step 2 — Stakeholder Analysis

**Questions:**
- Who is affected by the system? (directly using it, impacted by it, deciding about it)
- For each stakeholder: influence (Very high/High/Medium/Low), interest, expectations
- Who are primary users? Who are secondary? Who are decision-makers?

**Output:**
- ASCII stakeholder map (shows relationships between system and actors)
- Stakeholder Register: `SH-ID | Name | Type | Influence | Interest | Expectation`
- Per-stakeholder Needs tables: `Need-ID | Description | Priority (Must/Should/Could)`

---

### Step 3 — User Personas

**Questions:**
- Who are the 3–5 concrete human representatives of the key stakeholder groups?
- For each: realistic name, company, role in the system, profile, goals, pain points, technical level

**Output:** 3–5 persona cards with consistent structure:
```
### Persona [Letter] — "[Archetype label]"
> Name, Company, Role
Profile, Goals, Pain points, Technical level
```

---

### Step 4 — Epics and User Stories

**Structure:**
1. Define Epics (functional areas, `E-1..N`) with affected stakeholders
2. Write User Stories per Epic

**User Story format:**
```
> As a [Role] I want to [Action]
> so that [Goal].

*Acceptance criteria:*
- [concrete, testable — binary pass/fail]
- [concrete, testable — binary pass/fail]
```

**Quality checks per story:**
- Role is a named stakeholder type (not "user" or "system")
- Action is specific: "create X" / "view X" / "approve X" — not "manage X"
- Each acceptance criterion is binary (passes or doesn't)
- Must-have stories have ≥ 2 acceptance criteria
- Security-relevant stories have an acceptance criterion testable at server level (not UI only)

---

### Step 5 — Functional and Non-Functional Requirements

**FR table:** `FR-ID | Requirement | Epic | Status`
- Priority tiers: Must (MVP) / Should / Could (Backlog)
- Status: ✅ Implemented / ⏳ In progress / Planned / Open

**NFR table:** `NFR-ID | Category | Requirement | Measure`
- Categories: Security, Performance, Operations, Maintainability, Privacy, Scalability, Portability, Data Integrity

**Quality check:** Every NFR must have a concrete measurable criterion. "Must be secure" is invalid. Rewrite as: "Authorization via stable junction table; enforced in server action, not only UI."
Security NFRs should reference the decision (ADR-xxx) or finding that motivated them.

---

### Step 6 — Gap Analysis: As-Is → To-Be

**Questions:**
- What exists today? (manual process, legacy system, nothing)
- What will exist after? (new system behavior, new data model)
- Where is the delta?

**Output sub-sections:**
- Process comparison: `Step | As-Is | To-Be`
- Data model delta: `Entity | Legacy System | New`
- Security delta: `Gap / Vulnerability | As-Is | To-Be` (even if legacy had no security model, name that explicitly)

---

### Step 7 — Risk Register + Out-of-Scope

**Risk Register:** `R-ID | Risk | Likelihood | Impact | Mitigation`
- Likelihoods: High / Medium / Low / Unknown
- Impact: Very high / High / Medium / Low

**Out-of-Scope table:** `OOS-ID | What | Reason`
- Rule: never leave "obvious exclusions" undocumented. Explicit OOS prevents stakeholder confusion.
- If something was discussed and rejected, it must appear here with the reason.

---

## Supplementary Sections (add when relevant)

| Section | When to add |
|---------|-------------|
| Constraints (`C-ID | Constraint | Type`) | Known technical/legal/team limits |
| Assumptions (`A-ID | Assumption | Risk if wrong`) | Decisions made without full information |
| Glossary | Always — domain terms that could be misread |
| Architecture summary (ASCII) | When system has multiple components or deployment targets |
| Phase plan (`Phase | Content | Status`) | When delivery is incremental / sprint-based |

**Glossary tip:** Write it early (end of Step 1), before user stories. Add a term the moment it first appears in a story. "Obvious" terms are the ones that cause the most review confusion.

---

## Output Format

```
# Business Analysis — [Project Name]
## [Product Name / Subtitle]

Date: YYYY-MM-DD | Status: [MVP / Demo / Production]

1. Executive Summary
2. Project Context & Business Goals
3. Stakeholder Analysis (map + register + needs)
4. User Personas
5. User Stories (by Epic, E-1..N)
6. Functional Requirements (Must / Should / Could)
7. Non-Functional Requirements
8. Gap Analysis: As-Is → To-Be
9. Constraints & Assumptions
10. Risk Register
11. Out-of-Scope
12. (opt.) Technical Architecture Summary
13. (opt.) Phase Plan
14. Glossary
```

---

## Stop Criterion

Business analysis is ready for handoff when:
- All 7 steps completed (no step skipped — mark "N/A" with reason if truly not applicable)
- Every must-have story has ≥ 2 acceptance criteria
- Security NFRs have concrete measurable criteria, each mapping to a decision or finding
- Risk register has ≥ 1 mitigation per high-impact risk
- Out-of-Scope is explicitly populated (not empty)
- Glossary covers all domain-specific terms used in stories and NFRs

---

## Session-End Ritual

After use: write patterns from this session into `living-checklist.md`.
Format: Date, context type (what kind of domain/project), pattern found, why it happened, rule for next session.
Update `revisionslog.md` only if `SKILL.md` itself was changed.
