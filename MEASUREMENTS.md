# Measurements

From the rehearsal on 2 November 2026 with zkapi's `rehearsal` setup id. One machine (Apple M4, 10 cores, 16 GB), snarkjs 0.7.6 from npm, Node v26.12.1. Other machines or operating systems will see other times. Node 24 was not run in the rehearsal.

## Sizes

| File | Bytes |
|---|---|
| `request.zkey` | about 24.8 MB (24,801,884 at start, 24,803,535 after beacon) |
| `withdrawal.zkey` | about 16.0 MB (15,981,300 at start, 15,982,951 after beacon) |
| One contribution pair | about 40.8 MB to download and the same to upload |
| `request.r1cs` / `withdrawal.r1cs` | 13,960,280 / 7,441,216 |
| ptau | 75,580,568 |

Three contributions and the beacon add 1,651 bytes to each zkey.

## Times

| Step | request | withdrawal |
|---|---|---|
| `groth16 setup` (both circuits together) | 65 s | |
| `zkey contribute` | 2 s | 3 s |
| `zkey verify` on the final zkey (three contributions and beacon) | 201 s | 174 s |
| `zkey beacon`, 2^28 iterations | 160 s | 158 s |
| `import_zkey` with all gates | 21 s | |
| `proofs` test file on the imported setup | 7.4 s | |

Contributing is quick; the time goes into verifying the previous pair.

## Beacon

The rehearsal beacon rule was the first final NEAR mainnet block at or after 2026-11-02 12:00:00 UTC: height 222,716,051, hash `8CEJVVv1xjHpwZkS7cxFUEHTW8mPHgxbcmyXS9y7s4Gn`, 32 bytes `6ae23cce517977c28806565035d4c162b9d3ff3feaead9006c52bc342e2a1eaf`. Three providers (`rpc.mainnet.near.org`, `free.rpc.fastnear.com`, `rpc.shitzuapes.xyz`) and one archival node (`archival-rpc.mainnet.fastnear.com`) returned the same hash. The search takes about 6 seconds.

The non-archival providers keep only a few days of blocks, so the beacon must be fetched soon after 4 November 00:00 UTC. `archival-rpc.mainnet.near.org` answers 429 "deprecated" on 2 November 2026.

## Not covered by the rehearsal

- Three contributions on three different machines: all three ran on this one machine in separate directories.
- Verification by a second person (none is planned; the ceremony is team-only). A second directory with a fresh ptau download, a fresh R1CS export and a fresh `npm ci` verified the final zkeys, but on the same machine.
- Node 24.
