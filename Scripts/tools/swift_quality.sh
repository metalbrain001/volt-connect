#!/usr/bin/env bash
set -euo pipefail

# Run SwiftFormat (lint mode). Install: brew install swiftformat
if [[ "${FIX:-0}" == "1" ]]; then
  echo "🛠  Running SwiftFormat + SwiftLint auto-fix..."
  swiftformat VoltConnect --quiet || true
  swiftlint --fix --quiet || true
  echo "✅ Codebase formatted."
fi

# Run SwiftLint. Install: brew install swiftlint
if command -v swiftlint >/dev/null 2>&1; then
  echo "🔎 SwiftLint…"
  swiftlint --quiet
else
  echo "ℹ️  SwiftLint not installed; skipping."
fi
