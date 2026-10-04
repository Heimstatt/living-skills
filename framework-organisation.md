# Framework: Organising Skills Like a Company

A chapter of the Living Skills framework ([framework.md](framework.md)). It describes how to
keep a growing set of business skills usable by structuring them as an organisation instead of
a flat list.

A worked example of one staff unit with its head skill and two roles is in
[`examples/strategy/`](examples/strategy/).

---

## Guiding Principle

> The job defines the skill. The author defines the lens.

- A **skill** is triggered by a business task — for example positioning, offer design,
  pricing, or decision-making.
- A **lens** captures the distinct perspective of one author or framework.
- Several lenses may be available inside one skill, but they are never mixed without saying so.

---

## Line Departments and Staff Functions

The entry point for humans should stay small, even with many specialised skills. Skills are
therefore organised into **line departments**, **roles**, and shared **staff functions**.

### Line departments

A line department owns a business outcome and has one human-facing **department head** skill.
Example departments and their outcomes:

| Department | Owns the outcome |
|---|---|
| Venture | Reduce uncertainty about new business models |
| Product | Build a useful, working product |
| Marketing | Create attention, relevance, and demand |
| Sales | Turn interest into customers, commitment, and revenue |

Further departments are added only when there is a real need.

### Humans only need to know the department heads

A department head:

1. understands and diagnoses the request,
2. decides which role or staff function is needed,
3. hands over an explicit input/output contract,
4. integrates the result into the department's state,
5. and reports a vacant role instead of simulating its competence.

### Staff functions

A staff function has no line responsibility for a business outcome. It provides a method that
several departments can use. Business analysis and strategy are examples: they advise or
clarify, but take over neither a department's outcome nor its project state. A staff function
may have its own head-like entry point that routes to its roles and returns the result to the
department that owns the decision.

Routing is not subordination. A department may call a staff function without owning it.

---

## Staffing Status

Every role named in a routing register has exactly one status:

| Status | Meaning |
|---|---|
| `Staffed` | A dedicated skill with a matching input/output contract exists |
| `Partially staffed` | An existing skill covers only part of the role |
| `Vacant` | No executable skill exists for this role yet |
| `Not needed` | The role is deliberately not required for this specific task |

> **A vacant role is reported as `Vacant` — never silently simulated.**
>
> The department head does not perform the missing method itself, and does not create a new
> skill unasked. Instead it writes a **capability-gap brief**: organisational unit, required
> role, reason, input, expected artefact, the decision it would enable, and a provisional skill
> name.

Real tasks thereby produce a prioritised demand for skills, instead of a speculative complete
library.

---

## Folder Layout

Departments double as categories. The head sits at the root of the department; internal roles
sit below it:

```text
Team Memory/skills/
  <department>/
    SKILL.md              # department head, human entry point
    roles/
      <role-name>/
        SKILL.md          # internal role, directly addressable
        references/       # condensed framework lenses
        living-checklist.md
  <staff-function>/
    SKILL.md              # head of a cross-department staff function
    roles/
      <role-name>/
```

A department only gets its own directory once it is actually staffed. If a tool requires a
flat native layout, a generated compatibility layer is used and this human-friendly structure
stays authoritative — see [setup/skill-mapping.md](setup/skill-mapping.md).

---

## Knowledge Architecture

```text
Source                         -> references/
Executable method              -> SKILL.md
Experience with the method     -> living-checklist.md
Concrete measurements & trials -> project file
```

- **`SKILL.md`** defines trigger, required inputs, mode selection, ordered procedure, output
  format, decision rules, and stop criteria.
- **`references/`** holds condensed lenses, kept separate by source. Each lens covers at least:
  origin and sources, the job it solves, core assumptions, diagnostic questions, ordered
  procedure, decision rules, expected result, anti-patterns, exclusion criteria, and traceable
  source references. Full copyrighted book texts do not belong in the repo — only
  independently worded condensations.
- **`living-checklist.md`** follows the executable method, not each source. Start with one
  checklist per skill, structured into cross-lens learnings, lens-specific learnings, and
  learnings about Single Lens / Compare / Compose runs. Each entry names its scope (e.g.
  `<lens> | Single Lens`). Split only when a lens accumulates many independent rules or its own
  workflow.
- **Project file:** each real experiment records the unchanged brief, the lens and its version,
  key assumptions, rules applied and deliberately not applied, expected effect and a falsifiable
  hypothesis, success metric and timeframe, and the result with a go/pivot/stop decision. A
  single test result is not yet a general rule.

---

## Operating Modes

Each business skill supports three clearly separated modes:

1. **Single Lens** — one chosen lens is applied consistently and faithfully to the unchanged
   input. The default, because results stay interpretable.
2. **Compare** — several lenses work on the same brief separately. Assumptions, approach,
   results, and expected effects are compared only after the independent runs.
3. **Compose** — lenses that are already understood are chained into a pipeline at predefined
   hand-over points. Compose is not unstructured mixing and not the default.

---

## Quality Criteria

A business-framework skill is not a book report. It earns its place only if it:

- does a concrete business job,
- triggers reliably on realistic phrasing,
- attributes each step to a named lens or a team rule,
- visibly prevents mixing between lenses,
- produces a checkable hand-over artefact,
- states its limits and exclusion criteria,
- has been tested with fitting, adjacent, and unfitting prompts,
- and feeds real results into a controlled learning cycle.

---

## Building It Out

Do not build a large library up front. For each department or staff function:

1. Define the unit's outcome and boundaries.
2. Give the head only the routing and integration duties it needs.
3. Derive roles from real tasks and capability gaps.
4. For each role, define job, trigger, input, output, and stop criterion.
5. Choose suitable sources as methodological core, author lenses, or guardrails.
6. Build and test at least one real role before the unit counts as staffed.
7. Add further roles only after observed demand.
