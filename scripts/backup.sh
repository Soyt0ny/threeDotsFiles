#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="dry-run"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    *)
      echo "[error] Unknown option: $1"
      exit 1
      ;;
  esac
done

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="$HOME/.dotfiles-backup/$timestamp"

declare -a mappings=(
  "$ROOT_DIR/configs/zsh/.zshrc|$HOME/.zshrc"
  "$ROOT_DIR/configs/tmux/.tmux.conf|$HOME/.tmux.conf"
)

backup_target() {
  local target="$1"
  local target_abs
  target_abs="$(readlink -f "$target" 2>/dev/null || printf '%s' "$target")"

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    echo "[skip] No existing target: $target"
    return
  fi

  local relative
  relative="${target#$HOME/}"
  if [[ "$target" == "$HOME" ]]; then
    relative="home-root"
  elif [[ "$target" == "$HOME"/* ]]; then
    :
  else
    relative="external/$(basename "$target")"
  fi

  local dest="$backup_root/$relative"

  if [[ "$MODE" == "dry-run" ]]; then
    echo "[dry-run] backup $target_abs -> $dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  cp -a "$target" "$dest"
  echo "[ok] backed up $target_abs -> $dest"
}

echo "== Backup phase ($MODE) =="
if [[ "$MODE" == "apply" ]]; then
  mkdir -p "$backup_root"
fi

for item in "${mappings[@]}"; do
  target="${item#*|}"
  backup_target "$target"
done
