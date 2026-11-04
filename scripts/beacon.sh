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
# The beacon in the result is the one given, with 2^28 iterations, as the last entry of each list.
for c in $CIRCUITS; do
  grep -q "Beacon generator: $beacon" "$out/verify.$c.log" || { echo "FAILED: $c verify log does not show the beacon $beacon"; exit 1; }
  grep -q "Beacon iterations Exp: 28" "$out/verify.$c.log" || { echo "FAILED: $c verify log does not show 2^28 iterations"; exit 1; }
  tail -n 1 "$out/contributions.$c.txt" | grep -q "beacon:" || { echo "FAILED: the last contribution of $c is not the beacon"; exit 1; }
done
echo "beacon $beacon is in both results (2^28 iterations)"
