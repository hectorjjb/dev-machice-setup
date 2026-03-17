#!/bin/bash
set -e

# Install Homebrew (if not installed)
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Add Homebrew to PATH for this session (and persist in .zprofile)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
  fi
fi
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Casks are built-in since Homebrew 4.0 — no need for `brew tap homebrew/cask`

## Apps I use
brew install --cask --no-quarantine spotify || true
brew install --cask --no-quarantine visual-studio-code || true
brew install --cask --no-quarantine whatsapp || true
brew install --cask --no-quarantine vlc || true

brew install wget || true
brew install git || true
brew install git-lfs || true
brew install tree || true

# Modern CLI essentials
brew install gh || true
brew install ripgrep || true
brew install fd || true
brew install bat || true
brew install jq || true
brew install fzf || true

# Fonts
brew install --cask font-fira-code-nerd-font || true

# Node.js (latest LTS version via fnm)
brew install fnm || true
if command -v fnm &> /dev/null; then
  eval "$(fnm env)"
  fnm install --lts
  fnm default lts-latest
fi

# .NET SDK (latest LTS version)
brew install --cask dotnet-sdk || true

# Remove outdated versions from the cellar.
brew cleanup