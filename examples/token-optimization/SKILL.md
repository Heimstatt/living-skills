---
name: "Token-Aware Developer Brief"
description: "Structured planning before any non-trivial task: context budget, knowledge reuse, sub-agent strategy, output compression. Use proactively when a task will consume >10K tokens, involve sub-agents, or use multiple tools."
type: "behavioral"
living-checklist: "yes"
---

# Token-Aware Developer Brief — Living Skill

*Example skill, published as a template. Adapt the procedure to your own team and practice.*

**Trigger:** "token budget" / "context getting full" / "spawn sub-agent" / "advisor tool" / "token-aware brief" / "caveman" / "optimize tokens"

**Proactive rule:** Activate without being asked whenever a task is expected to consume >10K tokens, involve sub-agents, or use multiple tools. Exempt: short answers, single-turn Q&A.

---

## Session Start

1. Read `living-checklist.md` — load accumulated patterns from prior sessions
2. Output the Skill Activation Protocol:

```
SKILL ACTIVATED: token-optimization
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
Approach: [2–3 sentences on token strategy for this specific session]
```

3. Fill out the brief below before starting work

---

## The Brief

### Section 1 — Context Window Budget

- Task type: `routine` / `research` / `multi-source` / `coding` / other: ___
- Estimated consumption: `Low 10–15K` / `Med 15–35K` / `High 25–50K`
- Overflow plan if >80% context used:
  - [ ] Compress old context (which parts? how aggressively?)
  - [ ] Reference external resources instead of loading into context
  - [ ] Spawn sub-agent with isolated context
  - [ ] Abort and restart with compressed context

**Tool selection:**
- Load only the tools you need — not all available tools upfront
- Lazy-load: fetch tool schemas on demand when needed
- Large data (>100KB): filter locally before loading into context
- Sensitive data: process in tool sandbox only, never pass into context

---

### Section 2 — Knowledge Reuse

**Living Checklist:**
- [ ] Relevant checklist loaded? Path: ___________________________
  - Most recent rule (required quote — proves you read it): "___________________________"
  - Estimated tokens saved vs. cold research: ___K

**Knowledge Base / Documentation:**
- [ ] Searched existing docs / knowledge base before researching from scratch?
  - Where + search term: ___________________________

**Cross-instance sync:**
- [ ] `git pull` done — latest learnings from all instances loaded?
- [ ] Relevant team memory / shared folders read? Paths: ___________________________

**Remaining knowledge gaps (fresh research needed):**
- ___________________________

---

### Section 3 — Sub-Agent / Advisor Strategy

**Task type:** `single-turn Q&A` / `research` / `coding` / `agent loop`
*(Advisor pattern fits: research, coding, agent loops — not single-turn Q&A)*

**Sub-agents needed?**
- [ ] Explore agent (codebase search, file discovery)
- [ ] Plan agent (architecture decisions, implementation design)
- [ ] General-purpose agent (complex multi-step tasks)
- Parallelizable? Which agents to spawn simultaneously: ___________________________

**Executor + Advisor pattern:**
- Worth it at ≥3 iterations — below 3, single-model is usually cheaper
- Executor model: [cheaper/faster model]
- Advisor model: [more capable model]
- Expected advisor calls: ___
- Advisor output budget: <100 words per call (cost control)

---

### Section 4 — Output & Memory Compression

**Output mode for this session:**

| Mode | When | What it does |
|------|------|--------------|
| **None** | Interactive sessions, user-facing explanations | Normal output |
| **Lite** | Standard technical work | No filler/hedging, full sentences preserved |
| **Full** | Bulk coding, research loops | Articles/filler removed, fragments ok |
| **Ultra** | Pure automation, no user contact | Telegraphic, abbreviations, X→Y causality |

Selected mode: ___

**Caveman rules (active when mode ≠ None):**
- Strip: articles (a/an/the), filler (just/basically/really), pleasantries (sure!/certainly), hedging (perhaps/I think)
- Keep: code blocks, technical terms, URLs, error messages, numeric values, library names
- Pattern: `[thing] [action] [reason]. [next step].` — fragments are ok
- **Auto-clarity exceptions** (suspend mode temporarily): security warnings, irreversible actions, ambiguous multi-step sequences, user confusion

**Input/Memory compression (check before long sessions):**
- [ ] Context files too large? (CLAUDE.md, config, project notes — compress prose, keep code/URLs/tables)
- [ ] Living checklist too long? (>50 entries → archive old ones; compress prose into rules)

---

### Section 5 — Implementation Checklist

- [ ] Context budget estimated realistically
- [ ] Knowledge reuse documented (checklist path + rule quoted)
- [ ] Sub-agent decision made (Y/N + reasoning)
- [ ] Output mode chosen (None / Lite / Full / Ultra)
- [ ] Memory compression checked
- [ ] Overflow plan defined
- [ ] Ready to start

---

### Section 6 — Session-End Learning

*(Fill out after completion, then write to `living-checklist.md`)*

- **Context usage:** Estimated ___K / Actual ___K / Delta +/- ___K
- **Sub-agent calls:** Count ___ / Pattern ___ / Advisor break-even reached? Y/N
- **Knowledge reuse:** What saved tokens vs. cold research?
- **Output mode:** Did caveman affect quality? Optimal level for this task type?
- **Tool selection:** What could have been skipped?
- **Rule:** (1–2 sentence actionable guideline for next similar task)

---

## Reference: Benchmarks

*Illustrative orders of magnitude, not measurements — replace them with figures from your own sessions.*

| Task type | Baseline | + Knowledge reuse | + Sub-agents | + Caveman Lite |
|-----------|----------|-------------------|--------------|----------------|
| Routine | 10–15K | 8–12K | N/A | ~7–10K |
| Research | 15–35K | 12–25K | 8–12K | ~6–9K |
| Multi-source | 25–50K | 18–35K | 12–20K | ~10–18K |
| Multi-tool workflows | +10K/tool | −30%/tool | −80%/tool | — |

**Caveman benchmarks** (from [juliusbrussee/caveman](https://github.com/juliusbrussee/caveman)):
- Output compression: ~65–75% reduction per response
- Input compression (files): ~46% average (36–60% depending on content type)
- Note: session-total savings ~4–5% (output tokens are ~25% of session total)

**Advisor break-even:** ≥3 advisor calls — below 3, single-model is cheaper

---

## Session End

After every session: write new learnings to `living-checklist.md` — what was discovered, why it matters, one concrete rule for next time.
