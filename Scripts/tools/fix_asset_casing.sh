#!/usr/bin/env bash
set -euo pipefail

# Directories to scan (adjust as you like)
ROOT="$(git rev-parse --show-toplevel)"
SCAN_DIRS=(
  "VoltConnect/Resources"
)

found=0

lowercase_and_gitmv() {
  local file="$1"
  local dir
  dir="$(dirname "$file")"
  local base
  base="$(basename "$file")"
  local lower="$(echo "$base" | tr '[:upper:]' '[:lower:]')"
  if [[ "$base" != "$lower" ]]; then
    found=1
    echo " - $file → ${dir}/${lower}"
    # two-step rename for case-insensitive FS
    git mv "$file" "${dir}/${lower}.tmp" >/dev/null 2>&1 || git mv -f "$file" "${dir}/${lower}.tmp"
    git mv "${dir}/${lower}.tmp" "${dir}/${lower}"
  fi
}

echo "🔎 Checking for capitalized filenames in: ${SCAN_DIRS[*]}"

for rel in "${SCAN_DIRS[@]}"; do
  dir="${ROOT}/${rel}"
  [[ -d "$dir" ]] || continue

  # Find regular files (skip .xcassets by default)
  while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    if [[ "$base" =~ [A-Z] ]]; then
      lowercase_and_gitmv "$f"
    fi
  done < <(find "$dir" -type f \
          ! -path "*/.git/*" \
          ! -path "*/Assets.xcassets/*" \
          -print0)
done

if [[ "$found" -eq 1 ]]; then
  echo "⚠️  Renamed files to lowercase. Review and re-commit."
  exit 1  # stop commit so devs can see the renames
else
  echo "✅ No capitalized filenames found."
fi