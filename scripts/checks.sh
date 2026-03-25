#!/usr/bin/env bash
set -euo pipefail

status=0

check_cmd() {
  local cmd="$1"
  local label="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    local path
    path="$(command -v "$cmd")"
    echo "[ok] $label found: $path"
  else
    echo "[warn] $label missing"
    status=1
  fi
}

echo "== Environment checks =="
check_cmd pacman "pacman (required for Arch-family)"

if command -v yay >/dev/null 2>&1; then
  echo "[ok] yay (AUR helper) found: $(command -v yay)"
else
  echo "[info] yay not found (optional, needed for AUR packages only)"
fi

if [[ "$status" -ne 0 ]]; then
  echo "[error] Required tooling missing. Fix prerequisites before --apply."
  exit "$status"
fi

echo "Checks complete."
