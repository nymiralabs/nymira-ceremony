# Rules

These rules were last changed on 2 November 2026, before any contribution was published. After the first outside contribution, a change is announced in the ceremony issue, and anyone who has already contributed may withdraw.

## What is being secured

Two Groth16 circuits of zkapi (`request` and `withdrawal`, [`PINS.md`](PINS.md)) on top of the public Hermez powers of tau. Each contribution covers both circuits. The keys are for the Nymira vault on NEAR testnet, which holds test USDC only. They are not for mainnet.

## Soundness

The keys are sound if at least one contributor was honest and destroyed their entropy. Nymira runs this ceremony with its own contributions and does not recruit outside contributors; the team cannot prove from the outside that any contributor was honest. Read the keys as a setup made by the team alone, with a public beacon and a public transcript, until an outside contributor appears. Whoever holds the team's machines could forge proofs against a vault that uses them, so the vault holds test USDC only. The circuits have not had an independent review.

Anyone who wants to contribute may. A volunteer's contribution is accepted and counted, but nothing in the rules waits for one.

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

- The window runs from 2 November 2026 12:00 UTC to 3 November 2026 23:59 UTC. [`QUEUE.md`](QUEUE.md) holds three fixed 12-hour slots. The coordinator makes the first contribution and then two more, each with fresh randomness, each in a separate directory under a separate operating-system user.
- A volunteer books a slot by commenting on the queue issue. Slots 2 and 3 are open; if nobody books one, the window passes with the coordinator's three contributions only.
- If a booked contributor has not published by the end of their slot, the slot passes. The contributor may still contribute afterwards if the head has not moved. A pair built on an old head is rejected as stale and redone from the head.
- No contribution published at or after 2026-11-04 00:00 UTC counts. "Published" means the time of the issue post that links the files.

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

## Contributors

The coordinator's three contributions are team contributions. A volunteer is anyone else. Volunteers are listed by name or by the first public key they signed with. Nobody is required to post a final-chain statement; a volunteer who does is listed as having confirmed.

## Beacon

The beacon is the hash of the first final NEAR mainnet block whose header timestamp is at or after 2026-11-04 00:00 UTC. It is applied to both circuits after the last accepted contribution, with `numIterationsExp = 28`.

After the block is final, `scripts/fetch-beacon.mjs` finds it by height, fetches it from three independent providers and one archival node, compares the hashes and stores the raw JSON and the height. The base58 hash is decoded to 32 bytes and passed to snarkjs as 64 lowercase hex characters. NEAR mainnet is only a public random source here; the vault runs on testnet.

## Final-chain statement

After the beacon, each volunteer who contributed may run `scripts/verify-final.sh` on the final zkeys and post a signed statement that their contribution hash appears in the verify log of both circuits.

## Independent checks

The coordinator runs `zkey verify` on both final zkeys with a fresh ptau download and a fresh R1CS export in a clean directory, and once with snarkjs built from the tagged source, and publishes the logs. Anyone else can repeat this. An outside verification is welcome and is not waited for.

## Which keys the vault uses

The testnet vault uses the keys this ceremony produces, imported with zkapi's `import_zkey`. Public text says so, with the warning at the top of the README: test funds only, the team could forge proofs, no known privacy loss. zkapi's development keys are never used on mainnet or on the final public vault. If the ceremony cannot finish, the vault stays on the `rehearsal` keys and says so.
