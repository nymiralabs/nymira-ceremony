# Nymira ceremony

Phase-2 trusted setup for Nymira's two Groth16 circuits, `request` and `withdrawal`, taken from [zkapi](https://github.com/ethereum/zkapi) at a pinned commit. This repository holds the tooling, the rules, every contribution and the logs. It holds no Nymira project code.

Read this first. This ceremony is run by the team for the Nymira vault on NEAR testnet, which holds test USDC only. The team makes three contributions and a public beacon closes the chain. Outside contributions are welcome and not waited for. Until one arrives, treat the keys as a setup made by the team alone: whoever holds the team's machines could forge proofs against a vault that uses them. There is no known privacy loss. The circuits have not had an independent review, and zkapi does not run them on its own mainnet yet.

## Where things are

| File | What |
|---|---|
| [`RULES.md`](RULES.md) | Chain rules, queue, attestation format, beacon, what the vault uses |
| [`CONTRIBUTE.md`](CONTRIBUTE.md) | Commands for a contributor |
| [`QUEUE.md`](QUEUE.md) | Ten 12-hour slots |
| [`PINS.md`](PINS.md) | Commit, R1CS and ptau hashes, snarkjs integrity and commit |
| [`MEASUREMENTS.md`](MEASUREMENTS.md) | Sizes and times from the rehearsal |
| `scripts/` | `check-inputs.sh`, `init.sh`, `contribute.sh`, `accept.sh`, `beacon.sh`, `verify-final.sh`, `fetch-beacon.mjs` |
| `logs/` | zkapi fidelity and import gate logs, rehearsal import and proving gate logs |
| `r1cs/r1cs-manifest.json` | R1CS export manifest |

## Timeline (UTC)

- Contributions: 2 November 2026 12:00 to 3 November 23:59, in three 12-hour slots.
- Beacon: first final NEAR mainnet block with a header timestamp at or after 4 November 00:00.

## Checking the result

Anyone can recompute the beacon from an archival NEAR node (`node scripts/fetch-beacon.mjs 2026-11-04T00:00:00Z OUT`), run `scripts/verify-final.sh` on the final zkeys with their own ptau and R1CS, and compare the verifying-key hashes in the transcript with the vault's `vk_hashes()`.
