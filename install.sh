#!/usr/bin/env bash
# ============================================================================
# Cline AI Rules Installer — macOS / Linux
# Idempotent: safe to run multiple times. Only replaces targeted files.
# ============================================================================

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Resolve script directory (where this repo is cloned)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target paths
RULES_DIR="$HOME/Documents/Cline/Rules"
WORKFLOWS_DIR="$HOME/Documents/Cline/Workflows"
SKILLS_DIR="$HOME/.agents/skills/plan-creator"

# Source paths
SRC_RULES="$SCRIPT_DIR/Cline/Rules"
SRC_WORKFLOWS="$SCRIPT_DIR/Cline/Workflows"
SRC_SKILL="$SCRIPT_DIR/Cline/Skills/plan-creator"

echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Cline AI Rules v2.0.1 — Installer          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# --- Uninstall mode ---
if [ "${1:-}" = "--uninstall" ]; then
    echo -e "${YELLOW}Uninstalling Cline AI Rules...${NC}"
    for dir in "$RULES_DIR" "$WORKFLOWS_DIR" "$SKILLS_DIR"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            echo -e "  ${GREEN}✓${NC} Removed: $dir"
        else
            echo -e "  — Not found: $dir"
        fi
    done
    echo ""
    echo -e "${GREEN}Uninstall complete.${NC}"
    exit 0
fi

# --- Validate source files exist ---
if [ ! -d "$SRC_RULES" ]; then
    echo -e "${YELLOW}✗ Source directory not found: $SRC_RULES${NC}"
    echo "  Make sure you're running this script from the repository root."
    exit 1
fi

# --- Helper: install files from source dir to target dir ---
install_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"
    local pattern="${4:-*.md}"

    # Create directory if missing
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
        echo -e "  ${GREEN}Created${NC} $dest_dir"
    fi

    # Copy files (overwrite existing)
    local count=0
    for file in "$src_dir"/$pattern; do
        [ -f "$file" ] || continue
        cp -f "$file" "$dest_dir/"
        count=$((count + 1))
    done

    echo -e "  ${GREEN}✓${NC} $label: ${count} file(s) → $dest_dir"
}

# --- 1. Rules ---
echo -e "${CYAN}[1/3]${NC} Installing Rules..."
install_files "$SRC_RULES" "$RULES_DIR" "Rules"

# --- 2. Workflows ---
echo -e "${CYAN}[2/3]${NC} Installing Workflows..."
install_files "$SRC_WORKFLOWS" "$WORKFLOWS_DIR" "Workflows"

# --- 3. Skill + Templates ---
echo -e "${CYAN}[3/3]${NC} Installing Skill + Templates..."

# Skill directory
if [ ! -d "$SKILLS_DIR" ]; then
    mkdir -p "$SKILLS_DIR"
    echo -e "  ${GREEN}Created${NC} $SKILLS_DIR"
fi

# SKILL.md
cp -f "$SRC_SKILL/SKILL.md" "$SKILLS_DIR/"
echo -e "  ${GREEN}✓${NC} SKILL.md → $SKILLS_DIR"

# Templates directory
TEMPLATES_SRC="$SRC_SKILL/templates"
TEMPLATES_DEST="$SKILLS_DIR/templates"

if [ -d "$TEMPLATES_SRC" ]; then
    if [ ! -d "$TEMPLATES_DEST" ]; then
        mkdir -p "$TEMPLATES_DEST"
        echo -e "  ${GREEN}Created${NC} $TEMPLATES_DEST"
    fi

    count=0
    for file in "$TEMPLATES_SRC"/*.md; do
        [ -f "$file" ] || continue
        cp -f "$file" "$TEMPLATES_DEST/"
        count=$((count + 1))
    done
    echo -e "  ${GREEN}✓${NC} Templates: ${count} file(s) → $TEMPLATES_DEST"
else
    echo -e "  ${YELLOW}⚠${NC} Templates directory not found in source — skipping"
fi

# --- Summary ---
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Installation complete! (v2.0.1)            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Rules:     $RULES_DIR"
echo -e "  Workflows: $WORKFLOWS_DIR"
echo -e "  Skill:     $SKILLS_DIR"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Open your IDE (VS Code, JetBrains, etc.)"
echo "  2. Click the Rules icon in Cline to verify 8 rule files (00-07) are ON"
echo "  3. Type 'follow rules' to start a session"
echo ""
