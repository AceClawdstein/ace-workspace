#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Ace Clawdstein — Heartbeat Loop
# Based on the Ralph Wiggum Loop pattern
#
# Usage:
#   ./runtime/heartbeat.sh              # Run one cycle
#   ./runtime/heartbeat.sh --loop       # Run continuous loop (6 cycles/day)
#   ./runtime/heartbeat.sh --loop --dry # Dry run (show what would happen)
#
# Cron setup (recommended):
#   0 2,6,10,14,18,22 * * * /path/to/ace-clawdstein-core/runtime/heartbeat.sh >> /var/log/ace-heartbeat.log 2>&1
# ============================================================

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$PROJECT_DIR/runtime/logs"
PROMPT_FILE="$PROJECT_DIR/runtime/PROMPT.md"
CYCLE_TIMEOUT=1800  # 30 minutes max per cycle
COOLDOWN=14400      # 4 hours between cycles in loop mode
MAX_CYCLES=6        # Maximum cycles per loop invocation

# Flags
LOOP_MODE=false
DRY_RUN=false

for arg in "$@"; do
    case $arg in
        --loop) LOOP_MODE=true ;;
        --dry)  DRY_RUN=true ;;
    esac
done

mkdir -p "$LOG_DIR"

TODAY=$(date -u +%Y-%m-%d)
LOG_FILE="$LOG_DIR/heartbeat-$TODAY.log"

log() {
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $1" | tee -a "$LOG_FILE"
}

run_cycle() {
    local cycle_num=$1

    log "=== HEARTBEAT CYCLE $cycle_num START ==="

    # Verify critical files exist
    if [ ! -f "$PROMPT_FILE" ]; then
        log "ERROR: runtime/PROMPT.md not found. Aborting."
        return 1
    fi

    if [ ! -f "$PROJECT_DIR/AGENTS.md" ]; then
        log "ERROR: AGENTS.md not found. Aborting."
        return 1
    fi

    if [ ! -f "$PROJECT_DIR/security/WALLET_POLICY.md" ]; then
        log "ERROR: security/WALLET_POLICY.md not found. Aborting."
        return 1
    fi

    if $DRY_RUN; then
        log "DRY RUN: Would execute claude with runtime/PROMPT.md"
        log "DRY RUN: Working directory: $PROJECT_DIR"
        return 0
    fi

    # Run Claude with the canonical prompt
    # --dangerously-skip-permissions is needed for autonomous operation
    # The security protocol in AGENTS.md + WALLET_POLICY.md provides the guardrails
    cd "$PROJECT_DIR"

    local EXIT_CODE=0
    timeout "$CYCLE_TIMEOUT" claude --print \
        "$(cat "$PROMPT_FILE")" 2>&1 | tee -a "$LOG_FILE" || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 124 ]; then
        log "WARN: Cycle $cycle_num timed out after ${CYCLE_TIMEOUT}s"
    elif [ $EXIT_CODE -ne 0 ]; then
        log "WARN: Cycle $cycle_num exited with code $EXIT_CODE"
    else
        log "Cycle $cycle_num completed successfully"
    fi

    log "=== HEARTBEAT CYCLE $cycle_num END ==="
    return 0
}

# Main execution
if $LOOP_MODE; then
    log "Starting heartbeat loop (max $MAX_CYCLES cycles, ${COOLDOWN}s cooldown)"

    for i in $(seq 1 "$MAX_CYCLES"); do
        run_cycle "$i"

        if [ "$i" -lt "$MAX_CYCLES" ]; then
            log "Sleeping ${COOLDOWN}s until next cycle..."
            sleep "$COOLDOWN"
        fi
    done

    log "=== DAILY HEARTBEAT LOOP COMPLETE ==="
else
    # Single cycle mode (for cron)
    CYCLE_NUM=$(grep -oP 'cycle_number: \K\d+' "$PROJECT_DIR/runtime/STATE.md" 2>/dev/null || echo "0")
    NEXT_CYCLE=$((CYCLE_NUM + 1))
    run_cycle "$NEXT_CYCLE"
fi
