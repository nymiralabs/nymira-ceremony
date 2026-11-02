# Contributing

You need a computer with Node 24, about 300 MB of disk and a few minutes of CPU. Your slot is 12 hours (slots 2 and 3 in the queue); a contribution itself takes seconds, and checking what you receive takes a few minutes per circuit.

Nobody asks you for your randomness. Do not send it to anyone, and do not reuse it. The script below draws it from your operating system, uses it once and lets it go. If you prefer, supply your own with `-e` (see step 4).

## 1. Install snarkjs 0.7.6 and check it

```bash
git clone https://github.com/nymiralabs/nymira-ceremony.git && cd nymira-ceremony/tools
npm ci
```

`npm ci` refuses a package whose hash differs from `package-lock.json`. Compare the `integrity` string in the lock file with the one on the second channel as well:

```bash
node -e 'console.log(require("./package-lock.json").packages["node_modules/snarkjs"].integrity)'
```

Expected: `sha512-4uH1xA5JzVU5jaaWS2fXej3+RC6L5Erhr6INTJtUA27du4Elbh4VXCeeRjB4QiwL6N6y7SNKePw5prTxyEf4Zg==`. The package comes from tag `v0.7.6`, commit `9a8f1c0083d18b9b5e18f526cfd729e7259423be`.

After the install you can disconnect from the network. Nothing below needs it.

At least one contributor builds snarkjs from that tagged source instead of using the npm package (`git clone --branch v0.7.6`, `npm ci`, `npm run buildcjs && npm run buildcli`, then run `node build/cli.cjs` in place of `tools/node_modules/.bin/snarkjs`). Say in your statement if you did.

## 2. Get the inputs and check them yourself

Download `powersOfTau28_hez_final_16.ptau` and export the R1CS files from zkapi at the pinned commit; do not take either from the coordinator. Commands and expected hashes are in [`PINS.md`](PINS.md). Put the ptau in `inputs/` and the R1CS files in `r1cs/`, then:

```bash
scripts/check-inputs.sh
```

## 3. Get and verify the previous pair

Download `request.zkey` and `withdrawal.zkey` of the latest accepted link from the release named in [`QUEUE.md`](QUEUE.md). Compare their SHA-256 with the second channel. Then verify the whole chain before you add to it:

```bash
scripts/verify-final.sh PREVIOUS_DIR
```

It must print `ZKey Ok!` twice. If it does not, stop and tell the coordinator in the ceremony issue; do not contribute.

## 4. Contribute

```bash
scripts/contribute.sh PREVIOUS_DIR MY_DIR "your name or key id"
```

This adds one contribution to each circuit and writes `statement.txt` with four SHA-256 values: the pair you started from and the pair you produced. The script passes the randomness to snarkjs as a command-line argument, which other users on the same machine can see in the process list for the few seconds it runs. On a shared machine, run `tools/node_modules/.bin/snarkjs zkey contribute PREVIOUS_DIR/request.zkey MY_DIR/request.zkey --name="your name"` yourself (and the same for `withdrawal`); snarkjs then asks you to type random text. To use your own randomness with the script, replace the `entropy=` line. Do not publish it.

## 5. Publish and attest

Publish `request.zkey` and `withdrawal.zkey` from `MY_DIR` somewhere you control (a GitHub release, a gist or IPFS). Open an issue on this repository with the link, the output hashes and the hash you started from, and sign the statement ([`RULES.md`](RULES.md) lists the accepted signatures and the exact format).

## 6. After the beacon

When the final zkeys are out, run `scripts/verify-final.sh` on them with your own ptau and R1CS, check that your contribution hash appears in both logs, and post a signed statement that it does. This post is optional; it confirms your contribution is in the chain the vault uses.
