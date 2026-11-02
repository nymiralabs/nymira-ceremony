# Shared settings. Source it; do not run it.
# Needs Node 24 and the snarkjs 0.7.6 install in tools/ (npm ci --offline works once cached).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNARKJS="$ROOT/tools/node_modules/.bin/snarkjs"
PTAU="${PTAU:-$ROOT/inputs/powersOfTau28_hez_final_16.ptau}"
R1CS_DIR="${R1CS_DIR:-$ROOT/r1cs}"
CIRCUITS="request withdrawal"
PTAU_NAME=powersOfTau28_hez_final_16.ptau
PTAU_BYTES=75580568
PTAU_SHA256=1c401abb57c9ce531370f3015c3e75c0892e0f32b8b1e94ace0f6682d9695922
PTAU_BLAKE2B512=6a6277a2f74e1073601b4f9fed6e1e55226917efb0f0db8a07d98ab01df1ccf43eb0e8c3159432acd4960e2f29fe84a4198501fa54c8dad9e43297453efec125
SNARKJS_VERSION=0.7.6
SNARKJS_INTEGRITY=sha512-4uH1xA5JzVU5jaaWS2fXej3+RC6L5Erhr6INTJtUA27du4Elbh4VXCeeRjB4QiwL6N6y7SNKePw5prTxyEf4Zg==
SNARKJS_GIT_COMMIT=9a8f1c0083d18b9b5e18f526cfd729e7259423be
sha256() { shasum -a 256 "$1" | cut -d' ' -f1; }
blake2b512() { python3 -c 'import hashlib,sys;print(hashlib.blake2b(open(sys.argv[1],"rb").read()).hexdigest())' "$1"; }
