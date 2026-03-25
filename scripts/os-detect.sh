#!/usr/bin/env bash
# OS detection abstraction

detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    
    # Convert identifiers to lowercase for safety
    local os_id="${ID:-}"
    local os_id_like="${ID_LIKE:-}"
    
    if [[ "$os_id" == *"arch"* || "$os_id_like" == *"arch"* || "$os_id" == "manjaro" || "$os_id" == "endeavouros" ]]; then
      echo "arch"
    elif [[ "$os_id" == *"debian"* || "$os_id_like" == *"debian"* || "$os_id" == *"ubuntu"* || "$os_id_like" == *"ubuntu"* || "$os_id" == *"parrot"* || "$os_id" == *"kali"* || "$os_id" == *"linuxmint"* || "$os_id" == *"pop"* ]]; then
      echo "debian"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

sys_install() {
  local os
  os="$(detect_os)"
  local -a packages=("$@")
  
  if [ "${#packages[@]}" -eq 0 ]; then
    return 0
  fi

  case "$os" in
    arch)
      sudo pacman -S --needed --noconfirm "${packages[@]}"
      ;;
    debian)
      sudo apt-get update -y
      sudo apt-get install -y "${packages[@]}"
      ;;
    *)
      echo "Unsupported OS for sys_install: $os" >&2
      return 1
      ;;
  esac
}
