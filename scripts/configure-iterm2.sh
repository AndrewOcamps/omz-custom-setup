#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}💻 $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }

PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

echo "========================================="
echo "  Configuring iTerm2"
echo "========================================="

# Verificar que iTerm2 esté instalado
if [ ! -d /Applications/iTerm.app ]; then
    echo -e "${RED}✗ iTerm2 no está instalado.${NC}"
    echo "  Descárgalo desde: https://iterm2.com"
    exit 1
fi

# Verificar que el plist exista
if [ ! -f "$PLIST" ]; then
    warn "Plist de iTerm2 no encontrado en: $PLIST"
    warn "Abre iTerm2 una vez para generar el plist, luego ejecuta este script nuevamente."
    exit 1
fi

info "Configurando Option Key a Esc+ para Alt+C (fzf)..."

# Cambiar Option Key a Esc+ en todos los perfiles
# Valor 0 = Normal (produce caracteres como ç)
# Valor 2 = Esc+ (envía Escape + carácter, necesario para fzf)
PROFILE_COUNT=$(plutil -p "$PLIST" 2>/dev/null | grep -c '"Name" =>' || true)

if [ "$PROFILE_COUNT" -gt 0 ]; then
    for i in $(seq 0 $((PROFILE_COUNT - 1))); do
        plutil -replace "New Bookmarks.$i.Option Key Sends" -integer 2 "$PLIST" 2>/dev/null || true
    done
    info "Option Key configurado en $PROFILE_COUNT perfil(es)"
else
    warn "No se encontraron perfiles en iTerm2"
fi

echo ""
info "✅ iTerm2 configurado"
echo "   Left Option Key → Esc+"
echo ""
warn "Cierra y abre iTerm2 para aplicar cambios"
