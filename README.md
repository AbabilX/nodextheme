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

### Option A — Marketplace

1. Open Extensions (`Cmd/Ctrl+Shift+X`)
2. Search **Murad AMOLED**
3. Install → **Preferences → Color Theme → Murad AMOLED**

### Option B — Direct `.vsix` download (fastest local install)

If you already have `murad-amoled.vsix` (or `murad-amoled-1.0.0.vsix`):

```bash
# from the repo / download folder
chmod +x install.sh
./install.sh

# or point at a downloaded file
./install.sh ~/Downloads/murad-amoled.vsix
```

The script installs into **VS Code** and/or **Cursor** when those CLIs are on your `PATH`.

#### Manual install (UI)

1. Download the `.vsix`
2. VS Code / Cursor → **Extensions** → `⋯` → **Install from VSIX…**
3. Select the file
4. **Preferences → Color Theme → Murad AMOLED**
5. Reload window if colors do not appear (`Cmd/Ctrl+Shift+P` → **Developer: Reload Window**)

#### Manual install (CLI)

```bash
# VS Code
code --install-extension murad-amoled.vsix --force

# Cursor
cursor --install-extension murad-amoled.vsix --force
```

### Option C — Build from source (color tweaking)

```bash
pnpm install

# one command: package + install
pnpm install:vscode    # VS Code
pnpm install:cursor    # Cursor
```

Then reload the window and select **Murad AMOLED**.

### Option D — Extension Development Host

1. Open this folder in VS Code / Cursor
2. Press **F5**
3. In the new window: **Color Theme → Murad AMOLED**

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
