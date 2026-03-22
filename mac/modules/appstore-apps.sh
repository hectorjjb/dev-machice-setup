#!/bin/bash
set -e

# Requires `mas` (installed via brew-essentials.sh)
# and being signed into the Mac App Store.

if ! command -v mas &> /dev/null; then
  echo "mas is not installed. Skipping App Store apps."
  exit 0
fi

# Note: `mas account` no longer works on macOS 12+.
# Ensure you are signed into the App Store app before running this script.

echo "Installing App Store apps..."

# Find app IDs with: mas search "App Name"
# Examples (free apps):
mas install 497799835  || true  # Xcode
# Remove unwanted pre-installed apps (only if installed)
mas list | grep -q 409201541 && mas uninstall 409201541 || true  # Pages
mas list | grep -q 409203825 && mas uninstall 409203825 || true  # Numbers
mas list | grep -q 409183694 && mas uninstall 409183694 || true  # Keynote

mas install 462054704  || true  # Microsoft Word
mas install 462058435  || true  # Microsoft Excel
mas install 462062816  || true  # Microsoft PowerPoint
mas install 985367838  || true  # Microsoft Outlook
mas install 823766827  || true  # OneDrive
mas install 6738511300 || true  # Microsoft Copilot
mas install 1274495053 || true  # Microsoft To Do
mas install 310633997  || true  # WhatsApp Messenger

echo "App Store apps installed."

