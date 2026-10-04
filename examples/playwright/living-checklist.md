# Living Checklist — Playwright

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Experience layer for Playwright-based browser inspection and UI validation. Permanent experience layer — not a staging area for Skill.md.
**Karpathy principle:** Every session makes the next one better.
**Shareable:** Entries must contain only generalizable patterns. No project names, no internal URLs, no case-specific data.

---

## Management

**Entry threshold:** Only add if "would go wrong again without this reminder"
**Archive rule:** Remove only when context fundamentally changed or entry superseded
**Skill.md boundary:** Operational experience stays here. Skill.md contains the stable workflow.

---

## Entry Format

```
### [DATE] — [Task type]
**Pattern found:** [What went wrong or was surprising]
**Why overlooked:** [Structural reason]
**Check:** [Concrete question for future sessions]
```

---

## Entries

### YYYY-MM-DD — Clicking an element from an old snapshot · *illustrative*
**Pattern found:** After a client-side route change, an interaction used an element ref from the previous snapshot and hit the wrong control (or timed out), although the page looked unchanged.
**Why overlooked:** Single-page apps re-render without a visible navigation, so the old refs feel current.
**Check:** Did anything change the DOM since the last `snapshot`? If unsure, take a new snapshot before the next interaction.

---

### YYYY-MM-DD — Screenshot taken before the page settled · *illustrative*
**Pattern found:** A visual comparison flagged differences that were only loading states — web fonts, lazy images and transitions had not finished when the screenshot was taken.
**Why overlooked:** The page reports "loaded" before late assets and animations complete.
**Check:** Before a comparison screenshot, wait for a concrete signal (a final element, network idle, fonts ready) and capture the reference under the same conditions.

---

## Archive
