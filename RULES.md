# Rules

These rules are fixed before the first outside contribution. A change after that point is announced in the ceremony issue, and anyone who has already contributed may withdraw.

## What is being secured

Two Groth16 circuits of zkapi (`request` and `withdrawal`, [`PINS.md`](PINS.md)) on top of the public Hermez powers of tau. Each contribution covers both circuits. The keys protect against forged proofs: with them the vault accepts only proofs made for its circuits, and no one, including the team, can forge a withdrawal if at least one contributor discarded their randomness.

## Soundness

The keys are sound if at least one contributor was honest and destroyed their entropy. Nymira cannot prove from the outside that any contributor was. Anonymous contributors count by the first public key they signed with, so "multi-party" here rests on each contributor's own statement. The circuits have not had an independent review.

## Chain and files

- The coordinator makes the first contribution. After that the chain moves strictly in order: each contribution builds on the latest accepted pair, never on an older one.
- A contribution is a pair, `request.zkey` and `withdrawal.zkey`. A pair that misses one circuit is not a contribution.
- A pair is accepted when `snarkjs zkey verify` passes on both files against the pinned ptau and R1CS and the new log extends the parent's by exactly one contribution (`scripts/accept.sh` checks both). The accepted pair is attached to a release of this repository with its `verify` logs.
- A contribution is never discarded unless it fails `zkey verify`. A failing log is published in the ceremony issue the same day, with the file's SHA-256.
- A stale or failed contribution is redone from the current head. The chain does not fork.
- The coordinator runs the scripts in `scripts/`. They check parent hashes and allowed files and nothing else; they hold no secrets.

## Hashes on a second channel

Every accepted pair's SHA-256 values, the snarkjs `integrity` string and the snarkjs commit are posted on X (`@nymiralabs`) and in the Discord server (`nymiralabs`) as well as in this repository. A contributor compares both before using a file.

## Queue, slots and timeouts

- The window runs from 2 November 2026 00:00 UTC to 6 November 2026 23:59 UTC. [`QUEUE.md`](QUEUE.md) holds ten fixed 12-hour slots; the coordinator takes slot 1.
- A contributor books a slot by commenting on the queue issue. A booking is for one slot.
- A slot with no booking is a spare slot. Whoever asks first may take it.
- If the contributor has not published by the end of their slot, the next booked contributor (or the next spare) goes first, and the late contributor may still contribute afterwards if the head has not moved. A pair built on an old head is rejected as stale and redone from the head.
- No contribution published at or after 2026-11-07 00:00 UTC counts. "Published" means the time of the issue post that links the files.

## Entropy

Nobody asks any contributor for entropy, in any form, ever. A message that does so is not from the ceremony. The scripts draw it from the operating system, use it once and drop it.

## Attestation

Each contributor posts, in the ceremony issue, a statement with these lines:

```
nymira-ceremony contribution
name: <name, handle or "anonymous">
started_from_request_sha256: <hex>
started_from_withdrawal_sha256: <hex>
contribution_hash_request: <the 16 words snarkjs printed for the request circuit>
contribution_hash_withdrawal: <the 16 words snarkjs printed for the withdrawal circuit>
output_request_sha256: <hex>
output_withdrawal_sha256: <hex>
entropy: <how it was produced and that it was discarded>
snarkjs: <npm 0.7.6 | built from tag v0.7.6>
```

and signs it with one of:

- minisign
- GPG
- a NEAR key (NEP-413 message signing)
- a post from an existing public account that links to the issue comment

An anonymous contributor signs with a fresh key. The coordinator records the first public key seen for that contributor in `contributors.md`; the contributor counts under that key.

## People we did not pick

An outside contributor is someone who answered the public call and has no tie to the team: not a member, relative, employee, contractor or investor of Nymira Labs, and not someone whose key the team generated or holds. An anonymous contributor is counted by the first public key they signed with. An outside contribution counts toward the 7 November rule only after that contributor posts the final-chain statement below; a contributor who never posts it is not counted, however good their contribution was.

## Beacon

The beacon is the hash of the first final NEAR mainnet block whose header timestamp is at or after 2026-11-07 00:00 UTC. It is applied to both circuits after the last accepted contribution, with `numIterationsExp = 28`.

After the block is final, `scripts/fetch-beacon.mjs` finds it by height, fetches it from three independent providers and one archival node, compares the hashes and stores the raw JSON and the height. The base58 hash is decoded to 32 bytes and passed to snarkjs as 64 lowercase hex characters. NEAR mainnet is only a public random source here; the vault may run on any network.

## Final-chain statement

After the beacon, each contributor runs `scripts/verify-final.sh` on the final zkeys, with their own ptau download and their own R1CS export, and posts a signed statement that their contribution hash from the attestation appears in the verify log of both circuits.

## Independent checks

An outside volunteer runs `zkey verify` on both final zkeys with their own ptau and R1CS and publishes the log. A second verifier (neither the first volunteer nor the coordinator) does the same with snarkjs built from the tagged source.

## Decision rule for 7 November

Ceremony keys are used if all of these hold on 7 November:

1. At least three valid contributions before the beacon, with at least two from people we did not pick, each of those two with a posted final-chain statement.
2. The beacon is applied to both circuits.
3. The outside `zkey verify` log is published.
4. zkapi's `import_zkey` and proving gate pass.

Otherwise the public vault gets fallback keys made by the team alone under the `nymira` setup id. They ship only after an outside `zkey verify` against the Hermez ptau and the R1CS is published. The README then carries a warning at the top: no known privacy loss, funds at risk, because the team could forge proofs and the outside verify checks only that the proving key is well formed. Open user deposits stay capped at 100 USDC either way. zkapi's development keys are never used on mainnet or on the final public vault.
