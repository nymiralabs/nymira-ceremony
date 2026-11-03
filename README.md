# Nymira ceremony

Phase-2 trusted setup for Nymira's two Groth16 circuits, `request` and `withdrawal`, taken from [zkapi](https://github.com/ethereum/zkapi) at a pinned commit. This repository holds the tooling, the rules, every contribution and the logs. It holds no Nymira project code.

Read this first. The team runs this ceremony alone, for the Nymira vault on NEAR testnet, which holds test USDC only. The team makes three contributions and a public beacon closes the chain. No outside contributor or verifier is sought or waited for. The keys are sound only if at least one of the three contributions used randomness that was destroyed, and nobody outside the team can check that. If the team's contributors collude, or the machine that ran them was compromised, they can forge proofs against a vault that uses these keys. That is why the vault holds test funds only and these keys are not for mainnet. There is no known privacy loss. The circuits have not had an independent review, and zkapi does not run them on its own mainnet yet.

## Where things are

| File | What |
|---|---|
| [`RULES.md`](RULES.md) | Chain rules, schedule, beacon, what the vault uses |
| [`CONTRIBUTE.md`](CONTRIBUTE.md) | The commands the team runs for one contribution |
| [`PINS.md`](PINS.md) | Commit, R1CS and ptau hashes, snarkjs integrity and commit |
| [`MEASUREMENTS.md`](MEASUREMENTS.md) | Sizes and times from the rehearsal |
| `scripts/` | `check-inputs.sh`, `init.sh`, `contribute.sh`, `accept.sh`, `beacon.sh`, `verify-final.sh`, `fetch-beacon.mjs` |
| `logs/` | zkapi fidelity and import gate logs, rehearsal import and proving gate logs |
| `r1cs/r1cs-manifest.json` | R1CS export manifest |

## Timeline (UTC)

- Contributions: 2 November 2026 12:00 to 3 November 23:59, three contributions by the team.
- Beacon: first final NEAR mainnet block with a header timestamp at or after 4 November 00:00.

## Checking the result

Anyone can recompute the beacon from an archival NEAR node (`node scripts/fetch-beacon.mjs 2026-11-04T00:00:00Z OUT`), run `scripts/verify-final.sh` on the final zkeys with their own ptau and R1CS, and compare the verifying-key hashes in the transcript with the vault's `vk_hashes()`.
