#!/bin/bash

# 🔄 SEO Pilot - Update Checker
# Checks if upstream skills have new versions

set -e

echo "🔄 SEO Pilot Update Checker"
echo "============================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Skills and their source repos
declare -A SKILLS
SKILLS["blog"]="https://github.com/AgriciDaniel/claude-blog"
SKILLS["seo"]="https://github.com/AgriciDaniel/claude-seo"
SKILLS["obsidian-skills"]="https://github.com/kepano/obsidian-skills"
SKILLS["diagram-design"]="https://github.com/cathrynlavery/diagram-design"

# Current local version (from git)
LOCAL_VERSION=$(git log -1 --format="%H" 2>/dev/null || echo "unknown")

echo "📦 Checking for updates..."
echo ""

UPDATES_AVAILABLE=0

for skill in "${!SKILLS[@]}"; do
    repo="${SKILLS[$skill]}"
    repo_name=$(basename "$repo")

    # Get latest commit from GitHub API
    LATEST_COMMIT=$(curl -s "https://api.github.com/repos/$repo/commits?per_page=1" | grep -o '"sha":"[^"]*"' | head -1 | cut -d'"' -f4 2>/dev/null)

    if [ -z "$LATEST_COMMIT" ]; then
        echo -e "  ${YELLOW}⚠️  $skill${NC} — could not check"
        continue
    fi

    # Check if we have a saved version
    VERSION_FILE="versions/$skill.version"
    mkdir -p versions

    if [ -f "$VERSION_FILE" ]; then
        SAVED_COMMIT=$(cat "$VERSION_FILE")
        if [ "$SAVED_COMMIT" != "$LATEST_COMMIT" ]; then
            echo -e "  ${YELLOW}🔄 $skill${NC} — update available!"
            UPDATES_AVAILABLE=$((UPDATES_AVAILABLE + 1))
        else
            echo -e "  ${GREEN}✅ $skill${NC} — up to date"
        fi
    else
        echo -e "  ${YELLOW}🆕 $skill${NC} — first time tracking"
    fi

    # Save latest version
    echo "$LATEST_COMMIT" > "$VERSION_FILE"
done

echo ""

if [ $UPDATES_AVAILABLE -gt 0 ]; then
    echo -e "${YELLOW}📋 $UPDATES_AVAILABLE skill(s) have updates.${NC}"
    echo ""
    echo "To update:"
    echo "  ./scripts/update-skills.sh"
else
    echo -e "${GREEN}✅ All skills are up to date!${NC}"
fi

echo ""
