# Murad AMOLED

A minimal **AMOLED black** Visual Studio Code theme inspired by GitHub Dark, with vivid syntax colors on a pure black canvas.

## Preview

> True black (`#000000`) UI · GitHub-inspired syntax · AMOLED-friendly contrast

```text
Editor background: #000000
Accent / focus:    #7ee787
Keywords:          #ff7b72
Functions:         #b392f0
Strings:           #a5d6ff
```

## Features

- Pure AMOLED black editor and chrome (`#000000`)
- Vivid syntax highlighting inspired by GitHub Dark
- Semantic highlighting enabled
- Clear contrast for long coding sessions on OLED displays
- Consistent UI tokens for sidebar, status bar, terminal, and debug views

## Installation

Cross-platform: **macOS · Linux · WSL · Windows**

### One command from GitHub → VS Code

**macOS / Linux / WSL / Git Bash**

```bash
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.ps1 | iex
```

| Goal | macOS / Linux / WSL | Windows PowerShell |
|------|---------------------|--------------------|
| VS Code (default) | `curl ... \| bash` | `irm ... \| iex` |
| VS Code only | `curl ... \| bash -s -- --vscode` | `irm .../install.ps1 -OutFile install.ps1; .\install.ps1 -Target vscode` |
| Cursor | `curl ... \| bash -s -- --cursor` | download `install.ps1` then `.\install.ps1 -Target cursor` |
| Both | `curl ... \| bash -s -- --all` | `.\install.ps1 -Target all` |

> Needs a GitHub **Release** with a `.vsix` asset.  
> Needs `code` (or `cursor`) on PATH:
> - **macOS:** `Cmd+Shift+P` → *Shell Command: Install 'code' command in PATH*
> - **Windows:** `Ctrl+Shift+P` → *Shell Command: Install 'code' command in PATH*
> - **Linux:** install the `code` CLI from your distro / VS Code docs

Then reload → **Preferences → Color Theme → Murad AMOLED**

### Option A — Marketplace

1. Open Extensions (`Cmd/Ctrl+Shift+X`)
2. Search **Murad AMOLED**
3. Install → **Preferences → Color Theme → Murad AMOLED**

### Option B — Local `.vsix` / clone

```bash
# macOS / Linux / WSL / Git Bash
./install.sh --vscode
./install.sh --vscode ./murad-amoled.vsix
```

```powershell
# Windows PowerShell
.\install.ps1 -Target vscode
.\install.ps1 -Target vscode -VsixPath .\murad-amoled.vsix
```

#### Manual install (UI)

1. Download the `.vsix`
2. VS Code → **Extensions** → `⋯` → **Install from VSIX…**
3. Select the file → **Color Theme → Murad AMOLED**

#### Manual install (CLI)

```bash
code --install-extension murad-amoled.vsix --force
```

### Option C — Build from source (color tweaking)

```bash
pnpm install
pnpm install:vscode    # package + install into VS Code
pnpm install:cursor    # package + install into Cursor
```

### Option D — Extension Development Host

1. Open this folder in VS Code / Cursor
2. Press **F5**
3. In the new window: **Color Theme → Murad AMOLED**

### Publish a GitHub Release (needed for remote install)

```bash
pnpm package
# GitHub → Releases → New release → upload murad-amoled.vsix
```

## Develop / rebuild after color changes

Edit `themes/Murad AMOLED-color-theme.json`, then:

```bash
pnpm install:vscode
# or
pnpm install:cursor
```

Reload the window to preview.

## Screenshots

<!-- Add screenshots after packaging -->

| Editor | Sidebar | Terminal |
|--------|---------|----------|
| _TODO_ | _TODO_  | _TODO_   |

## Credits

- Visual direction inspired by **GitHub Dark** and AMOLED black themes.
- Theme colors and token scopes preserved from the original Muradian AMOLED palette.

## License

MIT © mozaddedalfeshani
