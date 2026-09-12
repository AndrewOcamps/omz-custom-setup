.PHONY: all install deps plugins theme shell iterm2 validate clean help

SHELL := /bin/bash

all: install  ## Instalación completa

install: deps plugins theme shell iterm2  ## Ejecutar todos los pasos
	@echo ""
	@echo "✅ Instalación completa."
	@echo "   Recarga tu shell: source ~/.zshrc"
	@echo "   O abre una nueva terminal."

deps:  ## Instalar dependencias Homebrew
	@./scripts/install-deps.sh

plugins:  ## Instalar plugins Oh My Zsh
	@./scripts/install-plugins.sh

theme:  ## Instalar Powerlevel10k
	@echo "📦 Instalando Powerlevel10k..."
	@test -d $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k || \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k
	@echo "✅ Powerlevel10k instalado"

shell:  ## Copiar configuraciones de shell
	@echo "📋 Copiando configuraciones..."
	@cp config/.zshrc $(HOME)/.zshrc
	@cp config/.p10k.zsh $(HOME)/.p10k.zsh
	@echo "✅ Configuraciones copiadas"

iterm2:  ## Configurar iTerm2
	@./scripts/configure-iterm2.sh

validate:  ## Validar instalación
	@./scripts/validate-setup.sh

clean:  ## Limpiar cache de completions
	@rm -f $(HOME)/.zcompdump*
	@echo "✅ Cache limpiado. Ejecuta: compinit"

help:  ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
