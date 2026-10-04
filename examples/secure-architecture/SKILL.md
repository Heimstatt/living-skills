---
name: "Secure Architecture"
description: "Procedure for auditing authorization models during system design. Trigger: designing authentication/authorization, reviewing 'who can do what', any requirement containing 'only X should be allowed to Y', 'separation of duties', '2FA for sensitive actions', or when someone suggests routing a permission through a data field (email, name, flag)."
type: "behavioral"
living-checklist: "yes"
---

# Secure Architecture — Authorization Design Checklist

*Example skill, published as a template. Adapt the procedure to your own team and practice.*

**Applies to:** Any system where authorization decisions matter — access control, multi-party approval flows, sensitive data operations, third-party trust models.

**Core insight:** Authorization has two independent layers. Both must hold:
- **AuthN** (Authentication): Is this really the right person? → OTP, 2FA, passwords
- **AuthZ** (Authorization): Does this person have the right to act? → Roles, grants, data model

OTP authenticates the moment. It cannot repair a broken authorization model.

---

## When to Activate

Activate this skill when:
- Designing a login/auth system or access control model
- Adding a sensitive action (delete, approve, release, transfer) to an existing system
- Reviewing a PR or ADR that touches who-can-do-what
- Someone says "just use 2FA/OTP for that" as a security answer
- Someone proposes routing a permission via a data field (email address, contact name, flag)
- The words "separation of duties" or "four-eyes principle" appear

---

## Session-Start Ritual

1. Read this `SKILL.md`
2. Read `living-checklist.md` — load accumulated patterns
3. Output the Skill Activation Protocol:

```
SKILL ACTIVATED: secure-architecture
Date: YYYY-MM-DD
Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
Active rule: "[verbatim quote of the most recent relevant rule]"
```

---

## The Seven Layers — Questions to Ask

Work through each layer in order. Flag any "No" or "Unclear" as a finding.

---

### Layer 1 — AuthN vs AuthZ Separation

- Is there a **clear conceptual separation** between "who is this person" (AuthN) and "what is this person permitted to do" (AuthZ)?
- Does any 2FA/OTP/MFA mechanism **substitute for** a missing authorization check? OTP answers "is this really you?" — it does not answer "are you allowed?"
- If an attacker controls an account legitimately but manipulated their authorization path, does OTP block the attack? → **No. Flag it.**

**Decision test:** "If the person passes OTP but obtained account access through data manipulation (e.g. changed contact_email to their own), does the authorization still hold?"

---

### Layer 2 — Authorization over Stable IDs

- What is the **anchor** for the authorization decision? A stable ID in a junction table? Or a mutable field (email, name, flag)?
- Can a **legitimate data maintenance operation** (changing a contact email, updating an address) **silently shift authorization**?
- Is there a **Grant/Revoke mechanism** with an explicit audit trail — or does access exist by virtue of a field match?

**Rule:** Authorization belongs to **stable IDs in an explicit relation** (junction table with `granted_at`, `granted_by`), not to changeable master-data fields.

**Decision test:** "Could a day-to-day 'update contact person' operation silently transfer approval rights to a different party?"

---

### Layer 3 — Separation of Duties in the Data Model

- Who controls the master data (creates/edits parties, assignments, contracts)?
- Who approves sensitive actions (release, transfer, deletion of protected records)?
- **Can the same actor control both sides?** If yes: SoD is violated — "approval" is meaningless.
- Is SoD enforced **in the data model** (schema + server-side checks), or only in the UI (bypassable via direct API call)?

**Decision test:** "If I call the server action directly via curl, bypassing the UI entirely, does SoD still hold?"

---

### Layer 4 — Protection of Authorization Itself

> "Who is allowed to decide about an action must not be changed more easily than the action itself."

- Is modifying authorization records (e.g. grant/revoke a junction-table entry) protected by the **same gate** as the action it protects?
- If authorization changes bypass this gate → flag as a structural gap, even if implementing the gate is deferred.
- Explicitly document the deferral and the residual risk.

---

### Layer 5 — Architectural Coherence

- Are multiple decisions in the ADR log pointing at the **same missing building block**?
- Before designing a new auth mechanism, ask: **Does a related mechanism already partially exist?** Extend it, don't fork it.
- If three decisions share a root cause → name the common building block and solve it once.

**Pattern to watch for:** Three independent ADRs ("who manages records", "who can hold a dual role", "who can approve releases") all turning out to need the same missing User↔Party junction layer. When a pattern like this surfaces, stop and design the missing layer first — fixing three symptoms separately produces three half-measures.

---

### Layer 6 — Demo Facade vs Production Foundation

- For each design choice: is this a **demo shortcut** (correct behavior, wrong foundation) or a **production-grade decision**?
- Document the distinction explicitly: "Variant 1 = facade: routes via contact_email, acceptable for demo; Variant 2 = foundation: explicit junction table with Grant/Revoke."
- Never present a facade as a foundation. Nobody should read old decisions and assume a shortcut is load-bearing.

---

### Layer 7 — External Dependency Isolation

- Is each external dependency (mail gateway, OTP provider, SFTP, audit writer) behind a **narrow interface**?
- Does a demo implementation and a production implementation exist (or are explicitly planned)?
- Can the prod adapter be swapped in without changing application logic? → **Interface + Adapter pattern**

---

## Output Format

After working through the layers, produce:

```
SECURE ARCHITECTURE REVIEW

System/Decision: [what was reviewed]
Date: YYYY-MM-DD

FINDINGS:
Layer 1 (AuthN/AuthZ separation): [OK / Finding: ...]
Layer 2 (Stable IDs):             [OK / Finding: ...]
Layer 3 (SoD in model):           [OK / Finding: ...]
Layer 4 (Permission protection):  [OK / Finding: ...]
Layer 5 (Coherence):              [OK / Finding: ...]
Layer 6 (Demo/Prod clarity):      [OK / Finding: ...]
Layer 7 (Interface isolation):    [OK / Finding: ...]

OPEN ITEMS: [numbered list of findings that need decisions]
DEFERRED (documented): [items flagged but explicitly deferred with reason + residual risk]
```

---

## Stop Criterion

Review is complete when:
- All 7 layers answered with OK or explicit finding
- Each finding has a resolution: fixed, deferred with documented reason, or accepted risk
- No "unclear" remains unresolved

---

## Session-End Ritual

After use: write new patterns found into `living-checklist.md`.
Format: Date, context/system type, pattern found, why it happened, concrete check for next session.
Update `revisionslog.md` only if `SKILL.md` itself was changed.
