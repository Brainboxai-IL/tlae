#!/usr/bin/env bash
set -euo pipefail

echo "# Project detection"

if [ -f pnpm-lock.yaml ]; then PM="pnpm";
elif [ -f yarn.lock ]; then PM="yarn";
elif [ -f package-lock.json ]; then PM="npm";
elif [ -f bun.lockb ] || [ -f bun.lock ]; then PM="bun";
else PM="unknown"; fi

echo "package_manager=$PM"

if [ -f package.json ]; then
  echo "package_json=true"
  node -e 'const p=require("./package.json"); console.log("scripts="+Object.keys(p.scripts||{}).join(","))' 2>/dev/null || true
else
  echo "package_json=false"
fi

[ -f next.config.js ] || [ -f next.config.mjs ] || [ -f next.config.ts ] && echo "framework=nextjs"
[ -f vite.config.js ] || [ -f vite.config.ts ] && echo "framework=vite"
[ -f prisma/schema.prisma ] && echo "database=prisma"
[ -d app ] && echo "has_app_dir=true"
[ -d src ] && echo "has_src_dir=true"
[ -d pages ] && echo "has_pages_dir=true"
[ -d tests ] || [ -d test ] || [ -d __tests__ ] && echo "has_tests=true"
