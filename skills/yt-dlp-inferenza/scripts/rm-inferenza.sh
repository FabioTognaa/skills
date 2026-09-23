#!/bin/bash
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  echo "Errore: python3 richiesto per calcolare il path assoluto." >&2
  exit 1
fi

HERE="$(cd "$(dirname "$0")" && pwd)"
DIR="$("$HERE/temp-dir.sh")"
REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$DIR")"
NAME="$(basename "$REAL")"

if [[ "$NAME" != "yt-dlp-inferenza" ]]; then
  echo "Rifiutato: $REAL non è la cartella temporanea dell'inferenza." >&2
  exit 1
fi

case "$REAL" in
  "/"|"/tmp"|"/private/tmp"|"$HOME"|"$HOME/Downloads"|"$HOME/Downloads/yt-dlp"|"$HOME/Desktop"|"$HOME/Desktop/yt-dlp")
    echo "Rifiutato: $REAL è una cartella troppo ampia." >&2
    exit 1
    ;;
esac

if [[ ! -d "$REAL" ]]; then
  echo "Niente da cancellare: $REAL non esiste."
  exit 0
fi

rm -rf -- "$REAL"
echo "Cancellata: $REAL"
