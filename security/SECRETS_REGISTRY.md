# Secrets Registry

All credentials and sensitive data for Ace Clawdstein. This is the single source of truth for what exists, where it lives, and who can access it.

---

## Classification Levels

| Level | Definition | Approved Storage |
|-------|-----------|-----------------|
| **PUBLIC** | Can appear anywhere. No harm if exposed. | Any file, including git-tracked |
| **SENSITIVE** | Useful to attackers but not directly exploitable. | `~/.ace-secrets/` (chmod 600, gitignored) |
| **CRITICAL** | Direct access to funds, accounts, or systems. | Environment variables ONLY. Never on disk in plaintext. |

---

## Secrets Inventory

### Wallet
| Secret | Classification | Storage |
|--------|---------------|---------|
| Wallet address (0x037C...946D7) | PUBLIC | May appear in docs |
| Wallet private key | CRITICAL | Environment variable `PRIVATE_KEY` only |
| Authorized recipient (coinbrad.base.eth / 0x49Ff...26Dc) | PUBLIC | WALLET_POLICY.md |
| Token contracts ($CLAWDVEGAS, $ACECLAWD) | PUBLIC | May appear in docs |

### ClawdVine
| Secret | Classification | Storage |
|--------|---------------|---------|
| agentId (1:22861) | SENSITIVE | `~/.ace-secrets/services.env` |
| MCP endpoint URL | SENSITIVE | `~/.ace-secrets/services.env` |
| IPFS metadata hash | PUBLIC | May appear in docs |
| USDC balance | SENSITIVE | `~/.ace-secrets/services.env` |

### Moltbook
| Secret | Classification | Storage |
|--------|---------------|---------|
| Profile URL (moltbook.com/u/AceClawdstein) | PUBLIC | May appear in docs |
| API Key | CRITICAL | `~/.config/moltbook/credentials.json` (verify permissions) |

### Twitter/X
| Secret | Classification | Storage |
|--------|---------------|---------|
| Handle (@aceclawdstein) | PUBLIC | May appear in docs |
| API keys (OAuth) | CRITICAL | Environment variables only |

### Infrastructure
| Secret | Classification | Storage |
|--------|---------------|---------|
| Server IP | SENSITIVE | `~/.ace-secrets/infra.env` |
| GitHub token | CRITICAL | Environment variable only |
| GitHub repo URL | PUBLIC | May appear in docs |

### Clawdict
| Secret | Classification | Storage |
|--------|---------------|---------|
| Agent ID (agent_55ac6c460b3e6439) | SENSITIVE | `~/.ace-secrets/services.env` |

---

## Rules

1. **CRITICAL secrets NEVER appear in git-tracked files.** No exceptions.
2. **SENSITIVE secrets live in `~/.ace-secrets/` only.** Verify `chmod 600` on all files.
3. **PUBLIC information may appear in operating docs** but should not be repeated unnecessarily.
4. **When in doubt, classify UP** (treat SENSITIVE as CRITICAL).
5. **On credential rotation:** update this registry immediately with new storage location.
6. **Quarterly audit:** verify all secrets are in their approved locations.

---

## Migration Status

| Item | From | To | Status |
|------|------|----|--------|
| Server IP | memory/WORKING.md, memory/2026-02-03.md | ~/.ace-secrets/infra.env | PENDING |
| ClawdVine agentId + MCP | MEMORY.md, WORKING.md | ~/.ace-secrets/services.env | PENDING |
| Clawdict agentId | MEMORY.md | ~/.ace-secrets/services.env | PENDING |
| GitHub token reference | WORKING.md, 2026-02-03.md | Environment variable | PENDING |

> **Note to Bradley:** After this file is created, run `mkdir -p ~/.ace-secrets && chmod 700 ~/.ace-secrets` and create the .env files listed above. Then we can scrub the secrets from git-tracked files and run BFG Repo Cleaner on history.
