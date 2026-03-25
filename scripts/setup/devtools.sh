#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/scripts/logging.sh"

MODE="apply"
AUTO_YES=false
SKIP_BACKUP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    --skip-backup)
      SKIP_BACKUP=true
      shift
      ;;
    *)
      log_error "Unknown option: $1"
      exit 1
      ;;
  esac
done

case "$MODE" in
  apply|dry-run) ;;
  *)
    log_error "Invalid mode: $MODE"
    exit 1
    ;;
esac

log_info "Installing base dev toolchains"

declare -a install_flags=()
if [[ "$AUTO_YES" == true ]]; then
  install_flags+=(--yes)
fi
if [[ "$SKIP_BACKUP" == true ]]; then
  install_flags+=(--preserve skip)
fi

if [[ "$MODE" == "dry-run" ]]; then
  "$ROOT_DIR/install.sh" --dry-run --layers toolchains --incremental "${install_flags[@]}"
else
  "$ROOT_DIR/install.sh" --apply --layers toolchains --incremental "${install_flags[@]}"
fi
