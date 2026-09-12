#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

info() { echo -e "${GREEN}📦 $1${NC}"; }
ok() { echo -e "${GREEN}✓${NC} $1"; }

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "========================================="
echo "  Installing Oh My Zsh Plugins"
echo "========================================="

# Verificar que Oh My Zsh esté instalado
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}✗ Oh My Zsh no está instalado. Ejecuta 'make deps' primero.${NC}"
    exit 1
fi

# Lista de plugins: repo|nombre
plugins=(
    "https://github.com/zsh-users/zsh-completions|zsh-completions"
    "https://github.com/zsh-users/zsh-autosuggestions|zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting|zsh-syntax-highlighting"
)

for plugin in "${plugins[@]}"; do
    IFS='|' read -r repo name <<< "$plugin"
    if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
        info "Instalando $name..."
        git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$name"
    else
        ok "$name ya está instalado"
    fi
done

echo ""
info "✅ Plugins instalados correctamente"
echo "   Plugins: zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting"
