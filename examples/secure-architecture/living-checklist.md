# Living Checklist — Secure Architecture

*Template example. The entries below are illustrative — written to show the format, not real observations. Replace them with your own.*

**Purpose:** Application experience layer — patterns collected while reviewing authorization models. Grows with every session. Never merged back into SKILL.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / system context] · *unconfirmed (1 observation)*
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check for future sessions
**Observed by:** <instance> (YYYY-MM-DD)
```

When a second instance hits the same pattern, it removes the marker and appends itself
instead of opening a new entry:
`**Observed by:** instance-a (YYYY-MM-DD), confirmed by instance-b (YYYY-MM-DD)`

---

## Entries

### YYYY-MM-DD — Permission derived from an editable profile field · *illustrative*
**Learning:** A design granted access to a record whenever the user's contact email matched a field on that record. Users could change their own email, so they could change their own permissions.
**Why it matters:** Identifying data looks like identity, so it slips into authorization checks without anyone asking who can edit it.
**Rule:** For every authorization check, name the field it relies on and who can write that field. If the subject can modify it, it is not a security boundary.
**Observed by:** <instance> (YYYY-MM-DD)

---

### YYYY-MM-DD — One-time code used in place of an authorization check · *illustrative*
**Learning:** A sensitive action required a one-time code, and the design treated that as sufficient protection. Nobody checked whether the person entering the code was allowed to perform the action at all.
**Why it matters:** A second factor feels like strong security, but it only confirms who is acting, not what they may do.
**Rule:** For every step protected by OTP/2FA, state the separate authorization rule that decides whether this person may act, and test it with an authenticated but unauthorized user.
**Observed by:** <instance> (YYYY-MM-DD)

---

*Further entries follow after each session.*
