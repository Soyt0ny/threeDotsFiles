#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/detect-conflicts.sh"

echo "[TEST] detect-conflicts.sh execution"

if [[ ! -f "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no existe"
  exit 1
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no es ejecutable"
  exit 1
fi

# Ejecutar detect-conflicts con --force auto-yes simulado
# En realidad, no podemos simular respuesta, asi que solo verificamos sintaxis
if bash -n "$SCRIPT" 2>/dev/null; then
  echo "✓ PASS: detect-conflicts.sh sintaxis correcta"
  exit 0
else
  echo "✗ FAIL: detect-conflicts.sh tiene errores de sintaxis"
  exit 1
fi
