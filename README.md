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

## Result (4 November 2026)

The chain has three team contributions and a beacon from NEAR mainnet block 222942364. `import_zkey --setup-id mpc-1` accepted it. [`chain-record/0004/statement.txt`](chain-record/0004/statement.txt) has every hash. In short:

| | |
|---|---|
| `request.zkey` SHA-256 | `56b0f2d61ab18d87c4697e4dcb5409ea9b2e34f0e1185de58905fed8ed3b505e` |
| `withdrawal.zkey` SHA-256 | `92b83710e19adad380e4baba3a4726e94fa96587ca12c3be4f6205eb7da5a16b` |
| request verifying key, keccak256 | `0xf3092e0d550f696a6507f279862afb43d0c22663de56f1b47160b5db6fc6fa1b` |
| withdrawal verifying key, keccak256 | `0x3469ebb3245101549343dbe5939427d3dc7706c314f281f9b5935416fc720c8d` |
| transcript SHA-256 | `e75cae40c203b08f8b9e559a2fa4b18f464e709d68abe01318c2d8a7aa4b7e07` |

The `final` release holds the zkeys and the imported setup directory (`request.pk`, `request.vk`, `withdrawal.pk`, `withdrawal.vk`, `manifest.json`); each earlier pair has its own release (`chain-0000` to `chain-0003`). `chain-record/` has the statements, contribution lists and logs of every step, with local paths replaced by `<home>`, `<ceremony>` and `<nymira>`; `transcript.sha256sums` hashes the original files. The two verification logs (`logs/final-verify/`) come from snarkjs 0.7.6 from npm and built from its tag, each with a fresh ptau and an R1CS exported from a fresh zkapi clone.

The same people ran every contribution, from the project's own machines: the keys are sound if at least one of the three used randomness that was destroyed, and nobody outside can check that. The zkapi development keys, whose secrets are public, are never used on the final vault.

## Timeline (UTC)

- Contributions: 2 November 2026 12:00 to 3 November 23:59, three contributions by the team.
- Beacon: first final NEAR mainnet block with a header timestamp at or after 4 November 00:00.

## Checking the result

Anyone can recompute the beacon from an archival NEAR node (`node scripts/fetch-beacon.mjs 2026-11-04T00:00:00Z OUT`; the three non-archival providers keep about 20 hours, so after 4 November only the archival nodes answer and the raw files in `logs/beacon-final/` are the record), run `scripts/verify-final.sh` on the final zkeys with their own ptau and R1CS, and compare the verifying-key hashes in the transcript with the vault's `vk_hashes()`.
