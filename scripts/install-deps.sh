#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}📦 $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; exit 1; }

echo "========================================="
echo "  Installing Dependencies"
echo "========================================="

# Verificar Homebrew
if ! command -v brew &> /dev/null; then
    info "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    info "Homebrew ya está instalado: $(brew --version | head -1)"
fi

# Actualizar Homebrew
info "Actualizando Homebrew..."
brew update

# Instalar paquetes
PACKAGES=(
    fd
    rg
    bat
    tree
    fzf
)

for pkg in "${PACKAGES[@]}"; do
    if ! brew list "$pkg" &> /dev/null; then
        info "Instalando $pkg..."
        brew install "$pkg"
    else
        info "$pkg ya está instalado"
    fi
done

# Instalar configuración de fzf (keybindings + completions)
info "Configurando fzf..."
FZF_PREFIX=$(brew --prefix fzf)
if [ -f "$FZF_PREFIX/install" ]; then
    "$FZF_PREFIX/install" --all --no-bash --no-fish
else
    warn "fzf install script no encontrado en $FZF_PREFIX"
fi

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh ya está instalado"
fi

echo ""
info "✅ Dependencias instaladas correctamente"
