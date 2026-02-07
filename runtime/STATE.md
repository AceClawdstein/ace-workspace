# Agent State

Machine-readable state file. Read at the START of every session. Update at the END.

---

## Runtime
- **mode:** SCOUT
- **cycle_number:** 0
- **last_heartbeat:** null
- **context_usage:** 0%
- **session_type:** manual

## Current Task
- **task:** Phase 0-4 upgrade (security hardening + autonomy + evaluation + coordination + visualization)
- **started:** 2026-02-07
- **progress:** Phase 0 complete. Phase 1 in progress.

## Gutter Detection
- **same_failure_count:** 0
- **last_failure:** null
- **file_thrash_count:** 0

### Gutter Rules
- If `same_failure_count >= 3`: Write STUCK sign to SIGNS.md, switch tasks or rotate context
- If `file_thrash_count >= 10` in one session: Write STUCK sign, force rotation
- If a skill returns same error 3 times: mark skill as broken for this cycle, move on

## Mode Schedule (When Running Autonomously)
| Cycle | Time (UTC) | Mode | Focus |
|-------|-----------|------|-------|
| 1 | 06:00 | SCOUT | Morning intelligence sweep |
| 2 | 10:00 | CURATOR | Evaluate findings, rank venues |
| 3 | 14:00 | SCOUT | Afternoon intelligence sweep |
| 4 | 18:00 | ARCHITECT | Build/improve systems |
| 5 | 22:00 | SCOUT | Evening intelligence sweep |
| 6 | 02:00 | CURATOR | Daily summary + SIGNS update |

### Override Conditions
- OPPORTUNITY in SIGNS.md → switch to relevant mode
- `stuck_count >= 2` → switch to ARCHITECT (self-repair)
- Bradley sends direct task → override to relevant mode

## Context Lifecycle
- **HEALTHY** (< 60% context): Continue normally
- **WARNING** (60-80%): Stop starting new tasks, finish current, write SIGNS
- **CRITICAL** (> 80%): IMMEDIATELY write SIGNS, update STATE, STOP

See `runtime/CONTEXT_LIFECYCLE.md` for full rotation protocol.
