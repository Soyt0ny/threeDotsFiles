#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=true

usage() {
  cat <<'EOF'
Usage:
  ./install.sh            # default dry-run
  ./install.sh --dry-run  # explicit dry-run
  ./install.sh --apply    # apply changes
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --apply) DRY_RUN=false ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[error] Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

MODE="apply"
if [[ "$DRY_RUN" == true ]]; then
  MODE="dry-run"
fi

echo "== threeDotsFiles bootstrap =="
echo "Mode: $MODE"

"$ROOT_DIR/scripts/checks.sh"

echo
echo "== Package install guidance =="
echo "Official packages list: $ROOT_DIR/packages/official.txt"
echo "AUR packages list:      $ROOT_DIR/packages/aur.txt"
echo "No package installation is executed by this script."
echo "Suggested commands:"
echo "  sudo pacman -S --needed \\"
sed 's/^/    /' "$ROOT_DIR/packages/official.txt"
echo "  yay -S --needed \\"
sed 's/^/    /' "$ROOT_DIR/packages/aur.txt"

echo
"$ROOT_DIR/scripts/backup.sh" --mode "$MODE"
"$ROOT_DIR/scripts/link.sh" --mode "$MODE"

echo
echo "Done."
