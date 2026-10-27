# Living Checklist — Playwright

*Template example. The seed rules below are generalised from long use, not observations; the Entries section is yours to fill.*

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

## Seed rules

*Distilled from long use of this skill. Generalised rules, not observations; no incidents, names or systems. Add your own entries below in the Entry Format.*

### Hidden duplicates in multi-step wizards · *seed rule*
**Rule:** In single-page wizards, select with `:visible` or a role locator plus a visibility filter, never `.first()` on a name or label. Expect a wizard to auto-advance after a valid one-time code, without a button click.
**Why it matters:** Wizards often render one input or button per hidden step or alternative with the same name. Selectors written from a DOM dump see hidden elements just like visible ones, so fills and clicks hit an invisible element and time out.

### Finish secret-generating flows in one session · *seed rule*
**Rule:** Keep one browser process alive for the whole wizard; a reload regenerates secrets such as recovery codes or authenticator seeds. When the page offers a download for a secret, prefer it over parsing the rendered text.
**Why it matters:** Each step looks independent, but the secret shown in step two is only valid together with the state of that same session.

### Keep secrets out of the command line · *seed rule*
**Rule:** Pass passwords and one-time codes to the automation through environment variables, stdin or a file with tight permissions, never as command-line arguments.
**Why it matters:** Agent harnesses and shells log commands, often as a truncated prefix that still contains the first argument; the secret then sits in a log nobody thinks to scrub.

### One honest attempt at a consumer signup, no retries · *seed rule*
**Rule:** Before automating a consumer-account signup, try once with an honest identity (real address and name of the account owner). If it ends in a generic refusal, do not retry from the same machine; hand that step to the human on a real browser and connection. Do not generalise one site's result to others in either direction.
**Why it matters:** Consumer sites run stricter bot detection on headless browsers and server IP ranges than developer platforms, and often refuse only at the last step, after codes were already verified. Retries can flag the address for good.

### Gated information: read first, stop before the commitment · *seed rule*
**Rule:** When information (a price, a quota, a term) is only shown behind a purchase or checkout flow, first read banners, tooltips and the JSON responses the page loads. Stop before the checkout and report the value as open unless going further was explicitly agreed.
**Why it matters:** "Find the price" looks like a page-reading task, but the site may only reveal it inside a flow that commits money or a contract.

### Module resolution follows the script, not the working directory · *seed rule*
**Rule:** When a library-mode script lives outside the directory where Playwright is installed, run it with `NODE_PATH=<install-dir>/node_modules node script.js`, or install Playwright next to it.
**Why it matters:** Node resolves `require()` from the script's own location. A script that worked inside the install directory fails with `Cannot find module 'playwright'` once it is moved to a scratch directory.

### A raw render is not the design · *seed rule*
**Rule:** Before judging a design from a screenshot of its source file, compare it with the designer's own export, or state plainly what the render is missing (colours, ornaments, wrapper styles).
**Why it matters:** Design drafts often depend on a canvas or wrapper that supplies styles; rendered on their own they look different, and the screenshot then misrepresents the design it is meant to show.

---

## Entries

*Your own entries go here, in the Entry Format above.*

---

## Archive
