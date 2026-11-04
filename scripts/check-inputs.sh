#!/usr/bin/env bash
# Checks the ptau file and the snarkjs package against the pinned values.
source "$(dirname "$0")/env.sh"
size=$(wc -c <"$PTAU" | tr -d ' ')
[ "$size" = "$PTAU_BYTES" ] || { echo "ptau size $size, expected $PTAU_BYTES"; exit 1; }
[ "$(sha256 "$PTAU")" = "$PTAU_SHA256" ] || { echo "ptau SHA-256 differs"; exit 1; }
[ "$(blake2b512 "$PTAU")" = "$PTAU_BLAKE2B512" ] || { echo "ptau Blake2b-512 differs"; exit 1; }
integrity=$(node -e 'const l=require(process.argv[1]);console.log(l.packages["node_modules/snarkjs"].integrity)' "$ROOT/tools/package-lock.json")
[ "$integrity" = "$SNARKJS_INTEGRITY" ] || { echo "snarkjs integrity differs: $integrity"; exit 1; }
if [ -n "${SNARKJS_SOURCE_COMMIT:-}" ]; then echo "snarkjs built from source at $SNARKJS_SOURCE_COMMIT"; [ "$SNARKJS_SOURCE_COMMIT" = "$SNARKJS_GIT_COMMIT" ] || { echo "source commit differs from $SNARKJS_GIT_COMMIT"; exit 1; }; fi
version=$( ("$SNARKJS" --help 2>&1 || true) | sed -n 1p)
[ "$version" = "snarkjs@$SNARKJS_VERSION" ] || { echo "snarkjs version differs: $version"; exit 1; }
for c in $CIRCUITS; do [ -f "$R1CS_DIR/$c.r1cs" ] || { echo "missing $R1CS_DIR/$c.r1cs"; exit 1; }; done
[ "$(sha256 "$R1CS_DIR/request.r1cs")" = "$REQUEST_R1CS_SHA256" ] || { echo "request.r1cs differs from the pinned hash"; exit 1; }
[ "$(sha256 "$R1CS_DIR/withdrawal.r1cs")" = "$WITHDRAWAL_R1CS_SHA256" ] || { echo "withdrawal.r1cs differs from the pinned hash"; exit 1; }
echo "ok: ptau, snarkjs $SNARKJS_VERSION ($SNARKJS) and r1cs match the pins"
