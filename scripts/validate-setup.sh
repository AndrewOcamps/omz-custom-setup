#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

check_count=0
pass_count=0
fail_count=0
warn_count=0

check() {
    ((check_count++))
    if eval "$2" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1"
        ((pass_count++))
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        ((fail_count++))
        return 1
    fi
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((warn_count++))
}

section() {
    echo ""
    echo -e "${CYAN}$1${NC}"
}

echo "========================================="
echo "  OMZ Custom Setup - Validation Script"
echo "========================================="

# ========================
# System
# ========================
section "📦 System"
check "Homebrew installed" "command -v brew"
check "Zsh installed" "command -v zsh"
check "Oh My Zsh installed" "test -d $HOME/.oh-my-zsh"

# ========================
# Shell Configuration
# ========================
section "🐚 Shell Configuration"
check "Powerlevel10k theme set" "grep -q 'ZSH_THEME=\"powerlevel10k/powerlevel10k\"' ~/.zshrc"
check ".p10k.zsh exists" "test -f ~/.p10k.zsh"
check "P10k mode is nerdfont-v3" "grep -q 'POWERLEVEL9K_MODE=nerdfont-v3' ~/.p10k.zsh"
check "Instant prompt enabled" "grep -q 'p10k-instant-prompt' ~/.zshrc"
check "FZF_CTRL_T_OPTS configured" "grep -q 'FZF_CTRL_T_OPTS' ~/.zshrc"
check "FZF_CTRL_R_OPTS configured" "grep -q 'FZF_CTRL_R_OPTS' ~/.zshrc"
check "FZF_ALT_C_OPTS configured" "grep -q 'FZF_ALT_C_OPTS' ~/.zshrc"

# ========================
# Plugins
# ========================
section "🔌 Plugins"
check "Plugin: git in .zshrc" "grep -q 'plugins=.*git' ~/.zshrc"
check "Plugin: zsh-completions in .zshrc" "grep -q 'zsh-completions' ~/.zshrc"
check "Plugin: zsh-autosuggestions in .zshrc" "grep -q 'zsh-autosuggestions' ~/.zshrc"
check "Plugin: zsh-syntax-highlighting in .zshrc" "grep -q 'zsh-syntax-highlighting' ~/.zshrc"
check "Plugin: fzf in .zshrc" "grep -q 'plugins=.*fzf' ~/.zshrc"
check "Plugin dir: zsh-completions" "test -d $HOME/.oh-my-zsh/custom/plugins/zsh-completions"
check "Plugin dir: zsh-autosuggestions" "test -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check "Plugin dir: zsh-syntax-highlighting" "test -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# ========================
# Binaries
# ========================
section "🔧 Binaries"
check "fd installed" "command -v fd"
check "ripgrep (rg) installed" "command -v rg"
check "bat installed" "command -v bat"
check "tree installed" "command -v tree"
check "fzf installed" "command -v fzf"

# ========================
# Fonts
# ========================
section "🔤 Fonts"
if command -v fc-list &> /dev/null; then
    check "Nerd Font installed (fc-list)" "fc-list | grep -qi 'JetBrains.*Nerd'"
elif command -v system_profiler &> /dev/null; then
    check "Nerd Font installed (system_profiler)" "system_profiler SPFontsDataType 2>/dev/null | grep -qi 'JetBrains.*Nerd'"
else
    warn "No se pudieron verificar fuentes"
    warn "Instala JetBrains Mono Nerd Font desde: https://www.nerdfonts.com"
fi

# ========================
# iTerm2
# ========================
section "💻 iTerm2"
check "iTerm2 installed" "test -d /Applications/iTerm.app"

if command -v plutil &> /dev/null && [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
    # Verificar si algún perfil tiene Option Key = Esc+ (valor 2)
    OPTION_KEY_OK=$(plutil -p "$HOME/Library/Preferences/com.googlecode.iterm2.plist" 2>/dev/null | grep -A1 "Option Key Sends" | grep -c "=> 2" || true)
    if [ "$OPTION_KEY_OK" -gt 0 ]; then
        check "Option Key = Esc+ (para Alt+C)" "true"
    else
        check "Option Key = Esc+ (para Alt+C)" "false"
        warn "  → Ejecuta: make iterm2"
        warn "  → O cambia manualmente: iTerm2 → Preferences → Profiles → Keys → Left Option Key → Esc+"
    fi
else
    warn "No se pudo verificar Option Key (iTerm2 plist no encontrado)"
fi

# ========================
# Summary
# ========================
echo ""
echo "========================================="
echo -e "Results: ${GREEN}${pass_count} passed${NC}, ${RED}${fail_count} failed${NC}, ${YELLOW}${warn_count} warnings${NC}"
echo "========================================="

if [ $fail_count -eq 0 ]; then
    echo -e "\n${GREEN}✅ Setup is complete! Run: source ~/.zshrc${NC}"
else
    echo -e "\n${YELLOW}⚠️  Some items need attention. See above for details.${NC}"
fi

exit $fail_count
