#!/usr/bin/env bash
# Verifier: verify-final.sh ZKEY_DIR
# Runs `snarkjs zkey verify` on request.zkey and withdrawal.zkey in ZKEY_DIR with YOUR ptau (PTAU=...)
# and YOUR r1cs export (R1CS_DIR=...). Publish the two logs.
source "$(dirname "$0")/env.sh"
dir=$1
"$ROOT/scripts/check-inputs.sh"
for c in $CIRCUITS; do
  "$SNARKJS" zkey verify "$R1CS_DIR/$c.r1cs" "$PTAU" "$dir/$c.zkey" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$dir/independent-verify.$c.log"
  grep -q 'ZKey Ok!' "$dir/independent-verify.$c.log" || { echo "FAILED: $c"; exit 1; }
done
