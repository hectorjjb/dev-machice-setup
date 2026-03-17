#!/bin/bash

# Detect machine
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     MACHINE=Linux;;
  Darwin*)    MACHINE=Mac;;
  CYGWIN*)    MACHINE=Cygwin;;
  MINGW*)     MACHINE=MinGw;;
  *)          MACHINE="UNKNOWN:${unameOut}"
esac

echo $MACHINE

# Installs .oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # Installs Oh my ZSH with Homebrew (Mac)
  # Note: zsh is the default shell on macOS since Catalina — no need to install it
  if [[ $MACHINE == "Mac" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Installs Oh my ZSH with Linux
  if [[ $MACHINE == "Linux" ]]; then
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
fi

# Assumes default ZSH installation
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Installs plugins (skip if already cloned)
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# Fix permissions
chmod 700 "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# Automatically update plugins array in ~/.zshrc
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
  DESIRED_PLUGINS="plugins=(git zsh-autosuggestions zsh-syntax-highlighting)"
  if grep -q '^plugins=(' "$ZSHRC"; then
    sed -i '' "s/^plugins=(.*)/$DESIRED_PLUGINS/" "$ZSHRC"
    echo "Updated plugins in ~/.zshrc"
  else
    echo "" >> "$ZSHRC"
    echo "$DESIRED_PLUGINS" >> "$ZSHRC"
    echo "Added plugins to ~/.zshrc"
  fi
else
  echo "~/.zshrc not found — plugins not configured"
fi