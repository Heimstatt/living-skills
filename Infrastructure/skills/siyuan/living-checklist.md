# Living Checklist — Siyuan Knowledge Base

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Setup patterns, API quirks, and sync learnings for this skill. Extended after every session.

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

### YYYY-MM-DD — Renamed heading created a duplicate document · *illustrative*
**Learning:** After the first `# H1` heading of a file was changed, the sync created a new document instead of updating the existing one, because the document path is derived from that heading.
**Why it matters:** Heading edits look cosmetic in Git but change the document's identity in the knowledge base.
**Rule:** After renaming an H1, check the knowledge base for the old document and remove or merge it deliberately.
**Observed by:** <instance> (YYYY-MM-DD)

---

### YYYY-MM-DD — Timestamps compared across timezones · *illustrative*
**Learning:** The edit check compared the knowledge base's offset-less local timestamps with Git commit times from another timezone and reported freshly synced documents as human edits.
**Why it matters:** A timestamp without an offset carries no timezone; two correct clocks can still produce a wrong comparison.
**Rule:** Normalize both timestamp sources into one explicit timezone before comparing, and test the check right after a sync — it should report nothing.
**Observed by:** <instance> (YYYY-MM-DD)

---

*Further entries follow after each session.*
