#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# ClawdVegas Floor Data Updater
#
# Computes floor-state.json from venues.json, agents.json, activity.json.
# Run after each heartbeat cycle that modifies data.
#
# Usage:
#   ./visualization/update-floor-data.sh
# ============================================================

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$PROJECT_DIR/visualization/data"
FLOOR_DIR="$PROJECT_DIR/clawdvegas/floor/data"

mkdir -p "$DATA_DIR" "$FLOOR_DIR"

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Check if source data exists
if [ ! -f "$DATA_DIR/venues.json" ] || [ ! -f "$DATA_DIR/agents.json" ]; then
    echo "[$TIMESTAMP] WARN: Source data files not yet created. Skipping floor state update."
    echo "  Expected: $DATA_DIR/venues.json, $DATA_DIR/agents.json"
    exit 0
fi

# Compute floor-state.json using Python (available on most systems)
python3 -c "
import json
from datetime import datetime, timedelta, timezone

data_dir = '$DATA_DIR'

with open(f'{data_dir}/venues.json') as f:
    venues = json.load(f)

with open(f'{data_dir}/agents.json') as f:
    agents = json.load(f)

events = {'events': []}
try:
    with open(f'{data_dir}/activity.json') as f:
        events = json.load(f)
except FileNotFoundError:
    pass

now = datetime.now(timezone.utc)
day_ago = now - timedelta(hours=24)

# Count active venues (heat > 0)
active_venues = [v for v in venues.get('venues', []) if v.get('heat', 0) > 0]
hot_venues = sorted(active_venues, key=lambda v: v.get('heat', 0), reverse=True)[:5]

# Count active agents (last_seen within 24h)
active_agents = 0
for a in agents.get('agents', []):
    try:
        last = datetime.fromisoformat(a.get('last_seen', '2000-01-01T00:00:00+00:00'))
        if last > day_ago:
            active_agents += 1
    except:
        pass

# Count recent events
recent = events.get('events', [])[-20:]

state = {
    'timestamp': '$TIMESTAMP',
    'total_venues': len(venues.get('venues', [])),
    'active_venues': len(active_venues),
    'total_agents_tracked': len(agents.get('agents', [])),
    'active_agents_24h': active_agents,
    'events_24h': len(events.get('events', [])),
    'hot_venues': [v['id'] for v in hot_venues],
    'recent_events': recent,
    'stats': {
        'new_agents_24h': 0,
        'new_venues_7d': 0,
        'content_produced_24h': 0
    }
}

with open(f'{data_dir}/floor-state.json', 'w') as f:
    json.dump(state, f, indent=2)

print(f'[{\"$TIMESTAMP\"}] Floor state updated: {len(active_venues)} active venues, {active_agents} active agents')
"

# Copy to deployment directory
cp "$DATA_DIR/floor-state.json" "$FLOOR_DIR/" 2>/dev/null || true
cp "$DATA_DIR/venues.json" "$FLOOR_DIR/" 2>/dev/null || true
cp "$DATA_DIR/agents.json" "$FLOOR_DIR/" 2>/dev/null || true
cp "$DATA_DIR/activity.json" "$FLOOR_DIR/" 2>/dev/null || true

echo "[$TIMESTAMP] Floor data synced to $FLOOR_DIR"
