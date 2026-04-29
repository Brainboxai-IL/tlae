#!/usr/bin/env node
/* eslint-disable no-console */
"use strict";

const fs = require("fs");
const os = require("os");
const path = require("path");
const { execSync, spawnSync } = require("child_process");

// ---------- ANSI colors (no deps) ----------
const c = {
  reset: "\x1b[0m",
  bold: "\x1b[1m",
  dim: "\x1b[2m",
  cyan: "\x1b[36m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  red: "\x1b[31m",
  blue: "\x1b[34m",
  magenta: "\x1b[35m",
};

// ---------- Constants ----------
const REPO_URL = "https://github.com/Brainboxai-IL/tlae.git";
const REPO_TARBALL = "https://codeload.github.com/Brainboxai-IL/tlae/tar.gz/refs/heads/main";
const VERSION = require("../package.json").version;

// ---------- Targets per platform ----------
function targetFor(agent) {
  const home = os.homedir();
  switch (agent) {
    case "claude":
      return path.join(home, ".claude", "skills", "tlae");
    case "cursor":
      // Cursor uses a single .cursor/rules dir per project; install is per-project
      return path.join(process.cwd(), ".cursor", "rules", "tlae");
    case "codex":
      return path.join(home, ".codex", "skills", "tlae");
    case "gemini":
      return path.join(home, ".gemini", "skills", "tlae");
    case "aider":
      // Aider reads CONVENTIONS.md from the repo
      return path.join(process.cwd(), ".aider", "skills", "tlae");
    case "project":
      return path.join(process.cwd(), ".claude", "skills", "tlae");
    default:
      return null;
  }
}

function targetLabel(agent) {
  return {
    claude: "Claude Code (~/.claude/skills/tlae)",
    cursor: "Cursor (./.cursor/rules/tlae)",
    codex: "Codex CLI (~/.codex/skills/tlae)",
    gemini: "Gemini CLI (~/.gemini/skills/tlae)",
    aider: "Aider (./.aider/skills/tlae)",
    project: "Current project (./.claude/skills/tlae)",
  }[agent];
}

// ---------- Args parsing ----------
function parseArgs(argv) {
  const args = { agents: [], force: false, help: false, version: false };
  for (const a of argv) {
    switch (a) {
      case "--claude":
        args.agents.push("claude");
        break;
      case "--cursor":
        args.agents.push("cursor");
        break;
      case "--codex":
        args.agents.push("codex");
        break;
      case "--gemini":
        args.agents.push("gemini");
        break;
      case "--aider":
        args.agents.push("aider");
        break;
      case "--project":
        args.agents.push("project");
        break;
      case "--all":
        args.agents.push("claude", "cursor", "codex", "gemini", "aider");
        break;
      case "--force":
      case "-f":
        args.force = true;
        break;
      case "--help":
      case "-h":
        args.help = true;
        break;
      case "--version":
      case "-v":
        args.version = true;
        break;
    }
  }
  return args;
}

function printHelp() {
  console.log(`
${c.bold}${c.cyan}TLAE${c.reset} ${c.dim}v${VERSION}${c.reset}
${c.dim}Tech Lead Agentic Engineering — Claude Code skill installer${c.reset}

${c.bold}USAGE${c.reset}
  npx tlae [options]

${c.bold}DEFAULT${c.reset}
  Without flags, installs to Claude Code globally (~/.claude/skills/tlae).

${c.bold}TARGETS${c.reset}
  ${c.green}--claude${c.reset}      Install for Claude Code globally  ${c.dim}(default)${c.reset}
  ${c.green}--cursor${c.reset}      Install for Cursor in current project
  ${c.green}--codex${c.reset}       Install for Codex CLI
  ${c.green}--gemini${c.reset}      Install for Gemini CLI
  ${c.green}--aider${c.reset}       Install for Aider in current project
  ${c.green}--project${c.reset}     Install for Claude Code in current project only
  ${c.green}--all${c.reset}         Install for all supported agents

${c.bold}OPTIONS${c.reset}
  ${c.green}--force, -f${c.reset}   Overwrite existing install
  ${c.green}--help, -h${c.reset}    Show this help
  ${c.green}--version, -v${c.reset} Show version

${c.bold}EXAMPLES${c.reset}
  ${c.dim}# install to Claude Code (most common):${c.reset}
  npx tlae

  ${c.dim}# install to Cursor for the current project:${c.reset}
  npx tlae --cursor

  ${c.dim}# install everywhere:${c.reset}
  npx tlae --all

${c.bold}LEARN MORE${c.reset}
  ${c.cyan}https://github.com/Brainboxai-IL/tlae${c.reset}
`);
}

// ---------- Download ----------
function hasGit() {
  const r = spawnSync("git", ["--version"], { stdio: "ignore" });
  return r.status === 0;
}

function downloadViaGit() {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "tlae-"));
  execSync(`git clone --depth 1 ${REPO_URL} "${tmpDir}"`, { stdio: "ignore" });
  // Remove .git from the clone
  fs.rmSync(path.join(tmpDir, ".git"), { recursive: true, force: true });
  return tmpDir;
}

