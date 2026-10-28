#!/usr/bin/env bash
# Install the Odoo senior knowledge pack into a project (Ubuntu / macOS; needs only git).
# Usage: install.sh --tool <cursor|copilot|agents|claude|all> [--version <17|18|19|20>] [--upgrades] [--target <dir>]
set -euo pipefail

REPO_URL="https://github.com/Znad-Odoo-DEV/odoo-senior-universal.git"
CACHE_DIR="${ODOO_SENIOR_CACHE:-$HOME/.odoo-senior-universal}"
TOOL=""
VERSION="19"
UPGRADES=0
TARGET="."

usage() {
  cat <<'USAGE'
Usage: install.sh --tool <cursor|copilot|agents|claude|all> [options]

  --tool <name>     cursor  -> .cursor/rules/ + knowledge/
                    copilot -> .github/copilot-instructions.md + knowledge/
                    agents  -> AGENTS.md (Windsurf / Cline / Aider) + knowledge/
                    claude  -> knowledge/odoo-<version>/* into .claude/skills/
                    all     -> everything above
  --version <n>     Odoo major for --tool claude: 17 | 18 | 19 | 20   (default: 19)
  --upgrades        with --tool claude, also copy knowledge/upgrades/* into .claude/skills/
  --target <dir>    project directory to install into             (default: current directory)
  -h, --help        show this help

The repository is cloned (or updated) into a cache: $HOME/.odoo-senior-universal
(override with ODOO_SENIOR_CACHE). Nothing outside the target and the cache is touched;
nothing is ever deleted.
USAGE
}

die() { echo "install.sh: $*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --tool)     [ $# -ge 2 ] || die "--tool needs a value";    TOOL="$2";    shift 2 ;;
    --version)  [ $# -ge 2 ] || die "--version needs a value"; VERSION="$2"; shift 2 ;;
    --target)   [ $# -ge 2 ] || die "--target needs a value";  TARGET="$2";  shift 2 ;;
    --upgrades) UPGRADES=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          die "unknown flag '$1' (run with --help)" ;;
  esac
done

[ -n "$TOOL" ] || { usage >&2; die "--tool is required"; }
case "$TOOL" in
  cursor|copilot|agents|claude|all) ;;
  *) die "bad --tool '$TOOL' (expected cursor|copilot|agents|claude|all)" ;;
esac
case "$VERSION" in
  17|18|19|20) ;;
  *) die "bad --version '$VERSION' (expected 17|18|19|20)" ;;
esac
command -v git >/dev/null 2>&1 || die "git is required (Ubuntu: sudo apt install -y git  |  macOS: xcode-select --install)"

# Clone or update the cache (never deletes anything).
if [ -d "$CACHE_DIR/.git" ]; then
  git -C "$CACHE_DIR" pull -q --ff-only </dev/null || die "could not update cache at $CACHE_DIR"
  echo "Updated cache: $CACHE_DIR"
elif [ -e "$CACHE_DIR" ]; then
  die "$CACHE_DIR exists but is not a git clone; move it away or set ODOO_SENIOR_CACHE to another path"
else
  git clone -q --depth 1 "$REPO_URL" "$CACHE_DIR" </dev/null || die "could not clone $REPO_URL"
  echo "Cloned into cache: $CACHE_DIR"
fi

KNOW="$CACHE_DIR/knowledge/odoo-$VERSION"
[ -d "$KNOW" ] || die "knowledge for Odoo $VERSION not found in $CACHE_DIR"

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
echo "Target: $TARGET"

copy_knowledge() {
  mkdir -p "$TARGET/knowledge"
  cp -R "$CACHE_DIR/knowledge/." "$TARGET/knowledge/"
  echo "  knowledge/ (all versions + upgrades) -> $TARGET/knowledge/"
}
do_cursor() {
  mkdir -p "$TARGET/.cursor/rules"
  cp -R "$CACHE_DIR/.cursor/rules/." "$TARGET/.cursor/rules/"
  echo "  .cursor/rules/* -> $TARGET/.cursor/rules/"
  copy_knowledge
}
do_copilot() {
  mkdir -p "$TARGET/.github"
  cp "$CACHE_DIR/.github/copilot-instructions.md" "$TARGET/.github/copilot-instructions.md"
  echo "  .github/copilot-instructions.md -> $TARGET/.github/"
  copy_knowledge
}
do_agents() {
  cp "$CACHE_DIR/AGENTS.md" "$TARGET/AGENTS.md"
  echo "  AGENTS.md -> $TARGET/"
  copy_knowledge
}
do_claude() {
  mkdir -p "$TARGET/.claude/skills"
  cp -R "$KNOW/." "$TARGET/.claude/skills/"
  echo "  knowledge/odoo-$VERSION/* -> $TARGET/.claude/skills/"
  if [ "$UPGRADES" -eq 1 ]; then
    cp -R "$CACHE_DIR/knowledge/upgrades/." "$TARGET/.claude/skills/"
    echo "  knowledge/upgrades/* -> $TARGET/.claude/skills/"
  fi
}

echo "Installing ($TOOL, Odoo $VERSION):"
case "$TOOL" in
  cursor)  do_cursor ;;
  copilot) do_copilot ;;
  agents)  do_agents ;;
  claude)  do_claude ;;
  all)     do_cursor; do_copilot; do_agents; do_claude ;;
esac
echo "Done. To update later: re-run this script (the cache is git-pulled first)."
