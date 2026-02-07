# Future: Agent Team Architecture

Design doc for multi-agent coordination. NOT implemented yet — single-agent must be secure and autonomous first.

---

## When to Implement

Prerequisites (all must be true):
1. Phase 0 (security) fully operational and validated
2. Phase 1 (autonomy) running stable for 2+ weeks
3. Phase 2 (evaluation) producing weekly scorecards
4. Sandboxed execution environment available
5. Bradley approves the expansion

## Proposed Team Structure

Based on Claude Code Agent Teams architecture (Team Lead + Teammates + Shared Task List + Mailbox):

### Ace (Team Lead — Delegate Mode)
- Strategic decisions, narrative voice, public-facing content
- Coordinates teammates but does NOT implement their tasks
- Approves plans from teammates before execution
- Owns: SOUL.md, AGENTS.md, content output, public posts

### Scout Agent (Teammate)
- Continuous Moltbook/X/ecosystem monitoring
- Produces raw intelligence reports
- Owns: memory/floor-notes/, Moltbook feed processing
- Does NOT publish — only reports to Ace

### Builder Agent (Teammate)
- Visualization code, map updates, website
- Produces: HTML/CSS/JS updates, data pipeline code
- Owns: clawdvegas/floor/, visualization/
- Does NOT have wallet access

### Analyst Agent (Teammate)
- Metrics computation, evaluation scorecards
- Produces: daily summaries, weekly scorecards, trend analysis
- Owns: evaluation/
- Read-only access to everything else

## Security Considerations

- Each teammate gets minimum necessary permissions
- Builder agent: no wallet access, no social posting
- Scout agent: read-only for Moltbook, no wallet access
- Analyst agent: read-only for everything
- Only Ace (Team Lead) can publish content or initiate transactions
- Shared task list with dependency management prevents conflicts
- All teammate actions logged to central session-log.md

## Why Not Now

Multi-agent coordination multiplies the attack surface. Each new agent is another potential injection point. The 93% non-response rate in Moltbook (without explicit protocols) shows that unstructured multi-agent coordination fails. Get single-agent right first.
