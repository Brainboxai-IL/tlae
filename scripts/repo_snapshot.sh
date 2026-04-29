#!/usr/bin/env bash
set -euo pipefail

echo "# Repo Snapshot"
echo

echo "## Git"
git status --short 2>/dev/null || true
echo

echo "## Top-level files"
find . -maxdepth 2 \
  -not -path './node_modules*' \
  -not -path './.git*' \
  -not -path './dist*' \
  -not -path './build*' \
  -print | sort | head -200

echo

echo "## Package scripts"
if [ -f package.json ]; then
  node -e 'const p=require("./package.json"); for (const [k,v] of Object.entries(p.scripts||{})) console.log(`${k}: ${v}`)' 2>/dev/null || true
fi
