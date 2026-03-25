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

log_info "Applying project dotfiles"

preserve_mode="backup"
if [[ "$SKIP_BACKUP" == true ]]; then
  preserve_mode="skip"
fi

declare -a install_flags=(--preserve "$preserve_mode")
if [[ "$AUTO_YES" == true ]]; then
  install_flags+=(--yes)
fi

if [[ "$MODE" == "dry-run" ]]; then
  "$ROOT_DIR/install.sh" --dry-run --layers dotfiles-core "${install_flags[@]}"
else
  "$ROOT_DIR/install.sh" --apply --layers dotfiles-core "${install_flags[@]}"
fi
