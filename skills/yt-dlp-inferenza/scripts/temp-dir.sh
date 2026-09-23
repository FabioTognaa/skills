#!/bin/bash
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  echo "Errore: python3 richiesto per calcolare il path assoluto." >&2
  exit 1
fi

base=""
for candidate in "${TMPDIR:-}" "${TEMP:-}" "${TMP:-}"; do
  if [[ -n "$candidate" && -d "$candidate" ]]; then
    base="${candidate%/}"
    break
  fi
done

if [[ -z "$base" && -d /tmp ]]; then
  base="/tmp"
fi

if [[ -z "$base" ]]; then
  base="$HOME/.cache"
  mkdir -p "$base"
fi

dir="$base/yt-dlp-inferenza"
mkdir -p "$dir"
python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$dir"
