# Nymira ceremony

Phase-2 trusted setup for Nymira's two Groth16 circuits, `request` and `withdrawal`, taken from [zkapi](https://github.com/ethereum/zkapi) at a pinned commit. This repository holds the tooling, the rules, every contribution and the logs. It holds no Nymira project code.

Read this first. The keys are sound if at least one contributor was honest and destroyed their entropy. The team cannot prove that from the outside. The circuits have not had an independent review, and zkapi does not run them on its own mainnet yet. Anonymous contributors count by the first public key they signed with, so "multi-party" rests on each contributor's statement.

## Where things are

| File | What |
|---|---|
| [`RULES.md`](RULES.md) | Chain rules, queue, attestation format, beacon, decision rule for 7 November |
| [`CONTRIBUTE.md`](CONTRIBUTE.md) | Commands for a contributor |
| [`QUEUE.md`](QUEUE.md) | Ten 12-hour slots |
| [`PINS.md`](PINS.md) | Commit, R1CS and ptau hashes, snarkjs integrity and commit |
| [`MEASUREMENTS.md`](MEASUREMENTS.md) | Sizes and times from the rehearsal |
| `scripts/` | `check-inputs.sh`, `init.sh`, `contribute.sh`, `accept.sh`, `beacon.sh`, `verify-final.sh`, `fetch-beacon.mjs` |
| `logs/` | zkapi fidelity and import gate logs, rehearsal import and proving gate logs |
| `r1cs/r1cs-manifest.json` | R1CS export manifest |

## Timeline (UTC)

- Contributions: 2 November 2026 00:00 to 6 November 23:59, in ten 12-hour slots.
- Beacon: first final NEAR mainnet block with a header timestamp at or after 7 November 00:00.
- Decision: 7 November, by the rule in `RULES.md`.

## Checking the result

Anyone can recompute the beacon from an archival NEAR node (`node scripts/fetch-beacon.mjs 2026-11-07T00:00:00Z OUT`), run `scripts/verify-final.sh` on the final zkeys with their own ptau and R1CS, and compare the verifying-key hashes in the transcript with the vault's `vk_hashes()`.
