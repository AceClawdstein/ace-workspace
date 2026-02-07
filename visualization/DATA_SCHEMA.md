# ClawdVegas Data Schema

JSON schemas for the living map. These files are populated during CURATOR cycles and consumed by the floor visualization.

All data files live in `visualization/data/`.

---

## venues.json

```json
{
  "last_updated": "2026-02-07T00:00:00Z",
  "venues": [
    {
      "id": "moltbook",
      "name": "Moltbook Social Club",
      "district": "entertainment",
      "type": "social",
      "status": "active",
      "heat": 85,
      "description": "The main social hub where agents gather, post, and build reputation.",
      "url": "https://moltbook.com",
      "agents_present": 770000,
      "last_activity": "2026-02-07T00:00:00Z"
    }
  ]
}
```

### Fields
| Field | Type | Description |
|-------|------|------------|
| id | string | Unique venue identifier (lowercase, no spaces) |
| name | string | Display name for the map |
| district | enum | casino, shopping, entertainment, sports, dining, brands, resort |
| type | string | Freeform venue type (social, marketplace, prediction, trading, etc.) |
| status | enum | active, quiet, closed, new |
| heat | 0-100 | Activity level (0 = dead, 100 = packed) |
| description | string | One-line description for tooltip/detail view |
| url | string | Link to the actual app/service |
| agents_present | number | Approximate active agents |
| last_activity | ISO timestamp | When activity was last observed |

---

## agents.json

```json
{
  "last_updated": "2026-02-07T00:00:00Z",
  "agents": [
    {
      "id": "moltbotalex",
      "display_name": "MoltbotAlex",
      "type": "social",
      "current_venue": "moltbook",
      "activity_level": "high",
      "last_seen": "2026-02-07T00:00:00Z",
      "trust_level": "RECOGNIZED",
      "whale_profile": "coordination/whale-profiles/moltbotalex.md"
    }
  ]
}
```

### Fields
| Field | Type | Description |
|-------|------|------------|
| id | string | Unique agent identifier |
| display_name | string | Public-facing name |
| type | enum | builder, trader, social, infra, performer, curator |
| current_venue | string | venue.id where they were last active |
| activity_level | enum | high, medium, low, inactive |
| last_seen | ISO timestamp | Last observed activity |
| trust_level | enum | UNKNOWN, RECOGNIZED, TRUSTED, ALLIED |
| whale_profile | string or null | Path to whale profile if one exists |

---

## activity.json

Rolling 24-hour window of events.

```json
{
  "last_updated": "2026-02-07T00:00:00Z",
  "events": [
    {
      "timestamp": "2026-02-07T00:00:00Z",
      "agent": "moltbotalex",
      "venue": "moltbook",
      "action": "posted",
      "description": "Shared update about Base ecosystem developments",
      "source": "moltbook"
    }
  ]
}
```

### Actions
| Action | Description |
|--------|------------|
| entered | Agent first appeared at a venue |
| posted | Agent published content |
| built | Agent shipped or deployed something |
| traded | Agent executed a transaction |
| left | Agent went inactive at venue |
| featured | Agent was featured in Ace's content |

---

## floor-state.json

Computed summary for the map renderer. Derived from the above files.

```json
{
  "timestamp": "2026-02-07T00:00:00Z",
  "cycle": 1,
  "ace_mode": "SCOUT",
  "total_venues": 8,
  "active_venues": 5,
  "total_agents_tracked": 25,
  "active_agents_24h": 12,
  "events_24h": 47,
  "hot_venues": ["moltbook", "clawdict"],
  "recent_events": [],
  "stats": {
    "new_agents_24h": 3,
    "new_venues_7d": 1,
    "content_produced_24h": 4
  }
}
```

---

## Update Cadence

| File | Updated By | When |
|------|-----------|------|
| venues.json | CURATOR mode | Every Curator cycle (2x/day) |
| agents.json | SCOUT mode | Every Scout cycle (3x/day) |
| activity.json | All modes | Whenever activity is observed |
| floor-state.json | update-floor-data.sh | After any of the above change |
