#!/bin/bash

# 🧰 Freelance - Installer
# Install: curl -fsSL https://raw.githubusercontent.com/Aguh18/claude-seo-pilot/main/install.sh | bash
# Repo: https://github.com/Aguh18/claude-seo-pilot

set -e

VERSION="1.0.0"
SKILLS_DIR="$HOME/.claude/skills"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}🧰  Freelance v${VERSION}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

# Determine source
if [ -n "${FREELANCE_REF:-}" ]; then
    BRANCH="$FREELANCE_REF"
else
    BRANCH="main"
fi

# Clone or use local
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

if [ -d "./skills" ] && [ -f "./skills/freelance/SKILL.md" ]; then
    echo -e "${BOLD}📦 Installing from local...${NC}"
    SRC_DIR="."
else
    echo -e "${BOLD}📥 Downloading Freelance (${BRANCH})...${NC}"
    git clone --depth 1 -b "$BRANCH" "https://github.com/Aguh18/claude-seo-pilot.git" "$TEMP_DIR/freelance" 2>/dev/null
    SRC_DIR="$TEMP_DIR/freelance"
fi

echo ""

# Install skills
echo -e "${BOLD}📦 Installing skills...${NC}"
echo ""

for skill in freelance blog seo ads obsidian-tools diagram-design defuddle knap high-end-visual-design design-taste-frontend frontend-design; do
    if [ -d "$SRC_DIR/skills/$skill" ]; then
        echo -e "  ${GREEN}✅${NC} $skill"
        cp -r "$SRC_DIR/skills/$skill" "$SKILLS_DIR/"
    fi
done

# Install sub-skills (blog-*, seo-*, ads-*)
echo ""
echo -e "${BOLD}📦 Installing sub-skills...${NC}"
echo ""

for skill_dir in "$SRC_DIR/skills/blog-"*/ "$SRC_DIR/skills/seo-"*/ "$SRC_DIR/skills/ads-"*/; do
    if [ -d "$skill_dir" ]; then
        name=$(basename "$skill_dir")
        echo -e "  ${GREEN}✅${NC} $name"
        cp -r "$skill_dir" "$SKILLS_DIR/"
    fi
done

# Install defuddle
echo ""
echo -e "${BOLD}📦 Installing defuddle CLI...${NC}"
if command -v npm &> /dev/null; then
    npm install -g defuddle 2>/dev/null && echo -e "  ${GREEN}✅${NC} defuddle" || echo -e "  ${YELLOW}⚠️${NC} defuddle failed — install manually: npm install -g defuddle"
else
    echo -e "  ${YELLOW}⚠️${NC} npm not found — install defuddle manually"
fi

# Install ads core modules
echo ""
echo -e "${BOLD}📦 Installing ads core modules...${NC}"
if [ -d "$SRC_DIR/claude_ads_core" ]; then
    mkdir -p "$HOME/.freelance/modules"
    cp -r "$SRC_DIR/claude_ads_core" "$HOME/.freelance/modules/"
    echo -e "  ${GREEN}✅${NC} claude_ads_core"
fi
if [ -d "$SRC_DIR/control-plane" ]; then
    cp -r "$SRC_DIR/control-plane" "$HOME/.freelance/modules/"
    echo -e "  ${GREEN}✅${NC} control-plane"
fi

# Install orchestrator script
echo ""
echo -e "${BOLD}📦 Installing orchestrator...${NC}"
ORCH_SRC="$SRC_DIR/skills/freelance/scripts/freelance.sh"
if [ -f "$ORCH_SRC" ]; then
    # Refuse to overwrite a ~/.freelance that this tool did not create
    if [ -d "$HOME/.freelance" ] && [ ! -f "$HOME/.freelance/freelance.sh" ]; then
        echo -e "  ${RED}✖${NC} $HOME/.freelance already exists and was not created by this installer."
        echo "     Move it aside first, then re-run."
    else
        mkdir -p "$HOME/.freelance"
        cp "$ORCH_SRC" "$HOME/.freelance/"
        # status.py sits beside the script — freelance.sh resolves it via dirname "$0"
        cp "$SRC_DIR/skills/freelance/scripts/status.py" "$HOME/.freelance/"
        chmod +x "$HOME/.freelance/freelance.sh"
        echo -e "  ${GREEN}✅${NC} freelance.sh"

        # Create symlink for easy access
        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.freelance/freelance.sh" "$HOME/.local/bin/freelance" 2>/dev/null || true
    fi
else
    # A silent failure here would leave the CLI missing while still reporting success
    echo -e "  ${RED}✖${NC} Orchestrator not found at skills/freelance/scripts/freelance.sh"
    echo "     The skill is installed, but the standalone CLI is not."
fi

echo ""
echo -e "${GREEN}${BOLD}✅ Installation complete!${NC}"
echo ""
echo -e "  🔄 Restart Claude Code to activate."
echo ""
echo -e "  ${BOLD}Quick start:${NC}"
echo "    /freelance init <name-or-url>   Discovery → 9-document handoff bundle"
echo "    /freelance audit <url>          Full SEO audit"
echo "    /freelance blog-write <topic>   SEO content pipeline"
echo "    /freelance ads <url>            Ads strategy"
echo "    /freelance status               Check progress"
echo ""
