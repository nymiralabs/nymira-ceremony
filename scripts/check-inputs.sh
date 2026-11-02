#!/usr/bin/env bash
# Checks the ptau file and the snarkjs package against the pinned values.
source "$(dirname "$0")/env.sh"
size=$(wc -c <"$PTAU" | tr -d ' ')
[ "$size" = "$PTAU_BYTES" ] || { echo "ptau size $size, expected $PTAU_BYTES"; exit 1; }
[ "$(sha256 "$PTAU")" = "$PTAU_SHA256" ] || { echo "ptau SHA-256 differs"; exit 1; }
[ "$(blake2b512 "$PTAU")" = "$PTAU_BLAKE2B512" ] || { echo "ptau Blake2b-512 differs"; exit 1; }
integrity=$(node -e 'const l=require(process.argv[1]);console.log(l.packages["node_modules/snarkjs"].integrity)' "$ROOT/tools/package-lock.json")
[ "$integrity" = "$SNARKJS_INTEGRITY" ] || { echo "snarkjs integrity differs: $integrity"; exit 1; }
version=$( ("$SNARKJS" --help 2>&1 || true) | sed -n 1p)
[ "$version" = "snarkjs@$SNARKJS_VERSION" ] || { echo "snarkjs version differs: $version"; exit 1; }
for c in $CIRCUITS; do [ -f "$R1CS_DIR/$c.r1cs" ] || { echo "missing $R1CS_DIR/$c.r1cs"; exit 1; }; done
(cd "$R1CS_DIR" && for c in $CIRCUITS; do
  want=$(node -e 'console.log(require("./r1cs-manifest.json").files[process.argv[1]])' "$c.r1cs")
  [ "$(sha256 "$c.r1cs")" = "$want" ] || { echo "$c.r1cs differs from r1cs-manifest.json"; exit 1; }
done)
echo "ok: ptau, snarkjs $SNARKJS_VERSION and r1cs match the pins"
