#!/bin/bash

# 🔄 SEO Pilot - Skill Updater
# Downloads latest versions of all upstream skills

set -e

echo "🔄 SEO Pilot Skill Updater"
echo "==========================="
echo ""

# Temporary directory for downloads
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Skills and their source repos
declare -A SKILLS
SKILLS["blog"]="https://github.com/AgriciDaniel/claude-blog"
SKILLS["seo"]="https://github.com/AgriciDaniel/claude-seo"
SKILLS["obsidian-tools"]="https://github.com/kepano/obsidian-skills"
SKILLS["diagram-design"]="https://github.com/cathrynlavery/diagram-design"

for skill in "${!SKILLS[@]}"; do
    repo="${SKILLS[$skill]}"
    echo "📥 Updating $skill from $repo..."

    # Clone repo (shallow)
    git clone --depth 1 "$repo" "$TEMP_DIR/$skill" 2>/dev/null

    if [ -d "$TEMP_DIR/$skill" ]; then
        # Find skills directory (varies by repo)
        if [ -d "$TEMP_DIR/$skill/skills" ]; then
            cp -r "$TEMP_DIR/$skill/skills/"* "skills/$skill/" 2>/dev/null || true
        elif [ -d "$TEMP_DIR/$skill/$skill" ]; then
            cp -r "$TEMP_DIR/$skill/$skill/"* "skills/$skill/" 2>/dev/null || true
        else
            # Copy root files
            cp -r "$TEMP_DIR/$skill/"* "skills/$skill/" 2>/dev/null || true
        fi

        # Update version tracker
        LATEST_COMMIT=$(git -C "$TEMP_DIR/$skill" log -1 --format="%H")
        mkdir -p versions
        echo "$LATEST_COMMIT" > "versions/$skill.version"

        echo "  ✅ $skill updated"
    else
        echo "  ❌ Failed to clone $skill"
    fi

    echo ""
done

echo "🎉 All skills updated!"
echo ""
echo "Restart Claude Code to use latest versions."
echo ""
