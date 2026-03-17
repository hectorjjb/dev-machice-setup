# macOS Setup

## Quick Start

```bash
bash mac/setup-new-mac.sh
```

This runs three modules in order:

1. **configure-macos.sh** — System preferences (Finder, Dock, keyboard, screenshots, etc.)
2. **brew-essentials.sh** — Homebrew + CLI tools + apps
3. **install-zsh.sh** — Oh My Zsh, plugins, and theme

The script is idempotent — safe to run multiple times. It will repair broken settings from previous runs.

---

## Manual Steps After Running the Script

### Swap Command ↔ Control Keys (Windows-style shortcuts)

This **cannot be automated** because macOS stores modifier key mappings per-keyboard using hardware IDs. This is actually a benefit — you can swap keys on your main keyboard while keeping other keyboards (e.g. Logitech) with their default layout.

#### Why not use `hidutil` (the old scripted approach)?

Previous versions of this script used `hidutil property --set` to remap keys globally. This approach has several problems:

- **Applies to ALL keyboards** — if you have multiple keyboards with different layouts, they all get the same swap whether you want it or not
- **Doesn't persist across reboots** — requires a LaunchAgent plist to re-apply on every login, which adds maintenance overhead
- **Can break after macOS updates** — Apple may change LaunchAgent behavior or `hidutil` flags between versions
- **Conflicts with System Settings** — if you also configure modifier keys in System Settings, the two mechanisms fight each other

The native System Settings approach avoids all of these issues.

**Do this once per keyboard:**

1. Open **System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys**
2. Select your keyboard from the **"Select keyboard"** dropdown
3. Set **Control (^) Key** → Command
4. Set **Command Key** → Control (^)
5. Click **Done**

The setting persists across reboots automatically.

> **Note:** The Spotlight shortcut is set to **Ctrl+Space** by the script, which means you'll press the physical Command key (now mapped to Control) + Space — same finger position as the default Cmd+Space.

---

## What Gets Installed

### Apps (via Homebrew Cask)
- Visual Studio Code
- Microsoft Edge
- Microsoft Teams
- GitHub Desktop
- Spotify
- WhatsApp
- VLC

### CLI Tools (via Homebrew)
- git, git-lfs, gh (GitHub CLI)
- wget, tree, jq
- ripgrep, fd, bat, fzf
- fnm (Node.js version manager)
- .NET SDK

### Zsh
- Oh My Zsh
- Theme: `agnoster`
- Plugins: `git`, `z`, `zsh-autosuggestions`, `node`
- zsh-syntax-highlighting (sourced at end of .zshrc)
- Font: Fira Code Nerd Font (required for agnoster theme)
