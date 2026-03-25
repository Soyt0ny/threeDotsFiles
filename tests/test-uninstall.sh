#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/uninstall.sh"

echo "[TEST] uninstall.sh syntax check"

if [[ ! -f "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no existe"
  exit 1
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no es ejecutable"
  exit 1
fi

if bash -n "$SCRIPT" 2>/dev/null; then
  echo "✓ PASS: uninstall.sh sintaxis correcta"
  exit 0
else
  echo "✗ FAIL: uninstall.sh tiene errores de sintaxis"
  exit 1
fi
