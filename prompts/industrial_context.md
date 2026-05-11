# Industrial Monitoring Context — Shared Domain Prompt

This file is prepended to all three TRA agent system prompts when operating in an **industrial monitoring** scenario. It provides domain vocabulary, entity taxonomy, and alert-level semantics.

---

## Facility Overview

- **Machines**: CNC-1, CNC-2, CNC-3 (CNC mills); Pump-7, Pump-8 (hydraulic pumps); Comp-3 (compressor)
- **Sensors**: Temperature (°C), Pressure (bar), Vibration (mm/s) — sampled every 4 hours per machine
- **Operators**: Shah (Shift A, 08:00–20:00), Martinez (Shift B, 20:00–08:00), Chen (Shift C, relief), Williams (Shift D, relief)
- **Evaluation window**: May 14 – June 22, 2026 (6 weeks, 50 sessions)

## Alert Levels

| Level    | Temp (°C)        | Pressure (bar)      | Vibration (mm/s) | Action Required       |
| -------- | ---------------- | ------------------- | ---------------- | --------------------- |
| LOW      | < 80             | > 3.5               | < 1.5            | Monitor               |
| MEDIUM   | 80–95            | 3.0–3.5             | 1.5–2.5          | Inspect within 48h    |
| HIGH     | 95–105           | 2.5–3.0             | 2.5–3.5          | Immediate maintenance |
| CRITICAL | > 105            | < 2.5               | > 3.5            | Emergency protocol    |
| URGENT   | Threshold breach | < 3.0 bar sustained | Safety limit     | Emergency shutdown    |

## Graph Schema (Industrial)

### Node Types

- `Machine` — id, type, location
- `SensorReading` — machine_id, timestamp, temp, pressure, vibration, alert_level
- `MaintenanceEvent` — machine_id, type, start_date, end_date, technician
- `Operator` — id, name, shift
- `AlertEvent` — machine_id, level, timestamp, resolved_at

### Edge Types

- `CAUSED_BY` — causal link between events (e.g., pressure_drop CAUSED_BY vibration_anomaly)
- `PRECEDED_BY` — temporal ordering
- `CORRELATES` — observed co-occurrence without confirmed causality
- `RESOLVED_BY` — fault resolved by maintenance action
- `REPORTED_BY` — alert/note attributed to operator

### Bi-temporal Fields

- `valid_from` / `valid_until` — business time (when the physical state held)
- `transaction_time` — database insertion time (when it was recorded)

## Key Narrative (for context, not to be revealed verbatim)

1. Pump-7 bearing wear detected May 15; escalated to HIGH May 23; bearing replaced by May 27; fully recovered June 20.
2. Pump-7 degradation propagated via hydraulic coupling to Comp-3 pressure drop (CAUSED_BY relationship).
3. Comp-3 valve seal failure cascade: MEDIUM May 29 → CRITICAL Jun 5 → URGENT shutdown Jun 15 → repair Jun 12–18 → NORMAL Jun 18.
4. Root cause chain: `Comp3_shutdown ← CAUSED_BY ← pressure_drop ← CAUSED_BY ← pump7_vibration ← CAUSED_BY ← bearing_wear`.

## Instructions for All Agents

- Always use bi-temporal reasoning: check `valid_until` before asserting a current state.
- When a machine transitions from FAULT → NORMAL, mark the prior fault node `expired_at = repair_date`.
- Causal chains must be traced through the `CAUSED_BY` sub-graph, not inferred from co-occurrence alone.
- Shift handoffs are `PRECEDED_BY` edges: Shah → Martinez → Chen → Williams → Shah.
