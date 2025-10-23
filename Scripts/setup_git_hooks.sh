#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="${ROOT}/.git/hooks"

if [[ ! -d "$HOOKS_DIR" ]]; then
  echo "❌ .git/hooks not found. Initialize git first: git init"
  exit 1
fi

install_hook() {
  local src="$1"
  local dst="$2"
  cp -f "$src" "$dst"
  chmod +x "$dst"
  echo "✔ Installed $(basename "$dst")"
}

install_hook "Scripts/hooks/pre-commit"      "${HOOKS_DIR}/pre-commit"
# Optional Windows helper (if teammates use Git for Windows)
cp -f "Scripts/hooks/pre-commit.bat" "${HOOKS_DIR}/pre-commit.bat" || true

echo "✅ Git hooks installed."