# Murad AMOLED

[![Version](https://img.shields.io/visual-studio-marketplace/v/mozaddedalfeshani.murad-amoled?label=VS%20Marketplace)](https://marketplace.visualstudio.com/items?itemName=mozaddedalfeshani.murad-amoled)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-informational)](#installation)

A minimal **AMOLED black** theme for Visual Studio Code & Cursor — pure `#000000` UI with vivid GitHub Dark–inspired syntax colors.

**Publisher:** `mozaddedalfeshani` · **Theme:** `Murad AMOLED` · **Extension ID:** `mozaddedalfeshani.murad-amoled`

---

## Preview

```text
Editor background:  #000000
Accent / focus:     #7ee787
Keywords:           #ff7b72
Functions:          #b392f0
Strings:            #a5d6ff
Comments:           #b392f0
```

> True black chrome · OLED-friendly · high-contrast syntax

---

## Features

- Pure AMOLED black (`#000000`) editor and workbench
- Vivid syntax highlighting inspired by GitHub Dark
- Semantic highlighting enabled
- Tuned UI tokens (sidebar, tabs, status bar, terminal, debug)
- Works on **VS Code** and **Cursor**
- Cross-platform one-liner install (macOS · Linux · WSL · Windows)

---

## Installation

### 1. Marketplace (recommended)

1. Open **Extensions** (`Cmd/Ctrl+Shift+X`)
2. Search **Murad AMOLED**
3. Click **Install**
4. Activate: `Cmd/Ctrl+K` then `Cmd/Ctrl+T` → **Murad AMOLED**

Direct link: [marketplace.visualstudio.com/items?itemName=mozaddedalfeshani.murad-amoled](https://marketplace.visualstudio.com/items?itemName=mozaddedalfeshani.murad-amoled)

---

### 2. One command from GitHub

Downloads the latest `.vsix` Release and installs into VS Code.

#### macOS / Linux / WSL / Git Bash

```bash
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash
```

#### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.ps1 | iex
```

#### Target Cursor / both editors

```bash
# Cursor only
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --cursor

# VS Code + Cursor
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --all
```

```powershell
# Windows — save then run
irm https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.ps1 -OutFile install.ps1
.\install.ps1 -Target cursor   # or: -Target all
```

**Requirements**

- A GitHub [Release](https://github.com/AbabilX/nodextheme/releases) with a `.vsix` asset
- Editor CLI on PATH:
  - **macOS:** `Cmd+Shift+P` → *Shell Command: Install 'code' command in PATH*
  - **Windows:** `Ctrl+Shift+P` → *Shell Command: Install 'code' command in PATH*
  - **Linux:** follow [VS Code CLI docs](https://code.visualstudio.com/docs/setup/linux)

After install: **Developer: Reload Window** → Color Theme → **Murad AMOLED**

---

### 3. Install a downloaded `.vsix`

#### Quick scripts (from this repo)

```bash
./install.sh --vscode ./murad-amoled.vsix
```

```powershell
.\install.ps1 -Target vscode -VsixPath .\murad-amoled.vsix
```

#### UI

1. **Extensions** → `⋯` → **Install from VSIX…**
2. Select `murad-amoled.vsix`
3. Color Theme → **Murad AMOLED**

#### CLI

```bash
code --install-extension murad-amoled.vsix --force
# Cursor:
cursor --install-extension murad-amoled.vsix --force
```

---

### 4. Build from source

```bash
pnpm install
pnpm install:vscode    # package + install into VS Code
pnpm install:cursor    # package + install into Cursor
```

Or press **F5** to launch the Extension Development Host and pick **Murad AMOLED**.

---

## Activate the theme

| Action | Shortcut |
|--------|----------|
| Color Theme picker | `Cmd/Ctrl+K` then `Cmd/Ctrl+T` |
| Command Palette | `Cmd/Ctrl+Shift+P` → `Preferences: Color Theme` |
| Reload window | `Cmd/Ctrl+Shift+P` → `Developer: Reload Window` |

---

## Develop / tweak colors

1. Edit `themes/Murad AMOLED-color-theme.json`
2. Rebuild & reinstall:

```bash
pnpm install:vscode
```

3. Reload the window to preview

### Useful scripts

| Script | What it does |
|--------|----------------|
| `pnpm package` | Build `murad-amoled.vsix` |
| `pnpm install:vscode` | Build + install into VS Code |
| `pnpm install:cursor` | Build + install into Cursor |
| `pnpm publish` | Publish to VS Marketplace |

### Ship a GitHub Release (for curl / irm install)

```bash
pnpm package
# GitHub → Releases → New release → upload murad-amoled.vsix (+ install.sh already on main)
```

---

## Screenshots

| Editor | Sidebar | Terminal |
|--------|---------|----------|
| _Add screenshot_ | _Add screenshot_ | _Add screenshot_ |

---

## Project layout

```text
├── package.json
├── themes/Murad AMOLED-color-theme.json
├── images/icon.png
├── install.sh          # macOS / Linux / WSL / Git Bash
├── install.ps1         # Windows PowerShell
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## Credits

- Inspired by **GitHub Dark** and AMOLED black themes
- Color & token palette from the original Muradian AMOLED theme

---

## License

[MIT](./LICENSE) © [mozaddedalfeshani](https://github.com/AbabilX/nodextheme)
