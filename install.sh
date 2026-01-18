#!/bin/bash
# Skill Forge Installer
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
REPO_URL="https://github.com/CodeTonight-SA/skill-forge"

echo -e "${BLUE}"
echo "  _____ _    _ _ _   _____                    "
echo " / ____| |  (_) | | |  ___|                   "
echo "| (___ | | ___| | | | |_ ___  _ __ __ _  ___  "
echo " \___ \| |/ / | | | |  _/ _ \| '__/ _\` |/ _ \ "
echo " ____) |   <| | | | | || (_) | | | (_| |  __/ "
echo "|_____/|_|\_\_|_|_| \_| \___/|_|  \__, |\___| "
echo "                                   __/ |      "
echo "                                  |___/       "
echo -e "${NC}"
echo "The sharpest sword is forged through use, not observation."
echo ""

# Detect installation mode
LOCAL_MODE=false
if [[ "$1" == "--local" ]]; then
    LOCAL_MODE=true
    echo -e "${YELLOW}Local mode: Using existing cloned repository${NC}"
fi

# Function to print status
status() {
    echo -e "${GREEN}[+]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[x]${NC} $1"
    exit 1
}

# Check for Claude CLI (optional but recommended)
check_claude_cli() {
    if command -v claude &> /dev/null; then
        status "Claude CLI detected"
        return 0
    else
        warn "Claude CLI not found (optional)"
        echo "    Skill Forge works best with Claude CLI installed."
        echo "    Install: npm install -g @anthropic-ai/claude-code"
        return 1
    fi
}

# Detect installation scenario
detect_scenario() {
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        echo "no-claude-dir"
    elif [[ -d "$SKILL_FORGE_DIR" ]]; then
        echo "upgrade"
    elif [[ -f "$CLAUDE_MD" ]]; then
        echo "merge"
    else
        echo "fresh"
    fi
}

# Create ~/.claude directory if needed
ensure_claude_dir() {
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        status "Creating ~/.claude directory"
        mkdir -p "$CLAUDE_DIR"
    fi
}

# Create output-styles directory if needed
ensure_output_styles_dir() {
    if [[ ! -d "$OUTPUT_STYLES_DIR" ]]; then
        status "Creating output-styles directory"
        mkdir -p "$OUTPUT_STYLES_DIR"
    fi
}

# Download/clone Skill Forge
install_skill_forge() {
    if [[ "$LOCAL_MODE" == true ]]; then
        # Already in the repo, copy to target location
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [[ "$SCRIPT_DIR" != "$SKILL_FORGE_DIR" ]]; then
            status "Copying Skill Forge to $SKILL_FORGE_DIR"
            cp -r "$SCRIPT_DIR" "$SKILL_FORGE_DIR"
        fi
    else
        if command -v git &> /dev/null; then
            status "Cloning Skill Forge repository"
            git clone --depth 1 "$REPO_URL" "$SKILL_FORGE_DIR"
        else
            error "git is required for installation. Please install git first."
        fi
    fi
}

# Upgrade existing installation
upgrade_skill_forge() {
    status "Upgrading existing Skill Forge installation"

    # Backup config if exists
    if [[ -f "$SKILL_FORGE_DIR/config.json" ]]; then
        cp "$SKILL_FORGE_DIR/config.json" "$SKILL_FORGE_DIR/config.json.backup"
        status "Backed up config.json"
    fi

    # Pull latest or re-clone
    if [[ -d "$SKILL_FORGE_DIR/.git" ]]; then
        cd "$SKILL_FORGE_DIR"
        git pull origin main
    else
        rm -rf "$SKILL_FORGE_DIR"
        install_skill_forge
    fi

    # Restore config
    if [[ -f "$SKILL_FORGE_DIR/config.json.backup" ]]; then
        mv "$SKILL_FORGE_DIR/config.json.backup" "$SKILL_FORGE_DIR/config.json"
        status "Restored config.json"
    fi
}

