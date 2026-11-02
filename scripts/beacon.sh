#!/usr/bin/env bash
# Coordinator and verifiers: beacon.sh LAST_CONTRIBUTION_DIR OUTPUT_DIR BEACON_HEX
# Applies the same beacon to both circuits with 2^28 iterations, then runs `zkey verify` on the result.
source "$(dirname "$0")/env.sh"
last=$1; out=$2; beacon=$3
[[ "$beacon" =~ ^[0-9a-f]{64}$ ]] || { echo "beacon must be 64 lowercase hex characters"; exit 1; }
mkdir -p "$out"
for c in $CIRCUITS; do
  "$SNARKJS" zkey beacon "$last/$c.zkey" "$out/$c.zkey" "$beacon" 28 --name=beacon 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee "$out/$c.beacon.log"
done
"$ROOT/scripts/accept.sh" "$last" "$out"
