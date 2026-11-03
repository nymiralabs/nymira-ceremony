# Running a contribution

This is the team's procedure, not an invitation: the ceremony takes no outside contributors (see [`RULES.md`](RULES.md)). Anyone can still read the commands, and anyone can repeat the checks in step 2 and step 5.

You need Node 24, about 300 MB of disk and a few minutes of CPU. A contribution takes seconds; checking the previous pair takes a few minutes per circuit.

## 1. Install snarkjs 0.7.6

```bash
cd tools && npm ci
node -e 'console.log(require("./package-lock.json").packages["node_modules/snarkjs"].integrity)'
```

Expected: `sha512-4uH1xA5JzVU5jaaWS2fXej3+RC6L5Erhr6INTJtUA27du4Elbh4VXCeeRjB4QiwL6N6y7SNKePw5prTxyEf4Zg==`, from tag `v0.7.6`, commit `9a8f1c0083d18b9b5e18f526cfd729e7259423be`. For the final check, build snarkjs from that tag instead (`npm run buildcjs && npm run buildcli`, then run `node build/cli.cjs`).

## 2. Get and check the inputs

Download the ptau and export the R1CS files from zkapi at the pinned commit; commands and expected hashes are in [`PINS.md`](PINS.md). Then run `scripts/check-inputs.sh`.

## 3. Check the previous pair

```bash
scripts/verify-final.sh PREVIOUS_DIR
```

It must print `ZKey Ok!` twice. If not, stop.

## 4. Contribute

```bash
scripts/contribute.sh PREVIOUS_DIR MY_DIR "name"
```

Run each contribution in its own directory under its own operating-system user. The script passes the randomness to snarkjs as a command-line argument, so other users of the same machine can see it in the process list for a few seconds; run the three contributions on a machine where that does not matter, or run `snarkjs zkey contribute` by hand and type the randomness when asked. The script writes `statement.txt` with the SHA-256 of the pair it started from and the pair it produced.

## 5. Accept and publish

`scripts/accept.sh` checks the new pair against its parent. Attach the accepted pair to a release of this repository with the `verify` logs, and commit `statement.txt`. After the beacon, run `scripts/verify-final.sh` on the final zkeys.
