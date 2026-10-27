# Living Checklist — Skill Creator

*Template example. The seed rules below are generalised from long use of this skill; add your own entries below them.*

**Purpose:** Experience layer for building and activating Living Skills. Permanent experience layer — not a staging area for SKILL.md.
**Karpathy principle:** Every session makes the next one better.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded — NOT because it hasn't triggered recently (that may mean it's working)
**SKILL.md boundary:** Application experience stays here permanently. SKILL.md contains the authoritative skill-creation procedure — only update it when the procedure itself changes.

---

## Entry Format

```
### [DATE] — [Context/Skill built]
**Pattern found:** [What went wrong or was missed]
**Why it happened:** [Structural reason]
**Rule:** [Concrete check for future sessions]
**Evidence:** [commit, issue or PR where it happened]
```

---

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Give people a few entry points, not a flat list of every skill · *seed rule*
**Rule:** Once a library holds many related skills, expose a small set of entry skills (for example one per department or domain) and place specialist skills beneath them. Methods used across several areas stay separate shared functions rather than being copied into each area.
**Why it matters:** A flat registry is clear to a machine but unusable for a person once every specialist appears as an equal entry point; the person has to know names they should never need to know.

### Keep human navigation and technical discovery as separate layers · *seed rule*
**Rule:** When you regroup skills for human navigation, keep the exact technical path of every skill in the registry so tools still find it. Change the grouping a person sees, not the paths a tool resolves.
**Why it matters:** Discovery, ownership and navigation look like one hierarchy but serve different readers. Merging them either breaks tool discovery or keeps the human view cluttered.

### Ship an orchestrator together with at least one real child route · *seed rule*
**Rule:** When building a skill that routes to other skills, create at least one working child skill in the same change, with a defined input and output contract between them.
**Why it matters:** Orchestrators are easiest to design top-down, but their value depends on the leaves. Without a real child the result is a convincing process diagram with no executable first step.

### Give every route an explicit availability status · *seed rule*
**Rule:** Each entry in a routing registry states whether it is staffed, partially staffed, vacant or not needed. For a vacant route, report a capability gap to the user; never simulate the missing skill and never create it unasked.
**Why it matters:** A route without status invites the model to improvise the missing expertise, which produces confident output that no skill actually backs.

### A validator that crashes has not validated · *seed rule*
**Rule:** Treat a missing dependency or import error in a skill validator as an environment failure, not as a result. Fix the environment in a temporary, scoped way (for example a temporary install target on the module path) and require the validator's actual pass message before handing the skill over.
**Why it matters:** A crashed run and a failed validation look alike in a quick glance, and both tempt the author to report "checked" without any check having happened.

---

## Entries

*Add your own entries here, newest first.*

---

## Archive

*Entries moved here when context fundamentally changed or superseded by a more precise entry.*
