#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v shellcheck >/dev/null 2>&1; then
  printf '[error] shellcheck no esta instalado.\n' >&2
  printf '[error] Instalar en Arch/Manjaro: sudo pacman -S shellcheck\n' >&2
  printf '[error] Instalar en Debian/Ubuntu: sudo apt-get install shellcheck\n' >&2
  exit 1
fi

declare -a files=(
  "$ROOT_DIR/setup.sh"
  "$ROOT_DIR/install.sh"
  "$ROOT_DIR/sync.sh"
)

shopt -s nullglob
for file in "$ROOT_DIR"/scripts/*.sh; do
  files+=("$file")
done
for file in "$ROOT_DIR"/scripts/setup/*.sh; do
  files+=("$file")
done
shopt -u nullglob

if ((${#files[@]} == 0)); then
  printf '[warn] No se encontraron scripts para validar.\n'
  exit 0
fi

printf '[step] Ejecutando shellcheck sobre %d scripts\n' "${#files[@]}"
shellcheck "${files[@]}"
printf '[ok] Shell lint completado\n'
