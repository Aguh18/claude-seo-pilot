#!/bin/bash

# 🔧 SEO Marketing Toolkit - Installer
# Installs all skills to ~/.claude/skills/

set -e

echo "🔧 SEO Marketing Toolkit Installer"
echo "=================================="
echo ""

# Check if ~/.claude/skills exists
SKILLS_DIR="$HOME/.claude/skills"
if [ ! -d "$SKILLS_DIR" ]; then
    echo "📁 Creating skills directory..."
    mkdir -p "$SKILLS_DIR"
fi

# Get script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing skills..."
echo ""

# Install each skill
for skill in seo-marketing blog seo obsidian-tools diagram-design; do
    if [ -d "$SCRIPT_DIR/skills/$skill" ]; then
        echo "  ✅ Installing $skill..."
        cp -r "$SCRIPT_DIR/skills/$skill" "$SKILLS_DIR/"
    fi
done

echo ""
echo "📦 Installing defuddle CLI..."
if command -v npm &> /dev/null; then
    npm install -g defuddle 2>/dev/null || echo "  ⚠️  defuddle install failed - install manually: npm install -g defuddle"
else
    echo "  ⚠️  npm not found - install defuddle manually: npm install -g defuddle"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔄 Restart Claude Code to use new skills."
echo ""
echo "📚 Quick start:"
echo "   /seo-marketing research <url>"
echo "   /blog write <topic>"
echo "   /seo-audit <url>"
echo ""
