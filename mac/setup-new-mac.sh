#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Setup new macOS ==="
echo ""

# Ask for the administrator password once upfront
sudo -v

# Keep-alive: refresh sudo timestamp in the background until this script exits
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

# 1. Install Homebrew and essential packages (including fonts)
echo ">>> Installing Homebrew and essentials..."
bash "$SCRIPT_DIR/modules/brew-essentials.sh"
echo ""

# 2. Apply macOS system preferences (needs fonts from step 1)
echo ">>> Applying macOS system settings..."
bash "$SCRIPT_DIR/modules/configure-macos.sh"
echo ""

# 3. Install App Store apps
echo ">>> Installing App Store apps..."
bash "$SCRIPT_DIR/modules/appstore-apps.sh"
echo ""

# 4. Install Oh My Zsh and plugins
echo ">>> Setting up Zsh..."
bash "$SCRIPT_DIR/modules/install-zsh.sh"
echo ""

# Stop the sudo keep-alive background process
kill "$SUDO_KEEPALIVE_PID" 2>/dev/null

echo "=== Setup complete! ==="
echo "Please restart your Mac for all changes to take effect."
