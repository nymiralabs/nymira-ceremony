#!/usr/bin/env bash
# Contributor: contribute.sh PREVIOUS_DIR OUTPUT_DIR "name or key id"
# Reads request.zkey and withdrawal.zkey from PREVIOUS_DIR, writes the contributed pair to OUTPUT_DIR.
# Entropy comes from this machine only (the OS random source, shown to nobody). Nobody asks you for it.
source "$(dirname "$0")/env.sh"
prev=$1; out=$2; name=${3:-anonymous}
mkdir -p "$out"
for c in $CIRCUITS; do
  entropy=$(head -c 64 /dev/urandom | od -An -tx1 | tr -d ' \n')
  "$SNARKJS" zkey contribute "$prev/$c.zkey" "$out/$c.zkey" --name="$name" -e="$entropy" | tee "$out/$c.contribute.log"
done
unset entropy
{
  echo "started_from_request_sha256 $(sha256 "$prev/request.zkey")"
  echo "started_from_withdrawal_sha256 $(sha256 "$prev/withdrawal.zkey")"
  echo "output_request_sha256 $(sha256 "$out/request.zkey")"
  echo "output_withdrawal_sha256 $(sha256 "$out/withdrawal.zkey")"
} | tee "$out/statement.txt"
