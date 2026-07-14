#!/usr/bin/env bash
# Murad AMOLED — cross-platform install (macOS / Linux / WSL / Git Bash)
#
# macOS / Linux / WSL:
#   curl -fsSL https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.sh | bash
#
# Windows PowerShell (native):
#   irm https://raw.githubusercontent.com/AbabilX/nodextheme/main/install.ps1 | iex
#
# Options:
#   --vscode | --cursor | --all

set -euo pipefail

REPO="${GITHUB_REPO:-AbabilX/nodextheme}"
API="https://api.github.com/repos/${REPO}/releases/latest"
THEME_NAME="Murad AMOLED"
TARGET="vscode"
VSIX=""
CLEANUP_VSIX=0
OS="$(uname -s 2>/dev/null || echo unknown)"

# portable temp dir
if command -v mktemp >/dev/null 2>&1; then
  TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t murad-amoled)"
else
  TMP_DIR="${TMPDIR:-/tmp}/murad-amoled-$$"
  mkdir -p "$TMP_DIR"
fi

usage() {
  cat <<EOF
Murad AMOLED installer (cross-platform)

Usage:
  ./install.sh [options] [path/to.vsix]

Options:
  --vscode    Install into VS Code only (default)
  --cursor    Install into Cursor only
  --all       Install into VS Code and Cursor
  -h, --help  Show help

One-liners:
  # macOS / Linux / WSL / Git Bash
  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash

  # Windows PowerShell
  irm https://raw.githubusercontent.com/${REPO}/main/install.ps1 | iex
EOF
}

cleanup() {
  if [[ "$CLEANUP_VSIX" -eq 1 && -n "${VSIX:-}" && -f "$VSIX" ]]; then
    rm -f "$VSIX" || true
  fi
  rm -rf "$TMP_DIR" || true
}
trap cleanup EXIT

detect_platform() {
  case "$OS" in
    Darwin*) echo "macOS" ;;
    Linux*)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL"
      else
        echo "Linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*) echo "Windows (Git Bash)" ;;
    *) echo "$OS" ;;
  esac
}

PLATFORM="$(detect_platform)"
echo "→ Platform: ${PLATFORM}"

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

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

find_local_vsix() {
  local dir candidates=()
  if [[ -n "$SCRIPT_DIR" ]]; then
    candidates+=("$SCRIPT_DIR")
  fi
  candidates+=("$PWD")

  for dir in "${candidates[@]}"; do
    if [[ -f "$dir/murad-amoled.vsix" ]]; then
      echo "$dir/murad-amoled.vsix"
      return
    fi
    local found
    found="$(ls -t "$dir"/murad-amoled*.vsix 2>/dev/null | head -n 1 || true)"
    if [[ -n "$found" ]]; then
      echo "$found"
      return
    fi
  done
}

http_get() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$url"
  else
    echo "Need curl or wget to download from GitHub." >&2
    exit 1
  fi
}

http_download() {
  local url="$1"
  local out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar -o "$out" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$out" "$url"
  else
    echo "Need curl or wget to download from GitHub." >&2
    exit 1
  fi
}

download_from_github() {
  echo "→ Fetching latest release from GitHub: ${REPO}"

  local json url name
  json="$(http_get "$API")" || {
    echo "Failed to read GitHub releases."
    echo "Create a Release on https://github.com/${REPO}/releases and upload murad-amoled.vsix"
    exit 1
  }

  url="$(printf '%s' "$json" | tr '"' '\n' | grep -E '^https://.*/.*\.vsix$' | head -n 1 || true)"
  if [[ -z "$url" ]]; then
    echo "No .vsix asset found on the latest GitHub release."
    echo "Upload murad-amoled.vsix to: https://github.com/${REPO}/releases"
    exit 1
  fi

  name="$(basename "${url%%\?*}")"
  VSIX="${TMP_DIR}/${name}"
  echo "→ Downloading ${name}"
  http_download "$url" "$VSIX"
  CLEANUP_VSIX=1
}

# Resolve CLI name per platform (Windows often needs .cmd)
resolve_cli() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    command -v "$name"
    return 0
  fi
  # Git Bash / MSYS: prefer .cmd wrappers
  if command -v "${name}.cmd" >/dev/null 2>&1; then
    command -v "${name}.cmd"
    return 0
  fi
  return 1
}

path_hint() {
  case "$PLATFORM" in
    macOS)
      echo "  VS Code: Cmd+Shift+P → Shell Command: Install 'code' command in PATH"
      echo "  Cursor:  Cmd+Shift+P → Shell Command: Install 'cursor' command in PATH"
      ;;
    Linux|WSL)
      echo "  Ensure 'code' is on PATH (apt/snap install or VS Code docs)."
      echo "  WSL tip: use Windows VS Code with Remote-WSL, or install Linux VS Code."
      ;;
    "Windows (Git Bash)")
      echo "  Or use PowerShell instead:"
      echo "    irm https://raw.githubusercontent.com/${REPO}/main/install.ps1 | iex"
      echo "  VS Code: Ctrl+Shift+P → Shell Command: Install 'code' command in PATH"
      ;;
    *)
      echo "  Add the editor CLI to your PATH, then re-run."
      ;;
  esac
}

to_windows_path_if_needed() {
  local path="$1"
  # Convert /c/Users/... → C:\Users\... when calling Windows CLIs from Git Bash
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$path"
  else
    echo "$path"
  fi
}

install_editor() {
  local bin_name="$1"
  local label="$2"
  local bin path_for_cli

  if ! bin="$(resolve_cli "$bin_name")"; then
    echo "✗ ${label} CLI ('${bin_name}') not found in PATH."
    return 1
  fi

  path_for_cli="$VSIX"
  case "$PLATFORM" in
    "Windows (Git Bash)")
      path_for_cli="$(to_windows_path_if_needed "$VSIX")"
      ;;
  esac

  echo "→ Installing into ${label}: $path_for_cli"
  "$bin" --install-extension "$path_for_cli" --force
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
  path_hint
  exit 1
fi

echo ""
echo "Done on ${PLATFORM}."
echo "Reload the window (Cmd/Ctrl+Shift+P → Developer: Reload Window),"
echo "then pick theme: Preferences → Color Theme → ${THEME_NAME}"
