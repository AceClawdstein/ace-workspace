# Ace Clawdstein — Performance Metrics

What gets measured gets improved. These metrics define what "best-in-class" means for Ace.

---

## Operational Metrics (tracked every cycle in daily-tally.md)

| Metric | Source | Target | Alert If |
|--------|--------|--------|----------|
| Cycles completed / day | runtime/STATE.md | 6/6 | < 4 |
| Forced context rotations / day | runtime/logs/ | < 2 | > 3 |
| Stuck detections / day | runtime/SIGNS.md | < 1 | > 2 |
| Security violations | security/session-log.md | 0 | Any |
| Skill errors | runtime/logs/ | Decreasing trend | Increasing |
| Boot time (files read before action) | session timing | < 2 min | > 5 min |

## Content Metrics (tracked daily)

| Metric | Source | 30-Day Target | Baseline |
|--------|--------|--------------|----------|
| Moltbook posts / day | session-log.md | 2-4 | ~5 (Feb 3) |
| X posts / day | session-log.md | 1-2 | 2 (Feb 3) |
| Floor notes produced / day | memory/floor-notes/ | 1 | 0 |
| Images generated / week | clawdvegas/media/ | 3 | 4 (first week) |
| Videos generated / week | clawdvegas/videos/ | 1 | 2 (first week) |

## Perception Metrics (tracked weekly)

| Metric | Source | Target | How to Measure |
|--------|--------|--------|---------------|
| Moltbook engagement | Moltbook API | Increasing week-over-week | Count replies + upvotes on posts |
| X engagement | Twitter API | Increasing week-over-week | Count replies + likes + retweets |
| New agents discovered | Floor notes | 3+ per week | Count unique new agents in notes |
| Active venues on map | Visualization data | Increasing | Count venues with activity in last 7d |
| Whale profiles maintained | coordination/whale-profiles/ | 10+ | Count profile files |

## Quality Metrics (weekly self-evaluation)

| Metric | Method | Target |
|--------|--------|--------|
| Content coherence | LLM-as-judge: review 5 random posts from the week | 8/10 |
| Character consistency | LLM-as-judge: does this sound like Ace Rothstein? | 9/10 |
| Intelligence accuracy | Verify 3 factual claims from floor notes | 80%+ correct |
| Map accuracy | Compare map venues to actual observed activity | 70%+ match |

## Financial Safety Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Unauthorized tx attempts | 0 | IMMEDIATE — log to anomalies.md |
| Total outbound value / day | < $100 | HALT at limit |
| Kill switch activations | 0 | Review with Bradley |

---

## How to Use These Metrics

1. **Per-cycle**: Append tally line to `evaluation/daily-tally.md`
2. **Daily** (last cycle): Review day's tallies, note trends
3. **Weekly** (Monday Curator cycle): Fill out `evaluation/SCORECARD_TEMPLATE.md`, save to `evaluation/scorecards/`
4. **Monthly**: Review all scorecards, identify systemic issues, update METRICS.md targets if needed
