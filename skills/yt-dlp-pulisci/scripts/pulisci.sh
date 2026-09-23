#!/bin/bash
set -euo pipefail

DEFAULT="$HOME/Desktop/yt-dlp"
DRY=0
TARGET="$DEFAULT"
CUSTOM=0

usage() {
  echo "Uso: pulisci.sh [--dry-run] [DIR]" >&2
  echo "Cancella la cartella dei download yt-dlp (default: $DEFAULT)." >&2
  exit 2
}

if ! command -v python3 >/dev/null 2>&1; then
  echo "Errore: python3 richiesto per calcolare i path assoluti." >&2
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=1; shift ;;
    -h|--help) usage ;;
    --) shift; break ;;
    -*) echo "Opzione sconosciuta: $1" >&2; usage ;;
    *)
      if [[ "$CUSTOM" -eq 1 ]]; then
        echo "Si può cancellare una sola cartella." >&2
        exit 2
      fi
      TARGET="$1"
      CUSTOM=1
      shift
      ;;
  esac
done

if [[ ! -e "$TARGET" ]]; then
  echo "Niente da cancellare: $TARGET non esiste."
  exit 0
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Rifiutato: $TARGET non è una directory." >&2
  exit 1
fi

REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$TARGET")"
HOME_REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$HOME")"
DEFAULT_REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$DEFAULT")"

forbidden=(
  "$HOME_REAL"
  "/"
  "/Users"
  "$HOME_REAL/Downloads"
  "$HOME_REAL/Desktop"
  "$HOME_REAL/Documents"
  "$HOME_REAL/Library"
  "$HOME_REAL/Movies"
  "$HOME_REAL/Music"
  "$HOME_REAL/Pictures"
)

for blocked in "${forbidden[@]}"; do
  if [[ "$REAL" == "$blocked" ]]; then
    echo "Rifiutato: $REAL è una cartella di sistema o troppo ampia." >&2
    exit 1
  fi
done

case "$REAL" in
  "$HOME_REAL"/*) ;;
  *)
    echo "Rifiutato: $REAL è fuori dalla home." >&2
    exit 1
    ;;
esac

rel="${REAL#"$HOME_REAL"/}"
IFS='/' read -r -a parts <<< "$rel"
if [[ "${#parts[@]}" -lt 2 ]]; then
  echo "Rifiutato: $REAL è troppo vicina alla home." >&2
  exit 1
fi

if [[ "$REAL" != "$DEFAULT_REAL" ]]; then
  case "$REAL" in
    *yt-dlp*) ;;
    *)
      echo "Rifiutato: le cartelle diverse da $DEFAULT devono contenere 'yt-dlp' nel percorso." >&2
      exit 1
      ;;
  esac
fi

if [[ "$DRY" -eq 1 ]]; then
  echo "Dry-run: cancellerei $REAL"
  exit 0
fi

rm -rf -- "$REAL"
echo "Cancellata: $REAL"
