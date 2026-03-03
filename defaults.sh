#!/usr/bin/env bash
set -euo pipefail

# Finder: mostrar extensiones
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: mostrar path bar
defaults write com.apple.finder ShowPathbar -bool true

# Dock: acelerar animaciones (mínimo)
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock autohide-delay -float 0

killall Finder || true
killall Dock || true

echo "Defaults aplicados."
