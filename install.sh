#!/bin/bash

# ✈️ SEO Pilot - Installer
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
echo -e "${CYAN}✈️  SEO Pilot v${VERSION}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

# Determine source
if [ -n "${SEO_PILOT_REF:-}" ]; then
    BRANCH="$SEO_PILOT_REF"
else
    BRANCH="main"
fi

# Clone or use local
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

if [ -d "./skills" ] && [ -f "./skills/seo-pilot/SKILL.md" ]; then
    echo -e "${BOLD}📦 Installing from local...${NC}"
    SRC_DIR="."
else
    echo -e "${BOLD}📥 Downloading SEO Pilot (${BRANCH})...${NC}"
    git clone --depth 1 -b "$BRANCH" "https://github.com/Aguh18/claude-seo-pilot.git" "$TEMP_DIR/seo-pilot" 2>/dev/null
    SRC_DIR="$TEMP_DIR/seo-pilot"
fi

echo ""

# Install skills
echo -e "${BOLD}📦 Installing skills...${NC}"
echo ""

for skill in seo-pilot blog seo obsidian-tools diagram-design; do
    if [ -d "$SRC_DIR/skills/$skill" ]; then
        echo -e "  ${GREEN}✅${NC} $skill"
        cp -r "$SRC_DIR/skills/$skill" "$SKILLS_DIR/"
    fi
done

# Install sub-skills (blog-*, seo-*)
echo ""
echo -e "${BOLD}📦 Installing sub-skills...${NC}"
echo ""

for skill_dir in "$SRC_DIR/skills/blog-"*/ "$SRC_DIR/skills/seo-"*/; do
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

# Install orchestrator script
echo ""
echo -e "${BOLD}📦 Installing orchestrator...${NC}"
mkdir -p "$HOME/.seo-pilot"
if [ -f "$SRC_DIR/scripts/seo-pilot.sh" ]; then
    cp "$SRC_DIR/scripts/seo-pilot.sh" "$HOME/.seo-pilot/"
    chmod +x "$HOME/.seo-pilot/seo-pilot.sh"
    echo -e "  ${GREEN}✅${NC} seo-pilot.sh"

    # Create symlink for easy access
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.seo-pilot/seo-pilot.sh" "$HOME/.local/bin/seo-pilot" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}${BOLD}✅ Installation complete!${NC}"
echo ""
echo -e "  🔄 Restart Claude Code to activate."
echo ""
echo -e "  ${BOLD}Quick start:${NC}"
echo "    /seo-pilot init          Setup project"
echo "    /seo-pilot status        Check progress"
echo "    /seo-pilot research      Research phase"
echo "    /seo-pilot content       Content phase"
echo "    /seo-pilot optimize      SEO phase"
echo ""
