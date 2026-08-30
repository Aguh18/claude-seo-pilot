#!/bin/bash

# 🔄 SEO Pilot - Update Checker
# Checks if upstream skills have new versions

set -e

echo "🔄 SEO Pilot Update Checker"
echo "============================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPOS="AgriciDaniel/claude-blog AgriciDaniel/claude-seo kepano/obsidian-skills cathrynlavery/diagram-design"

mkdir -p versions
UPDATES=0

for repo in $REPOS; do
    skill=$(echo "$repo" | cut -d'/' -f2)
    LATEST=$(gh api "repos/$repo/commits?per_page=1" --jq '.[0].sha' 2>/dev/null)

    if [ -z "$LATEST" ]; then
        echo -e "  ⚠️  $skill — could not check"
        continue
    fi

    VERSION_FILE="versions/$skill.version"

    if [ -f "$VERSION_FILE" ]; then
        SAVED=$(cat "$VERSION_FILE")
        if [ "$SAVED" != "$LATEST" ]; then
            echo -e "  ${YELLOW}🔄 $skill — update available!${NC}"
            UPDATES=$((UPDATES + 1))
        else
            echo -e "  ${GREEN}✅ $skill — up to date${NC}"
        fi
    else
        echo -e "  🆕 $skill — tracking started"
    fi

    echo "$LATEST" > "$VERSION_FILE"
done

echo ""
if [ $UPDATES -gt 0 ]; then
    echo -e "${YELLOW}📋 $UPDATES skill(s) have updates. Run: ./scripts/update-skills.sh${NC}"
else
    echo -e "${GREEN}✅ All upstream skills are up to date!${NC}"
fi
