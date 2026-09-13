#!/bin/bash

# 🔄 SEO Pilot - Skill Updater
# Downloads latest + syncs to ~/.claude/skills/

set -e

echo "🔄 SEO Pilot Skill Updater"
echo "==========================="
echo ""

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

GLOBAL_DIR="$HOME/.claude/skills"
REPOS="AgriciDaniel/claude-blog AgriciDaniel/claude-seo kepano/obsidian-skills cathrynlavery/diagram-design"

for repo in $REPOS; do
    skill=$(echo "$repo" | cut -d'/' -f2)
    echo "📥 Updating $skill from $repo..."

    git clone --depth 1 "https://github.com/$repo.git" "$TEMP_DIR/$skill" 2>/dev/null

    if [ -d "$TEMP_DIR/$skill" ]; then
        # Find skills directory
        if [ -d "$TEMP_DIR/$skill/skills" ]; then
            for d in "$TEMP_DIR/$skill/skills/"*/; do
                name=$(basename "$d")
                # Copy to local toolkit
                mkdir -p "skills/$name"
                cp -r "$d"* "skills/$name/" 2>/dev/null || true
                # Copy to global ~/.claude/skills/
                mkdir -p "$GLOBAL_DIR/$name"
                cp -r "$d"* "$GLOBAL_DIR/$name/" 2>/dev/null || true
            done
        else
            mkdir -p "skills/$skill"
            cp -r "$TEMP_DIR/$skill/"* "skills/$skill/" 2>/dev/null || true
            mkdir -p "$GLOBAL_DIR/$skill"
            cp -r "$TEMP_DIR/$skill/"* "$GLOBAL_DIR/$skill/" 2>/dev/null || true
        fi

        LATEST=$(git -C "$TEMP_DIR/$skill" log -1 --format="%H")
        echo "$LATEST" > "versions/$skill.version"
        echo "  ✅ $skill updated (local + global)"
    else
        echo "  ❌ Failed to clone $skill"
    fi
    echo ""
done

echo "🎉 Done! All skills updated and synced to ~/.claude/skills/"
echo "   Restart Claude Code to use latest versions."
