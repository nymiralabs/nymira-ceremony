# Pins

Everything a contributor or verifier compares against. These values are fixed for the whole ceremony.

| What | Value |
|---|---|
| Circuits | `zkapi-v2-concession-v2` at `ethereum/zkapi` commit `4ac25c811318d96a873b8b232c7be2252e16c0bd` (merge of PR #31 on `main`). zkapi has published no freeze tag. |
| `request.r1cs` | 13,960,280 bytes, SHA-256 `28067d5f6f8b222a5af37cf53239f04a972f6fc0d0c031ed0ad99bc1d4820cfd`, 23,507 constraints |
| `withdrawal.r1cs` | 7,441,216 bytes, SHA-256 `cd332f7b3876a9a7f883bf8d3f7baa8c090ce8a301c7495ee4ccedfc4f485401`, 20,545 constraints |
| Export manifest | [`r1cs/r1cs-manifest.json`](r1cs/r1cs-manifest.json) |
| Phase 1 | `powersOfTau28_hez_final_16.ptau`, 75,580,568 bytes |
| ptau SHA-256 | `1c401abb57c9ce531370f3015c3e75c0892e0f32b8b1e94ace0f6682d9695922` |
| ptau Blake2b-512 | `6a6277a2f74e1073601b4f9fed6e1e55226917efb0f0db8a07d98ab01df1ccf43eb0e8c3159432acd4960e2f29fe84a4198501fa54c8dad9e43297453efec125` (the value zkapi's `import_zkey` accepts for this file) |
| ptau source | `https://circom.info/powersOfTau28_hez_final_16.ptau`. The original Hermez bucket (`storage.googleapis.com/zkevm/ptau/`) answers 403 on 2 November 2026; the file from circom.info has the same Blake2b-512. |
| snarkjs | 0.7.6, npm `integrity` `sha512-4uH1xA5JzVU5jaaWS2fXej3+RC6L5Erhr6INTJtUA27du4Elbh4VXCeeRjB4QiwL6N6y7SNKePw5prTxyEf4Zg==` |
| snarkjs source | tag `v0.7.6` (an annotated tag), commit `9a8f1c0083d18b9b5e18f526cfd729e7259423be`, equal to the package's `gitHead` |
| Beacon | hash of the first final NEAR mainnet block with a header timestamp at or after `2026-11-04T00:00:00Z`, `numIterationsExp = 28` |

The same SHA-256 values and the snarkjs integrity string and commit are posted on a second channel (see [`RULES.md`](RULES.md)).

## Reproducing the inputs

```bash
curl -fsSL -o inputs/powersOfTau28_hez_final_16.ptau https://circom.info/powersOfTau28_hez_final_16.ptau
git clone https://github.com/ethereum/zkapi.git && cd zkapi && git checkout 4ac25c811318d96a873b8b232c7be2252e16c0bd
cd protocol/rust && cargo run --release -p zkapi-proof --example export_r1cs -- ../../../r1cs
```

The export needs rustc 1.99.0 (the toolchain file in the repository pins it). `scripts/check-inputs.sh` compares the result with the values above.
