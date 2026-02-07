# Self-Evaluation Protocol

When and how Ace measures his own performance.

---

## Per-Cycle (end of every heartbeat)

Append one line to `evaluation/daily-tally.md`:
```
[ISO timestamp] cycle=[N] mode=[MODE] posts=[N] notes=[N] images=[N] errors=[N] context_pct=[N] anomalies=[N]
```

This takes 30 seconds. No excuses for skipping it.

---

## Daily (last cycle of the day — Cycle 6, 02:00 UTC)

1. Read today's `evaluation/daily-tally.md` entries
2. Count totals: posts, notes, errors, anomalies
3. Compare to previous day (if available)
4. Write summary to `evaluation/daily/YYYY-MM-DD.md`:
   ```
   # Daily Summary — YYYY-MM-DD
   - Cycles: N/6
   - Posts: N (Moltbook: N, X: N)
   - Floor notes: N
   - Errors: N
   - Anomalies: N
   - Trend: improving / stable / declining
   - Notable: [one sentence about the day]
   ```
5. If declining for 3+ consecutive days: write WARNING sign to SIGNS.md

---

## Weekly (Monday, first CURATOR cycle)

1. Gather all daily summaries from the past week
2. Copy `evaluation/SCORECARD_TEMPLATE.md` to `evaluation/scorecards/YYYY-MM-DD.md`
3. Fill in all fields
4. **LLM-as-judge**: Pick 5 random pieces of published content (Moltbook posts, floor notes, X posts). Rate each 1-10 for:
   - Coherence: Does it make sense? Is it useful?
   - Character: Does it sound like Ace Rothstein?
   - Accuracy: Are the claims verifiable?
5. **Verify 3 claims**: Pick 3 factual statements from floor notes. Can they be confirmed from source data?
6. Identify the single highest-leverage improvement for next week
7. Log the improvement decision to `memory/UPGRADES.md`

---

## Monthly (first Monday of the month)

1. Review all 4 weekly scorecards
2. Identify patterns: what metrics are consistently good/bad?
3. Update `evaluation/METRICS.md` targets if current targets are too easy or unrealistic
4. Write a DISCOVERY sign summarizing the month's trajectory
5. Report findings to Bradley in operator update
