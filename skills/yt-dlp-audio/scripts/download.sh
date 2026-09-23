#!/bin/bash
set -euo pipefail

URL="${1:-}"
FORMAT="${2:-best}"
OUTDIR="${3:-$HOME/Desktop/yt-dlp}"
QUALITY="${4:-ba/b}"

if [[ -z "$URL" ]]; then
  echo "Uso: $0 <URL> [formato] [outdir] [qualita]" >&2
  echo "  formato: best, mp3, m4a, flac, opus, ... (default: best)" >&2
  echo "  qualita: ba/b (migliore), wa/w (minima), ... (default: ba/b)" >&2
  exit 1
fi

for cmd in yt-dlp ffmpeg; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Errore: comando mancante '$cmd'. Installalo e riprova." >&2
    exit 1
  fi
done

mkdir -p "$OUTDIR"

yt-dlp \
  -f "$QUALITY" \
  -x \
  --audio-format "$FORMAT" \
  -P "$OUTDIR" \
  -o "%(uploader)s/%(title)s [%(id)s].%(ext)s" \
  "$URL"
