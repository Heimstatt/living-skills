# Living Checklist — Home Assistant

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Experience layer for working on a Home Assistant installation. Extended after every use.

---

## Entry Format

```
### [YYYY-MM-DD] — [Task context] · *unconfirmed (1 observation)*
**Learning:** What was discovered / what failed
**Why it matters:** Context and consequences
**Rule:** Concrete actionable guideline for future sessions
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Entries

### YYYY-MM-DD — Trigger missed an intermediate state · *illustrative*
**Learning:** An automation triggered on `from: 'off'` to `'on'`, but the device briefly reported `unavailable` after a power cycle, so the trigger never matched.
**Why it matters:** Devices that reconnect pass through states the automation author did not expect.
**Rule:** Watch the real state sequence in the history or trace before writing a `from:` condition, and list every prior state that should count.
**Observed by:** <instance> (YYYY-MM-DD)

---

### YYYY-MM-DD — Automation fired on restart · *illustrative*
**Learning:** After a restart, restored states produced state-change events and a presence automation ran although nobody had arrived.
**Why it matters:** Restarts are rare during testing, so this behaviour shows up only in daily use.
**Rule:** Restart once after creating a state-triggered automation and check the traces; add a condition that ignores transitions from `unavailable`/`unknown` where needed.
**Observed by:** <instance> (YYYY-MM-DD)

---

*Further entries follow after each session.*
