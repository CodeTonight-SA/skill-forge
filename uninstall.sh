#!/bin/bash
# Skill Forge Uninstaller
# https://github.com/CodeTonight-SA/skill-forge

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
CLAUDE_DIR="$HOME/.claude"
SKILL_FORGE_DIR="$CLAUDE_DIR/skill-forge"
OUTPUT_STYLES_DIR="$CLAUDE_DIR/output-styles"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

echo -e "${BLUE}Skill Forge Uninstaller${NC}"
echo ""

# Function to print status
status() {
    echo -e "${GREEN}[+]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Confirm uninstall
confirm_uninstall() {
    echo "This will remove:"
    echo "  - $SKILL_FORGE_DIR"
    echo "  - $OUTPUT_STYLES_DIR/forging-skills.md (symlink)"
    echo ""
    echo "This will NOT remove:"
    echo "  - Your CLAUDE.md (only the Skill Forge section)"
    echo "  - Other Claude Code configuration"
    echo ""
    read -p "Continue with uninstallation? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstallation cancelled."
        exit 0
    fi
}

# Remove output style symlink
remove_output_style() {
    local style_target="$OUTPUT_STYLES_DIR/forging-skills.md"

    if [[ -L "$style_target" ]]; then
        status "Removing output style symlink"
        rm "$style_target"
    elif [[ -f "$style_target" ]]; then
        warn "Output style is a file, not symlink - preserving"
    else
        warn "Output style not found"
    fi
}

# Remove Skill Forge section from CLAUDE.md
clean_claude_md() {
    if [[ ! -f "$CLAUDE_MD" ]]; then
        warn "CLAUDE.md not found"
        return
    fi

    # Check if it's the standalone template
    if grep -q "^# Skill Forge$" "$CLAUDE_MD" && ! grep -q "^# " "$CLAUDE_MD" | grep -v "# Skill Forge" &>/dev/null; then
        # It's the standalone template, ask before removing
        echo ""
        read -p "CLAUDE.md appears to be only Skill Forge. Remove it? [y/N] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            status "Removing standalone CLAUDE.md"
            rm "$CLAUDE_MD"
        else
            warn "CLAUDE.md preserved"
        fi
    else
        # It has other content, just remove the Skill Forge section
        if grep -q "## Skill Forge" "$CLAUDE_MD"; then
            status "Removing Skill Forge section from CLAUDE.md"
            # Create backup
            cp "$CLAUDE_MD" "$CLAUDE_MD.pre-uninstall"

            # Remove the Skill Forge section (## Skill Forge until next ## or EOF)
            # This is a simple approach - removes from "## Skill Forge" to next "##" header
            awk '
                /^## Skill Forge/ { skip=1; next }
                /^## / { skip=0 }
                !skip { print }
            ' "$CLAUDE_MD.pre-uninstall" > "$CLAUDE_MD"

            # Remove trailing whitespace
            sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD" 2>/dev/null || true

            status "Backup saved to $CLAUDE_MD.pre-uninstall"
        else
            warn "No Skill Forge section found in CLAUDE.md"
        fi
    fi
}

# Remove Skill Forge directory
remove_skill_forge_dir() {
    if [[ -d "$SKILL_FORGE_DIR" ]]; then
        status "Removing Skill Forge directory"
        rm -rf "$SKILL_FORGE_DIR"
    else
        warn "Skill Forge directory not found"
    fi
}

# Print completion message
print_completion() {
    echo ""
    echo -e "${GREEN}Skill Forge has been uninstalled.${NC}"
    echo ""
    echo "If you have feedback, please visit:"
    echo "  https://github.com/CodeTonight-SA/skill-forge/issues"
    echo ""
}

# Main uninstall flow
main() {
    if [[ ! -d "$SKILL_FORGE_DIR" ]]; then
        echo "Skill Forge does not appear to be installed."
        exit 0
    fi

    confirm_uninstall

    remove_output_style
    clean_claude_md
    remove_skill_forge_dir

    print_completion
}

# Run main
main "$@"
