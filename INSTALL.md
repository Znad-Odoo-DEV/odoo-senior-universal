# Install from the terminal (Ubuntu / macOS)

Everything here is copy-paste ready and works the same on Ubuntu and macOS unless a difference is noted. Replace `<project>` with the folder of the project you want the Odoo skills in.

## Prerequisites

Ubuntu:
```bash
sudo apt update && sudo apt install -y git curl
```

macOS (either one):
```bash
xcode-select --install
```
```bash
brew install git
```

Nothing else is needed for this pack.

## One-liner (no manual clone)

```bash
curl -fsSL https://raw.githubusercontent.com/Znad-Odoo-DEV/odoo-senior-universal/main/install.sh | bash -s -- --tool cursor --version 19 --target .
```

`install.sh` clones (or updates) the repo into `~/.odoo-senior-universal`, copies the right files into `--target`, prints what it did, and exits non-zero with a clear message on a bad flag. It never deletes anything.

Flags: `--tool <cursor|copilot|agents|claude|all>` · `--version <17|18|19|20>` (default 19, used by `claude`) · `--upgrades` (also copy the upgrade guides into `.claude/skills/`) · `--target <dir>` (default: current directory). Run with `--help` for details.

## Manual install

Clone once:
```bash
git clone https://github.com/Znad-Odoo-DEV/odoo-senior-universal.git && cd odoo-senior-universal
```

### Cursor
```bash
mkdir -p <project>/.cursor/rules && cp -r .cursor/rules/* <project>/.cursor/rules/ && cp -r knowledge <project>/
```

### GitHub Copilot
```bash
mkdir -p <project>/.github && cp .github/copilot-instructions.md <project>/.github/ && cp -r knowledge <project>/
```

### Windsurf / Cline / Aider (AGENTS.md)
```bash
cp AGENTS.md <project>/ && cp -r knowledge <project>/
```

### Claude Code skills (`SKILL.md` is the native format)
Pick the Odoo version you work on (`odoo-17`, `odoo-18`, `odoo-19`, `odoo-20`).

Project-level:
```bash
mkdir -p <project>/.claude/skills && cp -r knowledge/odoo-19/* <project>/.claude/skills/
```

User-level (available in every project):
```bash
mkdir -p ~/.claude/skills && cp -r knowledge/odoo-19/* ~/.claude/skills/
```

Add the upgrade guides too:
```bash
cp -r knowledge/upgrades/* <project>/.claude/skills/
```

### ChatGPT / Gemini / any system prompt
Copy `SYSTEM_PROMPT.md` to the clipboard and paste it into the system prompt / custom instructions field.

macOS:
```bash
pbcopy < SYSTEM_PROMPT.md
```

Ubuntu (`sudo apt install -y xclip` once):
```bash
xclip -selection clipboard < SYSTEM_PROMPT.md
```

## Update

In the clone:
```bash
git pull
```
then re-run the copy command(s) above — or simply re-run `install.sh`, which pulls first.
