#!/usr/bin/env bash
set -e

echo "🚀 Iniciando bootstrap de threeDotsFiles..."

# Pedir sudo al principio
sudo -v

# 1. Actualizar repositorios e instalar git + base-devel
echo "📦 Actualizando repositorios e instalando dependencias base (git, base-devel)..."
sudo pacman -Sy --needed --noconfirm git base-devel curl

# 2. Clonar el repo en el HOME
REPO_DIR="$HOME/threeDotsFiles"
if [ ! -d "$REPO_DIR" ]; then
    echo "📥 Clonando el repositorio..."
    git clone https://github.com/Soyt0ny/threeDotsFiles.git "$REPO_DIR"
else
    echo "✅ El repositorio ya existe en $REPO_DIR. Actualizando..."
    cd "$REPO_DIR" && git pull origin main
fi

# 3. Ejecutar el setup automáticamente
echo "⚙️ Ejecutando setup.sh..."
cd "$REPO_DIR"
exec ./setup.sh --yes
