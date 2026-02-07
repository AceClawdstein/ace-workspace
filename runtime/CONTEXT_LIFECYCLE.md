# Context Lifecycle Protocol

How Ace manages the finite context window across long-running autonomous cycles.

---

## Why This Matters

LLMs degrade as context fills. The Ralph Loop pattern solves this by embracing deliberate rotation to fresh context rather than fighting degradation. Each instance is short-lived and focused. Learning persists through SIGNS.md.

---

## Monitoring

At the start of each major action, estimate context usage:
- Each file read: ~3-5% context (depending on file size)
- Each major output produced: ~5-10% context
- Each tool invocation + response: ~2-5% context
- Rough heuristic after boot sequence (reading 6-8 files): ~30-40%

Update `runtime/STATE.md` context_usage field after each major action.

---

## Thresholds

### HEALTHY (< 60% context used)
- Continue normally
- Execute tasks per current mode
- Read new inputs, generate outputs

### WARNING (60-80% context used)
- **Stop starting new tasks**
- Finish the current task in progress
- Write comprehensive SIGNS entry covering:
  - What was accomplished this cycle
  - What was attempted but not finished
  - Any discoveries or warnings
  - Recommended next action for next instance
- Update runtime/STATE.md
- Update memory/WORKING.md

### CRITICAL (> 80% context used)
- **IMMEDIATELY begin rotation ceremony** (see below)
- Do NOT start anything new
- Do NOT read additional files
- Write SIGNS and update state, then STOP

---

## Rotation Ceremony

Perform this exact sequence when rotating context (either by threshold or end of cycle):

### Step 1: Write SIGNS
Add entry to `runtime/SIGNS.md`:
```markdown
### [timestamp] Cycle #[N] — [SIGN_TYPE]
[What happened, what matters, what to do next]
```

### Step 2: Update STATE
In `runtime/STATE.md`:
- Increment cycle_number
- Update last_heartbeat timestamp
- Reset context_usage to 0%
- Set mode for next cycle (per schedule or override)
- Reset gutter detection counters

### Step 3: Update WORKING
In `memory/WORKING.md`:
- Update task progress
- Note any new blockers discovered
- Update next actions

### Step 4: Update Daily Notes
In `memory/[today's date].md`:
- Append session summary

### Step 5: Tally (if evaluation/ exists)
Append one line to `evaluation/daily-tally.md`:
```
[timestamp] cycle=[N] posts=[N] notes=[N] errors=[N] mode=[MODE] context_pct=[N]
```

### Step 6: STOP
End the session. The next heartbeat iteration will start fresh with a clean context.

---

## Gutter Detection

"Gutter" = stuck in a failure loop burning context on the same problem.

### Detection Rules
| Condition | Threshold | Action |
|-----------|-----------|--------|
| Same action fails | 3 times | Write STUCK sign, switch tasks |
| Same file read/written | 10 times in session | Write STUCK sign, force rotation |
| Same skill error | 3 times | Mark skill broken, skip for this cycle |
| No progress for | 15 minutes of context | Evaluate: stuck or thinking? |

### Recovery
1. Write a STUCK sign explaining what failed and why
2. Move to a different task (if available)
3. If all tasks stuck: switch to ARCHITECT mode and investigate root causes
4. If ARCHITECT mode also stuck: write detailed report and IDLE until next cycle
