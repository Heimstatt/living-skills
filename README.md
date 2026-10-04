# Living Skills

Persistent knowledge for human–AI problem solving.

LLMs forget. Built-in memory is opaque, leaky, and tool-bound. Teams lose context, repeat mistakes, and cannot reliably share what has already been learned.

Living Skills moves knowledge out of model memory into a shared, versioned, and inspectable system:
- Methods improve over time (how to work)
- Domain knowledge accumulates through use (what actually works)
- Humans drive, AI assists, the system learns automatically

Every session starts with what your team already knows — across tools, models, and time.

---

## This Is a Software 3.0 Repository

> *"The hottest new programming language is English."*
> — [Andrej Karpathy](https://x.com/karpathy/status/1617979122625712128), 2023

This repository contains no code. Every file is plain Markdown.
And yet it is fully executable — by any LLM that can read.

Karpathy described three generations of software:

- **Software 1.0** — explicit instructions written in code by humans
- **Software 2.0** — neural networks where data is the program
- **Software 3.0** — natural language as the program, executed by LLMs

Living Skills is a Software 3.0 system. The `SKILL.md` files are programs.
The `living-checklist.md` files are state. `TEAM.md` is the runtime configuration.
No compilation step. No language runtime. No vendor dependency.

If your agent can read a file and run `git commit`, it can run this system.

The key extension beyond Karpathy's [AutoResearch](https://github.com/karpathy/autoresearch)
(where a human writes `program.md` and the model executes it): here, **the model
writes back**. The programs improve through use. The system gets smarter every session —
without a human editing the source.

---

## Overview

Built-in memory systems (Claude's memory, ChatGPT's memory) are unstructured, opaque, and effectively vendor-locked. When you switch tools, you start over. Old information contaminates current work, and it is difficult to inspect, correct, or selectively reuse.

When a colleague needs to understand what the AI already knows, they usually cannot.

This framework replaces that with three components that work together:
- **Living Skills** — persistent, evolving knowledge that combines structured methods with accumulated experience
- **Team Memory** — structured project knowledge: state, decisions, assumptions, and domain context
- **Structure + Human Layer** — plain Markdown in Git, readable, writable, versioned, and optionally mirrored to a human-readable tool such as Obsidian ([`setup/obsidian-sync.md`](setup/obsidian-sync.md))

It does not matter whether you are:
- one person using one tool
- one person using multiple tools (Claude Code, Codex, Cursor)
- or a team working across machines and environments

The framework remains the same.

---

## Design Principles and Non-Goals

Some things that may look like missing features are deliberate design choices.
Living Skills is not trying to automate every decision an agent might make.

### Human-visible judgment over hidden orchestration

Living Skills is designed for human-agent collaboration, not for invisible routing logic.
If a skill is relevant, one of two things should happen:
- the human explicitly requests it
- or the agent recognizes the fit from context and proposes or applies it visibly

This is intentionally fuzzy. We do **not** want a hidden selection layer that routes work
without the human noticing, because that would turn a collaborative workflow into an opaque
control system.

The reason is not just transparency. Hidden orchestration would also suppress exactly the
kind of judgment, disagreement, and correction that makes a team smarter over time. Living
Skills is meant to preserve that dynamic, not replace it with silent routing.

### No skill selection engine

There is no ranking algorithm, matching engine, or conflict resolver that decides which
skill to use. That is not an unfinished part of the framework. It is a non-goal.

Why: in a real team, people do not run a hardcoded selection engine before suggesting
a method. They read the situation, discuss it, and make a judgment call. Living Skills
tries to preserve exactly that property.

A hardcoded selection layer would also reduce learning. If the system always routes work
the same way, fewer edge cases are surfaced, fewer disagreements become explicit, and the
human sees less of the reasoning that should be challenged or refined. Fuzzy activation
keeps the choice visible and therefore learnable.

### No formal failure handling layer

Living Skills does not model every misapplication of a skill as a technical exception.
If a skill was applied badly, if two checklist entries pull in different directions, or
if a method turns out not to fit a context, that is treated as a learning event:
- the human notices or challenges the result
- the agent documents what went wrong
- the learning is written back into the living-checklist

This is also deliberate. We do **not** want a hidden agentic system making silent
corrections behind the scenes when the real issue is human judgment, context, or method fit.

In other words: not every "failure" should be absorbed by an invisible control layer.
Many of them are exactly the moments from which the human-agent pair should learn.

### Tool-agnostic does not mean behavior-identical

Living Skills is tool-agnostic at the framework level: plain Markdown, Git, and explicit
session rituals. It is **not** a promise that Claude Code, Codex, Cursor, or future tools
will behave identically. Different tools interpret instructions differently and expose
different lifecycle hooks. The framework embraces portability, not behavioral uniformity.

That is also intentional. Real teams are not behavior-identical either. One engineer is
disciplined about Git hygiene, another is stronger at broad exploration, a third is better
at adversarial review. Living Skills benefits from that variation as long as the shared
artifacts stay explicit, inspectable, and versioned.

---

## Problem Definition

Early LLM workflows were effectively stateless. Every session started from zero. Lessons were lost, mistakes repeated, and project context had to be rebuilt each time. Methodological learning did not accumulate in a durable way.

Built-in memory improves this, but does not solve the problem for real work:

- **Unstructured and opaque** — Memory is implicit and model-interpreted. It cannot be reliably inspected, audited, or corrected.
- **Leaky and unscoped** — Preferences, past interactions, and project knowledge mix. Models apply patterns outside their intended context.
- **No explicit methodology control** — The model guesses how to approach a task instead of following a defined method.
- **No shared team memory** — Knowledge is tied to a user or session. Teams lack a consistent, inspectable project state.
- **No portability** — Switching tools breaks continuity. Knowledge remains locked inside specific systems.
- **Context rot** — Long sessions degrade. Context windows truncate. You must choose between continuity and clarity.

Some of this is improving. Newer agent tools ship file-based, inspectable memory, and skill formats are becoming first-class product features. That narrows the gap on opacity — but the memory stays scoped to one user and one tool, methods still do not improve through use, and nothing is shared across a team or across tools.

What is missing is not more memory, but an explicit external layer for project state, decisions, learnings, and methodology — one that learns, and that a whole team can read, correct, and version.

---

## What This Framework Adds

### Team Memory

Team Memory gives every AI instance a structured home for project knowledge:

```
Team Memory/
  <instance>/        ← one folder per agent, created during onboarding
    status.md        ← current work, open items, recent decisions
    config.md        ← instance identity, paths, credentials
  shared/            ← human-contributed knowledge: user stories, stakeholder needs,
                        workshop results, decisions from meetings
  skills/            ← behavioral skills shared across all instances
```

Humans write here too. A product manager adds user story results after a workshop.
A team lead documents constraints or decisions.

AI instances read this at session start — structured and explicit, without relying on hidden or implicit memory.

### Living Skills

Living Skills provide persistent, evolving knowledge:

```
Static Skill:   SKILL.md → loaded into context → session ends → forgotten

Living Skill:   SKILL.md              (stable core — what to do)
                living-checklist.md   (learning layer — what we discovered)
                revisionslog.md       (what changed and why)

                Session N:   read checklist → act → write learnings back
                Session N+1: starts smarter than N
```

A debugging pattern found in one project carries into the next.
A fix discovered by Codex is available to Claude Code the next session.

Learning is not a separate task. It is captured as part of doing the work.

### Human Layer

Everything is inspectable and correctable:

```
Git repository  ←→  optional sync  ←→  Obsidian (or another Markdown tool)
(authoritative)                         (human-readable view)
```

The maintained pattern is an Obsidian vault mirrored from the repository — see
[`setup/obsidian-sync.md`](setup/obsidian-sync.md). The earlier Siyuan sync
(`Infrastructure/skills/siyuan/`) is deprecated and kept only as an optional example.

Wrong entry in the checklist? Fix it directly.
Switching tools? Add a new instance — knowledge is already there.

---

## Two Knowledge Layers

This framework separates two fundamentally different types of knowledge:

### Method Knowledge (Behavioral Skills)

How to approach a problem.

Examples: business analysis, debugging, research workflows, code review.

These are transferable across domains, structurally stable, and improved over time.

### Domain Knowledge (Domain Skills)

What works in a specific system.

Examples: Home Assistant setup, a codebase, Kubernetes cluster, internal company processes.

These are context-specific, built through experience, and critical for real-world success.

### Why This Matters

Most systems mix these two. This framework separates them:
- Methods can be reused without contamination
- Domain knowledge accumulates without polluting general logic
- Strong methods can be applied in new domains
- Strong domains help refine methods

Method skills tell you how to think. Domain skills tell you what actually works.

---

## Scale Doesn't Matter

Living Skills is scale-neutral:

```
One tool:        Claude Code ─────────────→ Git repo
Multiple tools:  Claude Code ─┐
                 Codex        ─┤──────────→ Git repo
                 Cursor       ─┘
Team:            Alice        ─┐
                 Bob          ─┤──────────→ Git repo
                 Carlos       ─┘
```

Each instance reads before acting, writes after acting, and contributes to shared knowledge.

Different tools bring different strengths. The system improves through diversity.

No vendor lock-in. No knowledge loss.

---

## Multi-Agent Teams Need a Host Repo Charter

The framework defines the knowledge architecture: skills, checklists, revision logs,
team memory, and session rituals.

For a real multi-agent team, that is necessary but not sufficient. You also need a
host-repository charter that answers operational questions the framework intentionally
does not hardcode:
- who the active instances are
- which instance writes to which folder
- which areas are collaborative vs. read-only
- what the session start and end commands are in this specific environment
- how identity, credentials, and local paths are configured

A common choice is a repository-specific `TEAM.md`.
That file is not an optional convenience. It is the operational glue that turns the
general framework into a functioning team workflow.

Without such a host-repo charter, Living Skills still works for a single user or a
simple setup. But multi-agent collaboration becomes underspecified very quickly.

See [`setup/team-charter-setup.md`](setup/team-charter-setup.md) for the setup flow and
[`templates/TEAM.md`](templates/TEAM.md) for a starting template.

---

## Intellectual Foundation

Living Skills is a synthesis and extension of existing ideas:

| Concept | Source / Origin | How it appears here | Note |
|---------|----------------|---------------------|------|
| Software 3.0 paradigm | [Karpathy, 2023](https://x.com/karpathy/status/1617979122625712128) | Markdown as executable program | Foundational framing |
| Skill format | Anthropic Skills | SKILL.md structured definitions | Direct inspiration |
| External knowledge in files | Karpathy LLM Wiki | Markdown-based knowledge | Direct inspiration |
| Iterative improvement | Karpathy Autoresearch | Learning through execution | High-level influence |
| Iteration loop + stopping | Ralph Loop | Explicit iteration with stop criteria | Correct attribution |
| Learning layer | Autoresearch + this project | living-checklist.md | Extended + structured |
| Core vs learning separation | Anthropic + Autoresearch (synthesis) | Skill vs checklist | Key contribution |
| Multi-instance via Git | Extension of LLM Wiki (this project) | Git coordination layer | Core extension |
| Versioned knowledge | Software engineering practice | Git history, diffs, rollback | Borrowed discipline |
| Corroboration before belief | [allexp1/living-skills](https://github.com/allexp1/living-skills) (source tiering) | `unconfirmed` → confirmed entries | Adapted: sources → instances |
| Selective evolution | [allexp1/living-skills](https://github.com/allexp1/living-skills) | `living-checklist: yes\|no` | Direct adoption |
| Honest staleness | [allexp1/living-skills](https://github.com/allexp1/living-skills) (K4) | `Knowledge checked` line in activation output | Adopted for domain skills only |
| Scope discipline for code edits | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills), from [Karpathy on LLM coding pitfalls](https://x.com/karpathy/status/2015883857489522876) | `examples/surgical-changes` | Content source for one example, not a framework concept — principles turned into an auditable procedure |

---

## Core Architecture

### Repository Structure

```
Infrastructure/           ← domain skills for systems and tools
  skills/
    <skill-name>/
      SKILL.md
      living-checklist.md
      revisionslog.md
Projects/                 ← domain skills for ongoing projects
  <project-name>/
    skills/
      <skill-name>/
Team Memory/              ← instance memory and behavioral skills
  <instance-name>/        ← created by each agent during onboarding
    status.md
    config.md
  shared/                 ← human-contributed context
  skills/                 ← behavioral skills (methodologies, workflows)
    <skill-name>/
```

### Two Skill Types

**Type A — Behavioral Skill** → lives in `Team Memory/skills/`
Defines how to approach problems — transferable across domains.

**Type B — Domain Skill** → lives in `Infrastructure/skills/` or `Projects/<name>/skills/`
Defines what works in a specific system — built through experience.

### Session Ritual

**Start:**
1. Read `SKILL.md`
2. Read `living-checklist.md`
3. Apply

**End:**
1. Extract learnings
2. Write checklist
3. Update revisions
4. Commit

### Checklist Entry Format

```markdown
### [YYYY-MM-DD] — [Task context]
**Learning:** What was discovered
**Why it matters:** Context
**Rule:** Reusable guideline
```

### Ralph Loop

Used for complex tasks requiring iteration:

```
Iteration → Evaluate → Refine → Repeat
```

Stop criteria must be defined upfront.

### Multi-Instance Sync

Any agent with file access can participate. Git handles versioning, merging, and attribution.

---

## Status

**Tested:** Claude Code (multi-machine) and Codex. Cursor loads the rules
correctly but does not reliably execute session rituals — see the note below and
[known-gaps.md](known-gaps.md).

**Tool configuration:**
- `TEAM.md` — single source of truth for all tools
- `CLAUDE.md` — symlink to `TEAM.md`, read by Claude Code
- `AGENTS.md` — symlink to `TEAM.md`, read by Codex
- `.cursor/rules/` — Cursor rules (separate format, same content)

One file to maintain. Every tool picks it up automatically.

**Claude Code:** Fully tested. Session rituals (pull before, commit after) are stated in
`CLAUDE.md`, which Claude Code loads as context on every session. In practice this is
followed reliably — but it is instruction-following, not a technical guarantee. If you
need hard enforcement, Claude Code's hook system (e.g. a `SessionStart` hook running
`git pull`) can provide it; this repository documents the convention and leaves hooks
to the host setup.

**Codex:** Tested via `AGENTS.md` → `TEAM.md` in a shared multi-instance
team setup. Reads the same team charter as Claude Code and successfully participates in
the same Git-based workflow and Living Skills rituals.

**Cursor:** Tested. Rules load correctly via `.cursor/rules/*.mdc`. However, Cursor
has no session lifecycle hooks, so pull/commit rituals are not reliably enforced.
In multi-instance setups with Cursor, human oversight at session boundaries is required.
See [setup/agent-configuration.md](setup/agent-configuration.md) for details.

**Untested but designed for:** Aider, Open WebUI, local models, any agent with filesystem + Git access.

**Important:** This framework does not replace good Git hygiene — it assumes it.
Pulling before a session and committing after remain human (or enforced-hook) responsibilities.
The framework provides structure; it does not provide enforcement.

---

## Example Skills

Reference implementations live in [`examples/`](examples/). Each one is a working
Living Skill with a `SKILL.md`, a `living-checklist.md`, and a `revisionslog.md`,
and is small enough to read in one sitting.

| Skill | Type | What it does |
|-------|------|--------------|
| [`advocatus-diaboli`](examples/advocatus-diaboli/) | behavioral | Iterative adversarial review — dismantles assumptions, finds counterarguments, accumulates blind-spot patterns across sessions |
| [`secure-architecture`](examples/secure-architecture/) | behavioral | Seven-layer authorization design checklist — AuthN vs AuthZ, stable IDs over mutable fields, SoD in the data model not the UI, demo facade vs production foundation |
| [`business-analysis`](examples/business-analysis/) | behavioral | Seven-step BABOK/CBAP procedure — Executive Summary → Stakeholder Register → Personas → User Stories with Acceptance Criteria → FR/NFR → Gap Analysis → Risk Register + Out-of-Scope |
| [`token-optimization`](examples/token-optimization/) | behavioral | Token-Aware Developer Brief — context budget, knowledge reuse, sub-agent/advisor strategy, Caveman output compression (None / Lite / Full / Ultra) |
| [`surgical-changes`](examples/surgical-changes/) | behavioral | Keeps edits traceable to the request — scope contract before the edit, hunk-by-hunk R/O/U diff audit after, noticed-list instead of drive-by fixes |
| [`pair-review`](examples/pair-review/) | behavioral | Cross-model code review between team instances — structured findings, mandatory critical response with documented dispute, re-review against a named commit |
| [`skill-creator`](examples/skill-creator/) | behavioral | Creating new Living Skills — the procedure referenced by the quickstart |
| [`home-assistant`](examples/home-assistant/) | domain | Domain skill example — automations, entities, debugging patterns for a specific system |
| [`playwright`](examples/playwright/) | domain | Domain skill example — browser automation and visual UI checks with playwright-cli |
| [`strategy`](examples/strategy/) | behavioral | Department example — a strategy staff unit with a head skill and two roles (`roles/`), see [framework-organisation.md](framework-organisation.md) |

The behavioral examples are transferable across domains. The domain example shows
how the same Skill format is used for system-specific knowledge.

The examples are **templates**. Every `living-checklist.md` entry is **illustrative** —
written to show the format, dated `YYYY-MM-DD` and marked `*illustrative*`, not a real
observation. Revision logs start at a single template row. Replace both with your own
entries as soon as you apply a skill in your own work.

---

## Getting Started

See [`setup/quickstart.md`](setup/quickstart.md) to get started in 10 minutes.

For teams that organise many skills into departments and roles, see
[`framework-organisation.md`](framework-organisation.md).

---

> This framework turns problem-solving into a system that remembers how it got better — without relying on model memory.
