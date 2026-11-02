#!/usr/bin/env bash
# Coordinator: accept.sh PREVIOUS_DIR|init NEW_DIR
# Allowed files in NEW_DIR: request.zkey, withdrawal.zkey, optional *.log, statement.txt, statement.sig*.
# Runs `zkey verify` (whole chain, against the ptau and r1cs), checks that the new log extends the
# parent's by exactly one contribution, and writes verify.<circuit>.log and contributions.<circuit>.txt.
# A pair is rejected only when `zkey verify` fails; the failing log stays public.
source "$(dirname "$0")/env.sh"
prev=$1; new=$2
for f in "$new"/*; do
  case "$(basename "$f")" in
    request.zkey|withdrawal.zkey|*.log|statement.txt|statement.sig*|contributions.*.txt) ;;
    *) echo "file not allowed: $f"; exit 1 ;;
  esac
done
for c in $CIRCUITS; do
  [ -f "$new/$c.zkey" ] || { echo "missing $new/$c.zkey"; exit 1; }
  if ! "$SNARKJS" zkey verify "$R1CS_DIR/$c.r1cs" "$PTAU" "$new/$c.zkey" 2>&1 | sed "s/\x1b\[[0-9;]*m//g" >"$new/verify.$c.log"; then
    echo "zkey verify FAILED for $c, see $new/verify.$c.log"; exit 1
  fi
  grep -qE '^\[INFO\]  snarkJS: ZKey Ok!' "$new/verify.$c.log" || { echo "no ZKey Ok for $c"; exit 1; }
  # one line per contribution, oldest first (verify prints newest first): its number, name and 16-word hash
  awk '/snarkJS: contribution #/ {h=$0; sub(/.*contribution #/,"",h); for(i=0;i<4;i++){getline l; gsub(/^[ \t]+/,"",l); h=h" "l}; print h}' "$new/verify.$c.log" | sort -n >"$new/contributions.$c.txt"
  n=$(wc -l <"$new/contributions.$c.txt" | tr -d ' ')
  if [ "$prev" = init ]; then
    [ "$n" = 0 ] || { echo "$c: initial zkey has $n contributions"; exit 1; }
  else
    pn=$(wc -l <"$prev/contributions.$c.txt" | tr -d ' ')
    [ "$n" = "$((pn + 1))" ] || { echo "$c: $n contributions, parent has $pn"; exit 1; }
    # the parent's contribution hashes are the first ones in the new log
    [ "$pn" = 0 ] || head -n "$pn" "$new/contributions.$c.txt" | cmp -s - "$prev/contributions.$c.txt" \
      || { echo "$c: parent contributions are not a prefix"; exit 1; }
  fi
  echo "$c: ok, $n contributions"
done
