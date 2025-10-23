#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
pushd "$ROOT" >/dev/null

run() {
  echo ""
  echo "▶ $*"
  "$@"
}

# 1) Quality (optional)
run bash Scripts/tools/swift_quality.sh

# 2) Resolve SPM deps (avoid CI-only resolution surprises)
echo "🔄 Resolving Swift Package dependencies…"
xcodebuild -resolvePackageDependencies -project VoltConnect.xcodeproj -scheme VoltConnect >/dev/null

# 3) Enforce asset casing last (stop commit when it renames)
run bash Scripts/tools/fix_asset_casing.sh

echo ""
echo "✅ Pre-commit checks passed."
