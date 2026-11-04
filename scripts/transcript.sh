#!/usr/bin/env bash
# Writes transcript.sha256sums: the SHA-256 of every file of the chain that is not a verify log
# (zkeys, statements, contribution lists, contribute logs) and of the beacon record, sorted.
# import_zkey records the SHA-256 of this file as the transcript hash.
#   scripts/transcript.sh CHAIN_DIR... > transcript.sha256sums     (run from the repository root)
source "$(dirname "$0")/env.sh"
cd "$ROOT"
{
  (cd chain && find "$@" -type f ! -name 'verify.*' | sort | xargs shasum -a 256)
  (cd logs/beacon-final && shasum -a 256 beacon.json block-*.json | sed 's#  #  beacon-final/#')
}
