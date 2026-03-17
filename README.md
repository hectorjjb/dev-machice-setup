# dev-machice-setup

Personal scripts to configure new development machines (macOS & Windows). Automates system preferences, package installation, and shell setup so a fresh machine is ready to code in minutes.

## What it does

### macOS
- **System preferences** — Finder, Dock, keyboard, screenshots, Safari, and more
- **Homebrew packages** — CLI tools (git, gh, ripgrep, fzf, jq, etc.) and apps (VS Code, Edge, Teams, Spotify, etc.)
- **Zsh configuration** — Oh My Zsh with plugins (autosuggestions, syntax highlighting) and the `apple` theme

### Windows
- **WinGet packages** — Dev tools and apps via Windows Package Manager

## Usage

### macOS
```bash
bash mac/setup-new-mac.sh
```

### Windows
```powershell
powershell -ExecutionPolicy Bypass -File windows\Windows11Setup.ps1
```