function downloadViaTarball() {
  // Fallback: use Node + tar fetch (no deps).
  // We'll shell out to curl or PowerShell as a portable fallback.
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "tlae-"));
  const tarPath = path.join(tmpDir, "tlae.tar.gz");

  if (process.platform === "win32") {
    // PowerShell on Windows
    execSync(
      `powershell -Command "Invoke-WebRequest -Uri '${REPO_TARBALL}' -OutFile '${tarPath}' -UseBasicParsing"`,
      { stdio: "ignore" }
    );
    execSync(
      `powershell -Command "tar -xzf '${tarPath}' -C '${tmpDir}'"`,
      { stdio: "ignore" }
    );
  } else {
    execSync(`curl -fsSL "${REPO_TARBALL}" -o "${tarPath}"`, { stdio: "ignore" });
    execSync(`tar -xzf "${tarPath}" -C "${tmpDir}"`, { stdio: "ignore" });
  }

  // Find extracted dir (usually tlae-main)
  const entries = fs.readdirSync(tmpDir, { withFileTypes: true });
  const extracted = entries.find(
    (e) => e.isDirectory() && e.name.startsWith("tlae-")
  );
  if (!extracted) {
    throw new Error("Failed to find extracted directory");
  }
  return path.join(tmpDir, extracted.name);
}

// ---------- Copy ----------
function copyRecursiveSync(src, dest) {
  const stat = fs.statSync(src);
  if (stat.isDirectory()) {
    fs.mkdirSync(dest, { recursive: true });
    for (const entry of fs.readdirSync(src)) {
      copyRecursiveSync(path.join(src, entry), path.join(dest, entry));
    }
  } else {
    fs.copyFileSync(src, dest);
  }
}

function installToTarget(sourceDir, agent, force) {
  const target = targetFor(agent);
  if (!target) return { ok: false, reason: "unknown agent" };

  if (fs.existsSync(target)) {
    if (!force) {
      return { ok: false, reason: "exists", target };
    }
    fs.rmSync(target, { recursive: true, force: true });
  }

  fs.mkdirSync(path.dirname(target), { recursive: true });
  copyRecursiveSync(sourceDir, target);
  return { ok: true, target };
}

// ---------- Main ----------
function main() {
  const argv = process.argv.slice(2);
  const args = parseArgs(argv);

  if (args.help) {
    printHelp();
    return;
  }
  if (args.version) {
    console.log(`tlae v${VERSION}`);
    return;
  }

  // Default: claude
  if (args.agents.length === 0) {
    args.agents.push("claude");
  }

  // Dedupe
  args.agents = [...new Set(args.agents)];

  console.log(`\n${c.bold}${c.cyan}🧠 TLAE${c.reset} ${c.dim}v${VERSION}${c.reset}`);
  console.log(`${c.dim}Tech Lead Agentic Engineering${c.reset}\n`);

  // Download once
  console.log(`${c.dim}Downloading skill from ${REPO_URL}...${c.reset}`);
  let sourceDir;
  try {
    sourceDir = hasGit() ? downloadViaGit() : downloadViaTarball();
  } catch (err) {
    console.error(`${c.red}✗ Download failed:${c.reset} ${err.message}`);
    console.error(`${c.dim}Make sure you have git or curl installed, and network access.${c.reset}`);
    process.exit(1);
  }
  console.log(`${c.green}✓${c.reset} Downloaded.\n`);

  // Install to each target
  const results = [];
  for (const agent of args.agents) {
    process.stdout.write(`Installing to ${c.bold}${targetLabel(agent)}${c.reset}... `);
    const result = installToTarget(sourceDir, agent, args.force);
    if (result.ok) {
      console.log(`${c.green}✓${c.reset}`);
      results.push({ agent, ok: true });
    } else if (result.reason === "exists") {
      console.log(`${c.yellow}skipped${c.reset} ${c.dim}(already exists; use --force to overwrite)${c.reset}`);
      results.push({ agent, ok: false, skipped: true });
    } else {
      console.log(`${c.red}✗ ${result.reason}${c.reset}`);
      results.push({ agent, ok: false, error: result.reason });
    }
  }

  // Cleanup tmp
  try {
    fs.rmSync(path.dirname(sourceDir), { recursive: true, force: true });
  } catch (_) {
    // ignore
  }

  // Summary
  const installed = results.filter((r) => r.ok);
  const skipped = results.filter((r) => r.skipped);

  console.log("");
  if (installed.length === 0 && skipped.length > 0) {
    console.log(`${c.yellow}Nothing new installed.${c.reset} Use ${c.bold}--force${c.reset} to overwrite existing installs.\n`);
    return;
  }
  if (installed.length === 0) {
    console.log(`${c.red}Nothing installed.${c.reset}\n`);
    process.exit(1);
  }

  console.log(`${c.bold}${c.green}✓ Done.${c.reset} ${c.dim}Installed to ${installed.length} target(s).${c.reset}\n`);

  // Next steps
  console.log(`${c.bold}Next steps:${c.reset}`);
  if (installed.find((r) => r.agent === "claude" || r.agent === "project")) {
    console.log(`  ${c.dim}1.${c.reset} Open a project in Claude Code`);
    console.log(`  ${c.dim}2.${c.reset} Say: ${c.cyan}"use tlae"${c.reset}`);
    console.log(`  ${c.dim}3.${c.reset} The skill will detect your stack and ask 3 questions.`);
  }
  if (installed.find((r) => r.agent === "cursor")) {
    console.log(`  ${c.dim}•${c.reset} Cursor: rules are loaded automatically from .cursor/rules/`);
  }
  console.log(`\n${c.dim}Docs: ${c.reset}${c.cyan}https://github.com/Brainboxai-IL/tlae${c.reset}\n`);
}

try {
  main();
} catch (err) {
  console.error(`${c.red}Error:${c.reset} ${err.message}`);
  process.exit(1);
}
