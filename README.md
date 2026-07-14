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

### One command from GitHub → VS Code

```bash
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash
```

VS Code only (explicit):

```bash
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --vscode
```

Cursor only / both:

```bash
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --cursor
curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --all
```

> Requires a GitHub **Release** with a `.vsix` asset uploaded (see below).  
> Also needs the `code` CLI in PATH (VS Code → Command Palette → **Shell Command: Install 'code' command in PATH**).

Then: reload window → **Preferences → Color Theme → Murad AMOLED**

### Option A — Marketplace

1. Open Extensions (`Cmd/Ctrl+Shift+X`)
2. Search **Murad AMOLED**
3. Install → **Preferences → Color Theme → Murad AMOLED**

### Option B — Local `.vsix` / clone

```bash
./install.sh --vscode
./install.sh --vscode ~/Downloads/murad-amoled.vsix
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

### Publish a GitHub Release (needed for curl install)

```bash
pnpm package
# Then on GitHub → Releases → New release → upload murad-amoled.vsix
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
