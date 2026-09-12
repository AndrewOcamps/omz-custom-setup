# OMZ Custom Setup

Configuración personalizada de Oh My Zsh con Powerlevel10k para macOS. IaC-ready para replicar el setup en cualquier Mac.

## Componentes

| Componente | Versión | Descripción |
|------------|---------|-------------|
| iTerm2 | Latest | Terminal emulator |
| Zsh | 5.9+ | Shell |
| Oh My Zsh | Latest | Framework de Zsh |
| Powerlevel10k | Latest | Tema del prompt (lean, 2 lines, nerd font) |
| fzf | 0.74.4+ | Fuzzy finder |

## Dependencias

### Homebrew Packages

| Paquete | Uso |
|---------|-----|
| `fd` | Buscador de archivos (alternativa a find) |
| `rg` | Buscador de contenido (ripgrep) |
| `bat` | Cat con syntax highlighting (para preview de fzf) |
| `tree` | Visualización de directorios (para preview de fzf) |
| `fzf` | Fuzzy finder |

### Fuentes

- **JetBrains Mono Nerd Font** (o cualquier Nerd Font v3)
  - Descargar desde: https://www.nerdfonts.com
  - Instalar y seleccionar en iTerm2: Preferences → Profiles → Text → Font

### Plugins Oh My Zsh

| Plugin | Tipo | Descripción |
|--------|------|-------------|
| `git` | Built-in | Comandos de git |
| `zsh-completions` | Custom | Completado extendido para muchos comandos |
| `zsh-autosuggestions` | Custom | Sugerencias basadas en historial (tipo Fish) |
| `zsh-syntax-highlighting` | Custom | Coloreado de comandos en tiempo real |
| `fzf` | Built-in | Integración de fzf con Zsh |

## Keybindings

| Atajo | Función | Preview |
|-------|---------|---------|
| `Ctrl+T` | Buscar archivos | `bat` (syntax highlighting) |
| `Ctrl+R` | Buscar historial | Contenido del comando |
| `⌥+C` | Buscar directorios | `tree` (estructura) |

> **Nota:** En macOS, `Alt+C` se presiona como `⌥+C` (Option+C). Requiere que iTerm2 tenga "Left Option Key" configurado a **Esc+**.

## Instalación

### Instalación automática (IaC)

```bash
git clone https://github.com/AndrewOcamps/omz-custom-setup.git
cd omz-custom-setup
make install
```

### Instalación manual (paso a paso)

#### 1. Instalar Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2. Instalar dependencias

```bash
brew install fd rg bat tree fzf
$(brew --prefix)/opt/fzf/install
```

#### 3. Instalar Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 4. Instalar Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

#### 5. Instalar plugins custom

```bash
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### 6. Copiar configuraciones

```bash
cp config/.zshrc ~/.zshrc
cp config/.p10k.zsh ~/.p10k.zsh
```

#### 7. Configurar iTerm2

1. Instalar iTerm2 desde https://iterm2.com
2. Instalar JetBrains Mono Nerd Font
3. En Preferences → Profiles → Keys → Left Option Key → **Esc+**
4. En Preferences → Profiles → Text → Font → **JetBrainsMonoNFM-Bold 14**

#### 8. Configurar Powerlevel10k

```bash
source ~/.zshrc
p10k configure
```

## Comandos Make

```bash
make help       # Mostrar ayuda
make install    # Instalación completa
make deps       # Solo dependencias Homebrew
make plugins    # Solo plugins Oh My Zsh
make theme      # Solo Powerlevel10k
make shell      # Copiar configs de shell
make iterm2     # Configurar iTerm2 (Option Key → Esc+)
make validate   # Validar instalación
make clean      # Limpiar cache de completions
```

## Estructura del repositorio

```
omz-custom-setup/
├── README.md                    # Esta documentación
├── Makefile                     # Orquestador IaC
├── scripts/
│   ├── install-deps.sh          # Instalar dependencias Homebrew
│   ├── install-plugins.sh       # Instalar plugins Oh My Zsh
│   ├── configure-iterm2.sh      # Configurar iTerm2 vía plist
│   └── validate-setup.sh        # Script de validación
├── config/
│   ├── .zshrc                   # Configuración Zsh
│   └── .p10k.zsh               # Configuración Powerlevel10k
└── .gitignore
```

## Archivos de configuración

| Archivo | Propósito |
|---------|-----------|
| `~/.zshrc` | Configuración principal de Zsh |
| `~/.p10k.zsh` | Configuración de Powerlevel10k (1719 líneas) |
| `~/.oh-my-zsh/custom/plugins/` | Plugins personalizados |
| `~/Library/Preferences/com.googlecode.iterm2.plist` | Configuración de iTerm2 |

## Verificar instalación

```bash
./scripts/validate-setup.sh
# o
make validate
```

## Troubleshooting

### Tab no funciona después de instalar plugins

```bash
rm -f ~/.zcompdump*
compinit
source ~/.zshrc
```

### Alt+C produce "ç" en lugar de abrir fzf

Cambiar en iTerm2: Preferences → Profiles → Keys → Left Option Key → **Esc+**

### Preview de fzf no se muestra

Verificar que `bat` y `tree` estén instalados:

```bash
which bat tree
```

### Powerlevel10k muestra caracteres raros

Verificar que la fuente Nerd Font esté instalada y seleccionada en iTerm2.
Ejecutar `p10k configure` para reconfigurar.
