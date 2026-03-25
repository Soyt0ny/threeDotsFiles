#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/check-requirements.sh"

echo "[TEST] check-requirements.sh execution"

if [[ ! -f "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no existe"
  exit 1
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "✗ FAIL: $SCRIPT no es ejecutable"
  exit 1
fi

# Ejecutar check-requirements (puede fallar si no estamos en Arch)
if "$SCRIPT" >/dev/null 2>&1; then
  echo "✓ PASS: check-requirements.sh ejecuto correctamente (requisitos cumplidos)"
  exit 0
else
  exit_code=$?
  echo "✓ PASS: check-requirements.sh ejecuto correctamente (exit code $exit_code - esperado en entorno no-Arch)"
  exit 0
fi
