#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Configure macOS ==="
echo ""

# 1. Apply macOS system preferences
echo ">>> Applying macOS system settings..."
bash "$SCRIPT_DIR/mac/configure-macos.sh"
echo ""

# 2. Install Homebrew and essential packages
echo ">>> Installing Homebrew and essentials..."
bash "$SCRIPT_DIR/mac/brew-essentials.sh"
echo ""

# 3. Install Oh My Zsh and plugins
echo ">>> Setting up Zsh..."
bash "$SCRIPT_DIR/mac/install-zsh.sh"
echo ""

echo "=== Setup complete! ==="
echo "Please restart your Mac for all changes to take effect."
