#!/usr/bin/env bash
set -euo pipefail

# Collega le skill di questo repo alle cartelle utente degli agenti.
# Ogni voce è un symlink verso il checkout: un git pull aggiorna i file.
#
# Destinazioni:
#   ~/.claude/skills   Claude Code
#   ~/.agents/skills   Cursor, Codex, OpenCode e gli altri harness Agent Skills
#
# Dopo i link, rimuove le copie vecchie di queste skill in ~/.cursor/skills.
# Il resto di quella cartella non viene toccato. I link vengono creati prima:
# se un link fallisce, le copie in Cursor restano.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")
CURSOR_COPIES=(yt-dlp-audio yt-dlp-video yt-dlp-inferenza yt-dlp-pulisci)

if [[ ! -d "$REPO/skills" ]]; then
  echo "Errore: non trovo la cartella skills/ in $REPO" >&2
  exit 1
fi

names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -print0)

if [[ ${#names[@]} -eq 0 ]]; then
  echo "Errore: nessuna skill con SKILL.md in $REPO/skills" >&2
  exit 1
fi

for DEST in "${DESTS[@]}"; do
  if [[ -L "$DEST" ]]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "Errore: $DEST è un symlink dentro questo repo ($resolved)." >&2
        echo "Rimuovilo (rm \"$DEST\") e rilancia: lo script lo ricrea come cartella vera." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [[ -e "$target" && ! -L "$target" ]]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "collegato $name -> $src ($DEST)"
  done
done

cursor_root="$HOME/.cursor/skills"
if [[ -L "$cursor_root" ]]; then
  resolved="$(readlink -f "$cursor_root")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "Errore: $cursor_root è un symlink dentro questo repo ($resolved)." >&2
      echo "Non rimuovo le skill da lì: cancellerei i sorgenti." >&2
      exit 1
      ;;
  esac
fi

if [[ -d "$cursor_root" ]]; then
  for name in "${CURSOR_COPIES[@]}"; do
    target="$cursor_root/$name"
    if [[ -L "$target" || -e "$target" ]]; then
      rm -rf "$target"
      echo "rimosso $target"
    fi
  done
fi