# Setup CLAUDE.md
setup_claude_md() {
    local scenario="$1"

    case "$scenario" in
        "no-claude-dir"|"fresh")
            status "Creating CLAUDE.md with standalone template"
            cp "$SKILL_FORGE_DIR/claude-md/standalone.md" "$CLAUDE_MD"
            ;;
        "merge")
            # Backup existing CLAUDE.md
            status "Backing up existing CLAUDE.md"
            cp "$CLAUDE_MD" "$CLAUDE_MD.backup"

            # Check if Skill Forge section already exists
            if grep -q "## Skill Forge" "$CLAUDE_MD" 2>/dev/null; then
                warn "Skill Forge section already exists in CLAUDE.md"
                echo "    Skipping merge to avoid duplicates."
            else
                status "Appending Skill Forge to existing CLAUDE.md"
                echo "" >> "$CLAUDE_MD"
                cat "$SKILL_FORGE_DIR/claude-md/merge-snippet.md" >> "$CLAUDE_MD"
            fi
            ;;
        "upgrade")
            status "CLAUDE.md unchanged (upgrade mode)"
            ;;
    esac
}

# Setup output style symlink
setup_output_style() {
    ensure_output_styles_dir

    local style_source="$SKILL_FORGE_DIR/output-style/forging-skills.md"
    local style_target="$OUTPUT_STYLES_DIR/forging-skills.md"

    if [[ -L "$style_target" ]]; then
        # Remove existing symlink
        rm "$style_target"
    elif [[ -f "$style_target" ]]; then
        # Backup existing file
        mv "$style_target" "$style_target.backup"
        warn "Backed up existing output style to $style_target.backup"
    fi

    status "Linking output style"
    ln -s "$style_source" "$style_target"
}

# Create default config
create_default_config() {
    local config_file="$SKILL_FORGE_DIR/config.json"

    if [[ ! -f "$config_file" ]]; then
        status "Creating default configuration"
        cat > "$config_file" << 'EOF'
{
  "gates": {
    "review": {
      "min_operations": 15,
      "max_operations": 25
    },
    "write": {
      "min_operations": 25,
      "max_operations": 40,
      "random_chance": 0.10
    },
    "architect": {
      "trigger": "multi-file"
    }
  },
  "complexity": {
    "default": 2,
    "min": 1,
    "max": 5
  },
  "tracking": {
    "silent_skips": true,
    "adaptive_difficulty": true
  }
}
EOF
    fi
}

# Verify installation
verify_installation() {
    local errors=0

    echo ""
    echo "Verifying installation..."
    echo ""

    # Check skill files
    if [[ -f "$SKILL_FORGE_DIR/skill/SKILL.md" ]]; then
        status "Core skill files: OK"
    else
        error "Core skill files: MISSING"
        ((errors++))
    fi

    # Check output style
    if [[ -L "$OUTPUT_STYLES_DIR/forging-skills.md" ]]; then
        status "Output style: OK"
    else
        warn "Output style: Not linked"
        ((errors++))
    fi

    # Check CLAUDE.md
    if [[ -f "$CLAUDE_MD" ]]; then
        status "CLAUDE.md: OK"
    else
        warn "CLAUDE.md: Missing (create manually if needed)"
    fi

    # Check config
    if [[ -f "$SKILL_FORGE_DIR/config.json" ]]; then
        status "Configuration: OK"
    else
        warn "Configuration: Missing"
    fi

    return $errors
}

# Print completion message
print_completion() {
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Skill Forge installed successfully!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo "To activate:"
    echo "  1. Start Claude Code: claude"
    echo "  2. Activate forge mode: /output-style forging-skills"
    echo ""
    echo "Documentation:"
    echo "  - Usage guide: $SKILL_FORGE_DIR/docs/USAGE.md"
    echo "  - Philosophy: $SKILL_FORGE_DIR/PHILOSOPHY.md"
    echo "  - Configuration: $SKILL_FORGE_DIR/config.json"
    echo ""
    echo "The sharpest sword is forged through use, not observation."
    echo ""
}

# Main installation flow
main() {
    echo "Starting installation..."
    echo ""

    check_claude_cli || true

    local scenario
    scenario=$(detect_scenario)
    status "Detected scenario: $scenario"

    ensure_claude_dir

    if [[ "$scenario" == "upgrade" ]]; then
        upgrade_skill_forge
    else
        install_skill_forge
    fi

    setup_claude_md "$scenario"
    setup_output_style
    create_default_config

    if verify_installation; then
        print_completion
    else
        warn "Installation completed with warnings"
        print_completion
    fi
}

# Run main
main "$@"
