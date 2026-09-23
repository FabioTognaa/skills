#!/bin/bash
set -euo pipefail

# install.sh – installa tutte le skill in ~/.cursor/skills/
# Uso: ./install.sh

SKILL_DIR="${SKILL_DIR:-$HOME/.cursor/skills}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$REPO_DIR/skills" ]]; then
  echo "Errore: non trovo la cartella skills/ in $REPO_DIR" >&2
  exit 1
fi

mkdir -p "$SKILL_DIR"

installed=0
for skill_path in "$REPO_DIR"/skills/*; do
  if [[ ! -d "$skill_path" ]]; then
    continue
  fi

  name="$(basename "$skill_path")"
  if [[ ! -f "$skill_path/SKILL.md" ]]; then
    echo "Saltato: $name (manca SKILL.md)" >&2
    continue
  fi

  target="$SKILL_DIR/$name"
  if [[ -d "$target" ]]; then
    rm -rf "$target"
  fi

  cp -R "$skill_path" "$target"
  chmod -R u+rwX "$target"
  echo "Installato: $name"
  installed=$((installed + 1))
done

echo ""
echo "Installate $installed skill in $SKILL_DIR"
