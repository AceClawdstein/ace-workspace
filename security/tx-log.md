# Transaction Log

Append-only record of all financial operations. Never delete entries.

Format:
```
[ISO timestamp] [PRE|POST|KILL_SWITCH] | to: [address] | amount: [value] | reason: [why] | skill: [name] | tx: [hash if POST]
```

---

## Log

### Pre-Security-Policy Transactions (from memory/2026-02-03.md)
- 2026-02-03 ~02:00 UTC | POST | to: 0x49Ff63dB812179f1d855dBD8d4755AEb470226Dc (coinbrad.base.eth) | amount: 1 USDC | reason: Test transfer | skill: evm-wallet-clawcast | tx: 0xec09f826ac70b5fbcbd7a193e17c1c1aef4b45d0b658739e8ff2e9c6b195adc1
- 2026-02-03 ~02:30 UTC | POST | to: ClawdVine (video generation) | amount: $1.00 USDC | reason: First video generation | skill: clawdvine | tx: via x402
- 2026-02-03 ~02:45 UTC | POST | to: ClawdVine (video generation) | amount: $1.20 USDC | reason: Image-to-video generation | skill: clawdvine | tx: via x402

---

<!-- New entries below this line -->
