---
name: "Playwright"
description: "Operational skill for browser automation and visual UI inspection with playwright-cli. Trigger: 'playwright', 'inspect live', 'automate browser', 'validate screenshot', 'visually check page'."
type: "domain"
living-checklist: "yes"
---

# Playwright — Operational Skill

**Knowledge checked:** <date>, against playwright-cli <version>

**Applies to:** All instances with local `npx` and browser access
**Trigger:** "playwright" / "inspect live" / "automate browser" / "validate screenshot" / "visually check page"

---

## Activation Protocol (mandatory)

Output before the first step:

```
SKILL ACTIVATED: playwright
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule/insight]"
Approach: [2–3 sentences on what this session will do]
```

---

## Prerequisites

Check before use:

```bash
command -v npx >/dev/null 2>&1
```

If `npx` is missing, do not attempt browser automation. Ask the user for Node/npm.

Wrapper:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PWCLI="$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh"
```

---

## Standard Workflow

1. Open target page
2. Take `snapshot`
3. Interact using fresh element refs
4. After navigation or DOM changes: take another `snapshot`
5. Save screenshots to `output/playwright/` when visual comparison is relevant

Minimal:

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" screenshot
```

---

## Guardrails

- Never reuse stale element refs; re-snapshot after significant UI changes
- For visual reconstruction: capture reference screenshot first, then preview, then compare directly
- On network or certificate problems: document the symptom, do not click blindly past it
- Do not switch to test specs when only visual inspection or manual browser automation is needed

---

## After-Action (mandatory after each session)

Write new insights into `living-checklist.md` — only if without this reminder the same browser trap would cost time again.

Format:

```
### YYYY-MM-DD — [Task type]
**Pattern found:** [What went wrong or was surprising]
**Why overlooked:** [Structural reason]
**Check:** [Concrete question for future sessions]
```
