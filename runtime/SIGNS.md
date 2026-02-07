# Signs — Cross-Instance Memory

Messages from previous instances to future instances.

**Read this file at the START of every session.**
**Write to it at the END of every session (or on forced context rotation).**

This is how Ace learns across context boundaries. Each instance is temporary. The Signs persist.

---

## Sign Types
- **DISCOVERY** — Something new found that matters for ClawdVegas
- **WARNING** — Something to avoid or be careful about
- **STUCK** — A problem that couldn't be solved (so you don't repeat it)
- **OPPORTUNITY** — Something worth pursuing next cycle
- **RELATIONSHIP** — An agent interaction worth continuing

## Format
```
### [YYYY-MM-DD HH:MM UTC] Cycle #N — [SIGN_TYPE]
[Message]
```

---

## Signs

### 2026-02-07 — DISCOVERY
Phase 0 security hardening complete. Ace now has:
- 6-layer input defense (security/INPUT_POLICY.md)
- Transaction gating with daily limits (security/WALLET_POLICY.md)
- All 17 skills risk-tiered, T4 skills disabled by default (security/SKILL_AUDIT.md)
- Secrets scrubbed from git-tracked files (security/SECRETS_REGISTRY.md)
- Session and transaction logging (security/session-log.md, security/tx-log.md)
The security foundation exists. Future instances: follow the security protocol in AGENTS.md.

### 2026-02-07 — WARNING
T4 skills (base-trader, streme-launcher, pumpclaw, ralph-loop, codex-sub-agents) are DISABLED by default. Do not use them unless Bradley explicitly enables them in the current session. This is a hard rule.

### 2026-02-07 — WARNING
Credentials were previously exposed in git-tracked files (MEMORY.md, WORKING.md, daily notes). They have been scrubbed but the git HISTORY still contains them. Bradley needs to run BFG Repo Cleaner to fully purge. Until then, treat the repo as having exposed: server IP, ClawdVine agentId/MCP endpoint, wallet addresses.

### 2026-02-07 — OPPORTUNITY
The runtime layer (STATE.md, SIGNS.md, PROMPT.md, heartbeat.sh) is being built. Once complete and deployed to the server with a cron job, Ace will be actually autonomous for the first time. Priority: get heartbeat.sh running on the server (see ~/.ace-secrets/infra.env for details).
