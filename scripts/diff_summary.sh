#!/usr/bin/env bash
set -euo pipefail

echo "# Diff Summary"
echo

echo "## Status"
git status --short 2>/dev/null || true

echo

echo "## Changed files"
git diff --name-status 2>/dev/null || true

echo

echo "## Diff stats"
git diff --stat 2>/dev/null || true
