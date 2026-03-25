#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[TEST] setup.sh --dry-run --yes"

# Run with timeout to avoid hanging on prompts
if timeout 30s "$ROOT_DIR/setup.sh" --dry-run --yes >/dev/null 2>&1; then
  echo "✓ PASS: setup.sh --dry-run --yes ejecuto correctamente"
  exit 0
else
  exit_code=$?
  if [[ "$exit_code" -eq 124 ]]; then
    echo "✗ FAIL: setup.sh --dry-run --yes timeout (posible prompt bloqueante)"
  else
    echo "✗ FAIL: setup.sh --dry-run --yes fallo con exit code $exit_code"
  fi
  exit 1
fi
