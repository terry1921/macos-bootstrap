#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Terry1921 macOS Bootstrap
# -----------------------------

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${PROJECT_DIR}/Brewfile"

log()  { printf "\n\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m!!\033[0m %s\n" "$*"; }
err()  { printf "\n\033[1;31mxx\033[0m %s\n" "$*"; }

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    err "Este script es solo para macOS."
    exit 1
  fi
}

install_xcode_cli() {
  # Xcode Command Line Tools
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools: OK"
  else
    log "Instalando Xcode Command Line Tools..."
    xcode-select --install || true
    warn "Si apareció un popup, completa la instalación y vuelve a correr el script."
  fi
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew: OK"
  else
    log "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Ensure brew is on PATH for Apple Silicon
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

brew_update() {
  log "Actualizando Homebrew..."
  brew update
}

brew_bundle() {
  if [[ ! -f "${BREWFILE}" ]]; then
    err "No encontré Brewfile en: ${BREWFILE}"
    err "Coloca Brewfile junto a este script."
    exit 1
  fi

  log "Instalando todo desde Brewfile..."
  brew bundle --file "${BREWFILE}"
}

setup_mise() {
  if command -v mise >/dev/null 2>&1; then
    log "mise: OK"

    # Activate mise in shell (zsh)
    local ZSHRC="${HOME}/.zshrc"
    if [[ ! -f "${ZSHRC}" ]]; then
      touch "${ZSHRC}"
    fi

    if ! grep -q 'mise activate zsh' "${ZSHRC}"; then
      log "Configurando mise en ~/.zshrc..."
      {
        echo ""
        echo "# mise (runtime manager)"
        echo 'eval "$(mise activate zsh)"'
      } >> "${ZSHRC}"
    else
      log "mise ya está configurado en ~/.zshrc"
    fi
  else
    warn "mise no está instalado (debería venir por Brewfile)."
  fi
}

setup_zsh_plugins_note() {
  log "Nota rápida sobre zsh:"
  echo " - Ya instalaste plugins por brew (autocomplete, autosuggestions, syntax-highlighting)."
  echo " - Si notas lag, el primer sospechoso suele ser zsh-autocomplete."
}

optional_mas() {
  # Optional App Store installs with mas
  # Requires: brew install mas (agrega "brew \"mas\"" a tu Brewfile si lo quieres)
  if ! command -v mas >/dev/null 2>&1; then
    warn "mas no está instalado. Si quieres Apps del App Store (ej: Xcode), agrega: brew \"mas\" al Brewfile."
    return 0
  fi

  log "mas detectado. (Opcional) Inicia sesión en App Store si no lo has hecho."
  echo " - Abre App Store y loguéate con tu Apple ID."
  echo " - Luego puedes instalar apps con: mas install <app_id>"
  echo "   Ejemplo (Xcode): mas search Xcode"
}

final_message() {
  log "Listo."
  echo "Siguientes pasos recomendados:"
  echo "1) Cierra y abre terminal para que cargue mise."
  echo "2) Verifica runtimes:"
  echo "   - node: node -v"
  echo "   - pnpm: pnpm -v"
  echo "   - java: /usr/libexec/java_home -V && java -version"
  echo "3) (Opcional) Configura GitHub CLI: gh auth login"
}

main() {
  require_macos
  install_xcode_cli
  install_homebrew
  brew_update
  brew_bundle
  setup_mise
  setup_zsh_plugins_note
  optional_mas
  final_message
}

main "$@"
