#!/usr/bin/env bash
# Murad AMOLED — one-command install from GitHub into VS Code (and optionally Cursor)
#
# Quick install (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash
#
# VS Code only:
#   curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash -s -- --vscode
#
# Local .vsix:
#   ./install.sh
#   ./install.sh ./murad-amoled.vsix

set -euo pipefail

REPO="${GITHUB_REPO:-AbabilX/nodextheme}"
API="https://api.github.com/repos/${REPO}/releases/latest"
THEME_NAME="Murad AMOLED"
TMP_DIR="$(mktemp -d)"
TARGET="vscode" # vscode | cursor | all
VSIX=""
CLEANUP_VSIX=0

usage() {
  cat <<EOF
Usage:
  ./install.sh [options] [path/to.vsix]

Options:
  --vscode    Install into VS Code only (default)
  --cursor    Install into Cursor only
  --all       Install into VS Code and Cursor
  -h, --help  Show help

One-liner from GitHub:
  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash -s -- --vscode
EOF
}

cleanup() {
  if [[ "$CLEANUP_VSIX" -eq 1 && -n "$VSIX" && -f "$VSIX" ]]; then
    rm -f "$VSIX"
  fi
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vscode) TARGET="vscode"; shift ;;
    --cursor) TARGET="cursor"; shift ;;
    --all) TARGET="all"; shift ;;
    -h|--help) usage; exit 0 ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      VSIX="$1"
      shift
      ;;
  esac
done

# Resolve local script directory when not piped through curl|bash
SCRIPT_DIR=""
if [[ "${BASH_SOURCE[0]:-}" == /* || "${BASH_SOURCE[0]:-}" == ./* || "${BASH_SOURCE[0]:-}" == ../* ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

find_local_vsix() {
  if [[ -n "$SCRIPT_DIR" ]]; then
    if [[ -f "$SCRIPT_DIR/murad-amoled.vsix" ]]; then
      echo "$SCRIPT_DIR/murad-amoled.vsix"
      return
    fi
    local found
    found="$(ls -t "$SCRIPT_DIR"/murad-amoled*.vsix 2>/dev/null | head -n 1 || true)"
    if [[ -n "$found" ]]; then
      echo "$found"
      return
    fi
  fi
  if [[ -f murad-amoled.vsix ]]; then
    echo "murad-amoled.vsix"
    return
  fi
  ls -t murad-amoled*.vsix 2>/dev/null | head -n 1 || true
}

download_from_github() {
  echo "→ Fetching latest release from GitHub: ${REPO}"

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to download from GitHub."
    exit 1
  fi

  local json url name
  json="$(curl -fsSL "$API")" || {
    echo "Failed to read GitHub releases."
    echo "Create a Release on https://github.com/${REPO}/releases and upload murad-amoled.vsix"
    exit 1
  }

  # Prefer browser_download_url ending in .vsix (no jq required)
  url="$(printf '%s' "$json" | tr '"' '\n' | grep -E '^https://.*/.*\.vsix$' | head -n 1 || true)"
  if [[ -z "$url" ]]; then
    echo "No .vsix asset found on the latest GitHub release."
    echo "Upload murad-amoled.vsix to: https://github.com/${REPO}/releases"
    exit 1
  fi

  name="$(basename "$url")"
  VSIX="${TMP_DIR}/${name}"
  echo "→ Downloading ${name}"
  curl -fL --progress-bar -o "$VSIX" "$url"
  CLEANUP_VSIX=1
}

if [[ -z "$VSIX" ]]; then
  VSIX="$(find_local_vsix || true)"
fi

if [[ -z "$VSIX" || ! -f "$VSIX" ]]; then
  download_from_github
fi

if [[ ! -f "$VSIX" ]]; then
  echo "Could not find or download a .vsix file."
  exit 1
fi

install_editor() {
  local bin="$1"
  local label="$2"
  if command -v "$bin" >/dev/null 2>&1; then
    echo "→ Installing into ${label}: $VSIX"
    "$bin" --install-extension "$VSIX" --force
    return 0
  fi
  echo "✗ ${label} CLI ('${bin}') not found in PATH."
  return 1
}

INSTALLED=0

case "$TARGET" in
  vscode)
    if install_editor code "VS Code"; then INSTALLED=1; fi
    ;;
  cursor)
    if install_editor cursor "Cursor"; then INSTALLED=1; fi
    ;;
  all)
    if install_editor code "VS Code"; then INSTALLED=1; fi
    if install_editor cursor "Cursor"; then INSTALLED=1; fi
    ;;
esac

if [[ "$INSTALLED" -eq 0 ]]; then
  echo ""
  echo "Install failed: editor CLI not found."
  if [[ "$TARGET" == "vscode" || "$TARGET" == "all" ]]; then
    echo "Enable VS Code shell command: Command Palette → Shell Command: Install 'code' command in PATH"
  fi
  exit 1
fi

echo ""
echo "Done. Reload the window (Cmd/Ctrl+Shift+P → Developer: Reload Window),"
echo "then pick theme: Preferences → Color Theme → ${THEME_NAME}"
