#!/usr/bin/env bash
# Patches OpenSSL sources with BTLS (STB 34.101.65, STB 34.101.90).
# Usage: apply.sh <openssl source root> [--dry-run|--check|--revert]
set -e
bpatch=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
openssl=$(cd "$1" && pwd)
mode=${2:---apply}

if [[ $mode == --apply ]]; then
  # VERSION.dat appeared in OpenSSL 3.0
  if [[ -f $openssl/VERSION.dat ]]; then
    btls=$bpatch/btls
    grep -q '^# bee2evp NIDs' $openssl/crypto/objects/objects.txt ||
      cat $btls/objects.txt >> $openssl/crypto/objects/objects.txt
  else
    btls=$bpatch/btls/legacy
  fi
  cp $btls/btls.c $btls/btls.h $openssl/ssl/
fi
python3 $bpatch/patcher.py --root $openssl --rules $bpatch/btls_rules.py $mode
