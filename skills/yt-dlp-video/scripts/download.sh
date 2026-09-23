#!/bin/bash
set -euo pipefail

URL="${1:-}"
HEIGHT="${2:-best}"
OUTDIR="${3:-$HOME/Desktop/yt-dlp/video}"

if [[ -z "$URL" ]]; then
  echo "Uso: $0 <URL> [altezza] [outdir]" >&2
  echo "  altezza: best, 1080, 720, 480, ... (default: best)" >&2
  exit 1
fi

for cmd in yt-dlp ffmpeg; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Errore: comando mancante '$cmd'. Installalo e riprova." >&2
    exit 1
  fi
done

if [[ "$HEIGHT" == "best" ]]; then
  FORMAT="bv*+ba/b"
else
  FORMAT="bv*[height<=${HEIGHT}]+ba/b[height<=${HEIGHT}] / b[height<=${HEIGHT}]"
fi

mkdir -p "$OUTDIR"

yt-dlp \
  -f "$FORMAT" \
  -P "$OUTDIR" \
  -o "%(uploader)s/%(title)s [%(id)s].%(ext)s" \
  "$URL"
