#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

VSIX="${1:-}"

if [[ -z "$VSIX" ]]; then
  if [[ -f murad-amoled.vsix ]]; then
    VSIX="murad-amoled.vsix"
  else
    # Prefer highest versioned / newest matching file
    VSIX="$(ls -t murad-amoled*.vsix 2>/dev/null | head -n 1 || true)"
  fi
fi

if [[ -z "$VSIX" || ! -f "$VSIX" ]]; then
  echo "No .vsix found."
  echo "Usage:"
  echo "  ./install.sh                          # uses murad-amoled.vsix in this folder"
  echo "  ./install.sh path/to/theme.vsix       # install a downloaded .vsix"
  echo ""
  echo "Or build first:"
  echo "  pnpm install && pnpm package"
  exit 1
fi

INSTALLED=0

if command -v code >/dev/null 2>&1; then
  echo "→ Installing into VS Code: $VSIX"
  code --install-extension "$VSIX" --force
  INSTALLED=1
fi

if command -v cursor >/dev/null 2>&1; then
  echo "→ Installing into Cursor: $VSIX"
  cursor --install-extension "$VSIX" --force
  INSTALLED=1
fi

if [[ "$INSTALLED" -eq 0 ]]; then
  echo "Neither 'code' nor 'cursor' CLI was found in PATH."
  echo "Install via UI: Extensions → ⋯ → Install from VSIX… → $VSIX"
  exit 1
fi

echo ""
echo "Done. Reload the window (Cmd/Ctrl+Shift+P → Developer: Reload Window),"
echo "then pick theme: Preferences → Color Theme → Murad AMOLED"
