#!/usr/bin/env bash
set -e

echo "🚀 Starting threeDotsFiles bootstrap..."

# Ask for sudo upfront
sudo -v

# 1. Update repositories and install git + base-devel
echo "📦 Updating repositories and installing base dependencies (git, base-devel)..."
sudo pacman -Sy --needed --noconfirm git base-devel curl

# 2. Clone the repo in the HOME directory
REPO_DIR="$HOME/threeDotsFiles"
if [ ! -d "$REPO_DIR" ]; then
    echo "📥 Cloning the repository..."
    git clone https://github.com/Soyt0ny/threeDotsFiles.git "$REPO_DIR"
else
    echo "✅ Repository already exists at $REPO_DIR. Updating..."
    cd "$REPO_DIR" && git pull origin main
fi

# 3. Execute the setup automatically
echo "⚙️ Running setup.sh..."
cd "$REPO_DIR"
exec ./setup.sh --yes
