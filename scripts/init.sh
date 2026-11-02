#!/usr/bin/env bash
# Coordinator: writes chain/0000, the zkeys before any contribution.
source "$(dirname "$0")/env.sh"
"$ROOT/scripts/check-inputs.sh"
mkdir -p "$ROOT/chain/0000"
for c in $CIRCUITS; do
  "$SNARKJS" groth16 setup "$R1CS_DIR/$c.r1cs" "$PTAU" "$ROOT/chain/0000/$c.zkey"
done
"$ROOT/scripts/accept.sh" init "$ROOT/chain/0000"
