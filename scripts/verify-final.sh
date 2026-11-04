#!/usr/bin/env bash
# Verifier: verify-final.sh ZKEY_DIR [LABEL]   (LABEL names the logs, default npm; use another label
# for a second run with a source-built snarkjs: SNARKJS="node /path/build/cli.cjs"
# SNARKJS_SOURCE_COMMIT=<git rev>)
# Runs `snarkjs zkey verify` on request.zkey and withdrawal.zkey in ZKEY_DIR with YOUR ptau (PTAU=...)
# and YOUR r1cs export (R1CS_DIR=...). Publish the two logs.
source "$(dirname "$0")/env.sh"
dir=$1; label=${2:-npm}
"$ROOT/scripts/check-inputs.sh"
{ echo "node $(node --version)"; echo "snarkjs $SNARKJS"; echo "ptau $(sha256 "$PTAU")"; echo "request.r1cs $(sha256 "$R1CS_DIR/request.r1cs")"; echo "withdrawal.r1cs $(sha256 "$R1CS_DIR/withdrawal.r1cs")"; for c in $CIRCUITS; do echo "$c.zkey $(sha256 "$dir/$c.zkey")"; done; } | tee "$dir/independent-verify.$label.inputs.log"
for c in $CIRCUITS; do
  "$SNARKJS" zkey verify "$R1CS_DIR/$c.r1cs" "$PTAU" "$dir/$c.zkey" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$dir/independent-verify.$label.$c.log"
  grep -q 'ZKey Ok!' "$dir/independent-verify.$label.$c.log" || { echo "FAILED: $c"; exit 1; }
done
