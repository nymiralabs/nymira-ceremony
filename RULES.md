# Rules

Last changed on 2 November 2026, before any contribution was published. A later change is recorded in this repository's history.

## What is being secured

Two Groth16 circuits of zkapi (`request` and `withdrawal`, [`PINS.md`](PINS.md)) on top of the public Hermez powers of tau. Each contribution covers both circuits. The keys are for the Nymira vault on NEAR testnet, which holds test USDC only. They are not for mainnet.

## Soundness: what a team-only ceremony gives

The keys are sound if at least one contribution used randomness that was destroyed. Here all contributions are made by the team, in separate directories under separate operating-system users, so they are not three independent parties. If the team's contributors collude, or the machine that ran the contributions was compromised, the toxic waste can be rebuilt and proofs forged against any vault that uses these keys. Nobody outside the team can check otherwise.

What the ceremony does give: the chain is public and checkable. Anyone can verify that each zkey extends its parent, that the beacon was applied, and that the keys match the pinned R1CS and ptau. It does not make the team trustworthy. The vault holds test USDC only for that reason. The circuits have not had an independent review. A forged proof is a loss-of-funds risk; the privacy of existing notes does not depend on this ceremony.

## Who contributes

The team. No outside contributor or verifier is sought, announced for, or waited for. If someone sends an unsolicited contribution before 2026-11-04 00:00 UTC, the coordinator may accept it from the current head, and it counts like any other; the schedule does not move for it.

## Chain and files

- The coordinator makes the first contribution. After that the chain moves strictly in order: each contribution builds on the latest accepted pair, never on an older one.
- A contribution is a pair, `request.zkey` and `withdrawal.zkey`. A pair that misses one circuit is not a contribution.
- A pair is accepted when `snarkjs zkey verify` passes on both files against the pinned ptau and R1CS and the new log extends the parent's by exactly one contribution (`scripts/accept.sh` checks both). The accepted pair is attached to a release of this repository with its `verify` logs.
- A contribution is never discarded unless it fails `zkey verify`. A failing log is published in this repository the same day, with the file's SHA-256.
- A stale or failed contribution is redone from the current head. The chain does not fork.
- The scripts in `scripts/` check parent hashes and allowed files and nothing else; they hold no secrets.

## Schedule

The window runs from 2 November 2026 12:00 UTC to 3 November 2026 23:59 UTC. The coordinator makes three contributions in it, each with fresh randomness, each in a separate directory under a separate operating-system user. No contribution published at or after 2026-11-04 00:00 UTC counts.

## Hashes: one channel

Every accepted pair's SHA-256 values, the snarkjs `integrity` string and the snarkjs commit are published in this repository (the release notes and the committed statement files) and nowhere else. There is no second channel. A reader who wants to rule out a swapped file does not need one: recompute the inputs from [`PINS.md`](PINS.md), check the beacon from an archival node, run `scripts/verify-final.sh`, and compare the verifying-key hashes with the vault's `vk_hashes()`. Someone who controls this repository could still publish a different chain; the vault's compiled-in key hashes are what pins the keys it accepts.

## Entropy

The scripts draw randomness from the operating system, use it once and drop it. Nobody gives the coordinator entropy, and nobody should send any.

## Statement

Each contribution leaves a `statement.txt` (written by `scripts/contribute.sh`) with the SHA-256 of the pair it started from and the pair it produced, and the contribute logs (`*.contribute.log`) hold the contribution hashes snarkjs printed for both circuits. The coordinator commits them to this repository. They are not signed: the repository's commit history is the record, and the claim stops at "the team says it did this".

## Beacon

The beacon is the hash of the first final NEAR mainnet block whose header timestamp is at or after 2026-11-04 00:00 UTC. It is applied to both circuits after the last accepted contribution, with `numIterationsExp = 28`.

After the block is final, `scripts/fetch-beacon.mjs` finds it by height, fetches it from three independent providers and one archival node, compares the hashes and stores the raw JSON and the height. The base58 hash is decoded to 32 bytes and passed to snarkjs as 64 lowercase hex characters. NEAR mainnet is only a public random source here; the vault runs on testnet.

## Checks by the coordinator

The coordinator runs `zkey verify` on both final zkeys with a fresh ptau download and a fresh R1CS export in a clean directory, and once with snarkjs built from the tagged source, and publishes the logs. This is the same person who made the contributions. Anyone can repeat it; nobody is waited for.

## Which keys the vault uses

The testnet vault uses the keys this ceremony produces, imported with zkapi's `import_zkey`. Public text says so, with the warning at the top of the README: test funds only, made by the team alone, no known privacy loss. zkapi's development keys are never used on mainnet or on the final public vault. If the ceremony cannot finish, the vault stays on the `rehearsal` keys and says so.
