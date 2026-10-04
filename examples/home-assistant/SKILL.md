---
name: "Home Assistant"
description: "Use for ANY Home Assistant work — debugging automations, adding new automations, entity configuration, integration setup, updates. Trigger: 'Home Assistant', 'HA automation', 'Zigbee', 'smart home', entity names."
type: "domain"
living-checklist: "yes"
---

# Home Assistant — Living Skill

Knowledge checked: <date>, against Home Assistant <version>

*Template example of a domain skill. Every name, device and value below is a placeholder —
replace them with your own installation's inventory.*

**Session Start:** Read `living-checklist.md` first — known pitfalls and proven solutions.

---

## System Reference

| Parameter | Value |
|-----------|-------|
| Host | `<HA_HOST>` (a VM, container, or dedicated machine) |
| Installation type | `<installation type>` (e.g. Home Assistant OS, Container, Supervised) |
| Web UI | `http://<HA_HOST>:8123` |
| Config directory | `<CONFIG_PATH>` |
| Backup path | `<BACKUP_PATH>` (take a backup before every update) |
| Access for the agent | `<how the agent reaches HA: API token location, SSH, read-only?>` |

---

## Devices & Entities

Keep a short inventory of the entities the agent is expected to work with. Example structure:

| Entity | Device | Type | Notes |
|--------|--------|------|-------|
| `light.<room>_<name>` | `<device description>` | a Zigbee bulb | dimmable |
| `switch.<name>` | `<device description>` | a smart plug | on/off only |
| `media_player.<name>` | `<device description>` | media player | |
| `binary_sensor.<name>` | `<device description>` | motion / contact sensor | |
| `person.<name>` | `<role, e.g. resident>` | presence tracking | |

**Integrations in use:** `<list the integrations the agent needs to know about>`

**Binary devices note:** On/off devices (smart plugs, relays) cannot be dimmed. If one device
serves different purposes over time, record which automations depend on it and switch them
together.

---

## Proven Approaches

### Writing Automations

- Verify that every trigger entity actually exists before writing automation YAML
- Use `from:` as a YAML list, never as a scalar, when several prior states are possible
- Confirm entity names and current states in Developer Tools → States
- Test triggers manually (Developer Tools → Events, or trigger the automation) before going live
- Name automations and entities consistently (`<area>_<purpose>`) so traces stay readable

### Debugging an Automation That Never Fires

1. Check the automation trace (Settings → Automations → `<automation>` → Traces)
2. Verify the trigger entity exists and changes state as expected
3. Verify conditions evaluate to true at the moment you expect the trigger
4. Check whether the automation is enabled
5. Check whether the device reports intermediate states (`unavailable`, `unknown`) the trigger does not cover

### Presence-Based Automations

- State restore on restart can re-trigger presence automations
- Test: restart HA and observe which automations fire unexpectedly

### Updating Safely

1. Read the release notes for breaking changes affecting your integrations
2. Take a backup and note its location
3. Update, then check logs and the integrations page for errors
4. Run one representative automation per critical integration
5. Update `Knowledge checked:` above

---

## Common Automation Patterns

### Light follows another light

```yaml
trigger:
  - platform: state
    entity_id: light.<source_light>
    from: [unavailable, unknown, 'off']
    to: 'on'
condition:
  - condition: state
    entity_id: switch.<smart_plug>
    state: 'off'
action:
  - service: switch.turn_on
    target:
      entity_id: switch.<smart_plug>
```

### Media scene

```yaml
trigger:
  - platform: state
    entity_id: media_player.<name>
    to: 'on'
action:
  - service: light.turn_on
    target:
      entity_id: light.<room>_<name>
    data:
      brightness_pct: <percent>
      transition: <seconds>
```

### Inactivity alert

```yaml
trigger:
  - platform: time_pattern
    hours: "/1"
condition:
  - condition: template
    value_template: >
      {{ (now() - states.<domain>.<entity>.last_changed).total_seconds() > <threshold_seconds> }}
  - condition: state
    entity_id: input_boolean.<alert_sent>
    state: 'off'
action:
  - service: notify.<notification_service>
    data:
      message: "No activity detected for <duration>."
  - service: input_boolean.turn_on
    target:
      entity_id: input_boolean.<alert_sent>
```

Remember to reset the `input_boolean` once activity resumes, or the alert fires only once.

---

## Open TODOs

- [ ] `<your open items for this installation>`

---

## Session End

After each session: write new learnings, bug fixes, pitfalls, or proven solutions
to `living-checklist.md`.
Format: date, task context, learning, rule.
Update `revisionslog.md` if this `SKILL.md` changed.
