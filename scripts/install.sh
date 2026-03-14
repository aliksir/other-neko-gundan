#!/bin/bash
# other-neko-gundan installer
# Copies adapter files and rules to a target project directory.
#
# Usage:
#   bash other-neko-gundan/scripts/install.sh [target-project-dir]
#
# If no target is given, installs into the current directory.

set -e

# ── helpers ──────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEKO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

info()    { echo "[neko-gundan] $*"; }
success() { echo "[neko-gundan] OK  $*"; }
warn()    { echo "[neko-gundan] WARN $*"; }
fail()    { echo "[neko-gundan] FAIL $*" >&2; exit 1; }

# ── argument handling ─────────────────────────────────────────────────────────

TARGET_DIR="${1:-$(pwd)}"

if [ ! -d "$TARGET_DIR" ]; then
  fail "Target directory does not exist: $TARGET_DIR"
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
info "Installing neko-gundan rules into: $TARGET_DIR"

# ── CLI detection ─────────────────────────────────────────────────────────────

DETECTED_CLIS=()

if command -v codex &>/dev/null; then
  DETECTED_CLIS+=("codex")
  info "Detected: Codex CLI"
fi

if command -v gemini &>/dev/null; then
  DETECTED_CLIS+=("gemini")
  info "Detected: Gemini CLI"
fi

if command -v aider &>/dev/null; then
  DETECTED_CLIS+=("aider")
  info "Detected: Aider"
fi

if [ ${#DETECTED_CLIS[@]} -eq 0 ]; then
  warn "No supported CLI detected (codex / gemini / aider)."
  warn "Rules will be copied but no adapter will be installed."
  warn "Manually copy the adapter from adapters/ that matches your CLI."
fi

# ── safe copy helper ──────────────────────────────────────────────────────────
# Does not overwrite existing files unless the user confirms.

safe_copy() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ]; then
    printf "[neko-gundan] '%s' already exists. Overwrite? [y/N] " "$dst"
    read -r answer
    case "$answer" in
      [yY]|[yY][eE][sS]) ;;
      *) warn "Skipped: $dst"; return 0 ;;
    esac
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  success "Copied: $(basename "$dst")"
}

safe_copy_dir() {
  local src_dir="$1"
  local dst_dir="$2"

  mkdir -p "$dst_dir"

  # Find all files inside src_dir
  while IFS= read -r -d '' file; do
    relative="${file#$src_dir/}"
    safe_copy "$file" "$dst_dir/$relative"
  done < <(find "$src_dir" -type f -print0)
}

# ── copy rules/ ───────────────────────────────────────────────────────────────

info "Copying rules/..."
safe_copy_dir "$NEKO_ROOT/rules" "$TARGET_DIR/rules"

# ── copy templates/ ───────────────────────────────────────────────────────────

info "Copying templates/..."
safe_copy_dir "$NEKO_ROOT/templates" "$TARGET_DIR/templates"

# ── copy adapter files ────────────────────────────────────────────────────────

for cli in "${DETECTED_CLIS[@]}"; do
  case "$cli" in

    codex)
      info "Installing Codex adapter (AGENTS.md)..."
      safe_copy "$NEKO_ROOT/adapters/codex/AGENTS.md" "$TARGET_DIR/AGENTS.md"
      ;;

    gemini)
      info "Installing Gemini adapter (GEMINI.md)..."
      safe_copy "$NEKO_ROOT/adapters/gemini/GEMINI.md" "$TARGET_DIR/GEMINI.md"
      ;;

    aider)
      info "Installing Aider adapter (.aider.conf.yml + conventions.md)..."
      safe_copy "$NEKO_ROOT/adapters/aider/.aider.conf.yml" "$TARGET_DIR/.aider.conf.yml"
      safe_copy "$NEKO_ROOT/adapters/aider/conventions.md"  "$TARGET_DIR/conventions.md"
      ;;

  esac
done

# ── done ──────────────────────────────────────────────────────────────────────

echo ""
echo "=========================================="
echo " neko-gundan install complete!"
echo "=========================================="
echo ""
echo "Installed to: $TARGET_DIR"
echo ""
if [ ${#DETECTED_CLIS[@]} -gt 0 ]; then
  echo "Adapters installed for: ${DETECTED_CLIS[*]}"
else
  echo "No adapter installed (no supported CLI detected)."
  echo "Copy the matching file from:"
  echo "  adapters/codex/AGENTS.md      -> project root (Codex CLI)"
  echo "  adapters/gemini/GEMINI.md     -> project root (Gemini CLI)"
  echo "  adapters/aider/               -> project root (Aider)"
fi
echo ""
echo "Next steps:"
echo "  1. Review rules/ to understand the quality protocols"
echo "  2. Use templates/plan.md when starting a new task"
echo "  3. Use templates/checklist.md to track completion"
echo ""
