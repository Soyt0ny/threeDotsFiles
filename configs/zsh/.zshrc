# threeDotsFiles baseline .zshrc

export EDITOR="nvim"
export VISUAL="nvim"

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias gs='git status -sb'
alias v='nvim'

cpprun() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: cpprun <file.cpp> [extra g++ args...]"
    return 1
  fi

  local src="$1"
  shift
  local out="${src%.*}.out"

  g++ -std=c++20 -O2 -Wall -Wextra "$src" -o "$out" "$@" && "$out"
}
