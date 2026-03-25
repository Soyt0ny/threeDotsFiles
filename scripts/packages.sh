#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/logging.sh"
MODE="dry-run"
LAYERS=""
YAY_BOOTSTRAP_TMP=""
AUTO_YES=false
INCREMENTAL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    --layers)
      LAYERS="$2"
      shift 2
      ;;
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    --incremental)
      INCREMENTAL=true
      shift
      ;;
    *)
      log_error "Unknown option: $1"
      exit 1
      ;;
  esac
done

official_file_legacy="$ROOT_DIR/packages/official.txt"
aur_file_legacy="$ROOT_DIR/packages/aur.txt"

read_packages() {
  local file="$1"
  local -n out_ref="$2"
  out_ref=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line##+([[:space:]])}"
    line="${line%%+([[:space:]])}"
    [[ -z "$line" ]] && continue
    out_ref+=("$line")
  done <"$file"
}

append_packages_from_file() {
  local file="$1"
  local -n out_ref="$2"
  local -a tmp=()

  [[ -f "$file" ]] || return 0

  read_packages "$file" tmp
  if ((${#tmp[@]} > 0)); then
    out_ref+=("${tmp[@]}")
  fi
}

dedupe_packages() {
  local -n in_ref="$1"
  local -n out_ref="$2"
  local pkg
  local -A seen=()
  out_ref=()

  for pkg in "${in_ref[@]}"; do
    if [[ -z "${seen[$pkg]:-}" ]]; then
      out_ref+=("$pkg")
      seen[$pkg]=1
    fi
  done
}

collect_packages_by_layers() {
  local csv="$1"
  local layer
  local -a requested_layers=()
  local -a all_official=()
  local -a all_aur=()

  IFS=',' read -r -a requested_layers <<<"$csv"

  for layer in "${requested_layers[@]}"; do
    layer="${layer//[[:space:]]/}"
    [[ -z "$layer" ]] && continue

    append_packages_from_file "$ROOT_DIR/packages/layers/${layer}-official.txt" all_official
    append_packages_from_file "$ROOT_DIR/packages/layers/${layer}-aur.txt" all_aur
  done

  dedupe_packages all_official official_packages
  dedupe_packages all_aur aur_packages
}

run_or_preview() {
  local label="$1"
  shift

  if [[ "$MODE" == "dry-run" ]]; then
    log_info "dry-run: $label"
    printf '          %q ' "$@"
    printf '\n'
    return
  fi

  log_step "$label"
  "$@"
}

cleanup_bootstrap_tmp() {
  if [[ -n "$YAY_BOOTSTRAP_TMP" && -d "$YAY_BOOTSTRAP_TMP" ]]; then
    rm -rf "$YAY_BOOTSTRAP_TMP"
  fi
}

bootstrap_yay() {
  if command -v yay >/dev/null 2>&1; then
    log_success "yay already available: $(command -v yay)"
    return 0
  fi

  if [[ "$MODE" == "dry-run" ]]; then
    log_info "dry-run: yay missing; would bootstrap AUR helper"
    log_info "dry-run: sudo pacman -S --needed --noconfirm base-devel git"
    log_info "dry-run: tmpdir=\$(mktemp -d)"
    log_info "dry-run: git clone https://aur.archlinux.org/yay-bin.git \"\$tmpdir/yay-bin\""
    log_info "dry-run: (cd \"\$tmpdir/yay-bin\" && makepkg -si --noconfirm)"
    log_info "dry-run: rm -rf \"\$tmpdir\""
    return 0
  fi

  log_info "yay missing; attempting automatic bootstrap"

  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    log_warn "Running as root; skipping yay bootstrap because makepkg must run as non-root user"
    return 1
  fi

  log_step "Installing bootstrap prerequisites"
  if ! sudo pacman -S --needed --noconfirm base-devel git; then
    log_warn "Failed installing bootstrap prerequisites; skipping AUR installs"
    return 1
  fi

  YAY_BOOTSTRAP_TMP="$(mktemp -d)"
  trap cleanup_bootstrap_tmp EXIT

  log_step "Cloning yay-bin AUR repository"
  if ! git clone https://aur.archlinux.org/yay-bin.git "$YAY_BOOTSTRAP_TMP/yay-bin"; then
    log_warn "Failed cloning yay-bin; skipping AUR installs"
    return 1
  fi

  log_step "Building and installing yay-bin"
  if ! (cd "$YAY_BOOTSTRAP_TMP/yay-bin" && makepkg -si --noconfirm); then
    log_warn "Failed building yay-bin; skipping AUR installs"
    return 1
  fi

  if command -v yay >/dev/null 2>&1; then
    log_success "yay installed successfully: $(command -v yay)"
    return 0
  fi

  log_warn "yay bootstrap finished but binary is not in PATH; skipping AUR installs"
  return 1
}

shopt -s extglob

declare -a official_packages=()
declare -a aur_packages=()

if [[ -n "$LAYERS" ]]; then
  collect_packages_by_layers "$LAYERS"
else
  read_packages "$official_file_legacy" official_packages
  read_packages "$aur_file_legacy" aur_packages
fi

printf '\n'
log_step "Package phase ($MODE)"
log_info "Auto-confirm: $AUTO_YES"
log_info "Incremental: $INCREMENTAL"
if [[ -n "$LAYERS" ]]; then
  log_info "Layer package manifests: $LAYERS"
else
  log_info "Official list: $official_file_legacy"
  log_info "AUR list:      $aur_file_legacy"
fi

# Filter packages if incremental mode
if [[ "$INCREMENTAL" == true ]]; then
  declare -a missing_official=()
  declare -a missing_aur=()
  
  log_info "Modo incremental: verificando paquetes ya instalados..."
  
  # Check official packages
  for pkg in "${official_packages[@]}"; do
    if pacman -Q "$pkg" >/dev/null 2>&1; then
      : # Already installed
    else
      missing_official+=("$pkg")
    fi
  done
  
  # Check AUR packages
  for pkg in "${aur_packages[@]}"; do
    if pacman -Q "$pkg" >/dev/null 2>&1; then
      : # Already installed
    else
      missing_aur+=("$pkg")
    fi
  done
  
  installed_official=$((${#official_packages[@]} - ${#missing_official[@]}))
  installed_aur=$((${#aur_packages[@]} - ${#missing_aur[@]}))
  
  log_info "Paquetes oficiales ya instalados: $installed_official"
  log_info "Paquetes oficiales faltantes: ${#missing_official[@]}"
  log_info "Paquetes AUR ya instalados: $installed_aur"
  log_info "Paquetes AUR faltantes: ${#missing_aur[@]}"
  
  official_packages=("${missing_official[@]}")
  aur_packages=("${missing_aur[@]}")
fi

if ((${#official_packages[@]} > 0)); then
  log_info "Official packages (${#official_packages[@]}): ${official_packages[*]}"
  run_or_preview "Installing official packages with pacman" \
    sudo pacman -S --needed --noconfirm "${official_packages[@]}"
else
  log_info "No official packages declared"
fi

if ((${#aur_packages[@]} == 0)); then
  log_info "No AUR packages declared"
  exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
  if ! bootstrap_yay; then
    log_warn "Pending AUR packages: ${aur_packages[*]}"
    exit 0
  fi
fi

if command -v yay >/dev/null 2>&1; then
  log_info "AUR packages (${#aur_packages[@]}): ${aur_packages[*]}"
  run_or_preview "Installing AUR packages with yay" \
    yay -S --needed --noconfirm "${aur_packages[@]}"
else
  log_warn "AUR packages requested but yay is still unavailable"
  log_warn "Pending AUR packages: ${aur_packages[*]}"
fi
