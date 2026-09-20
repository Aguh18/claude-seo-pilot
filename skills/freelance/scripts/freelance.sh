#!/bin/bash

# 🧰 Freelance - Main Orchestrator
# State tracker + phase router for client web-build projects

set -e

VERSION="1.0.0"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Config
PROJECT_FILE=".freelance-project.md"
STATE_FILE=".freelance-state.json"
LOG_FILE=".freelance.log"

# Projects initialized before the seo-pilot → freelance rename keep working untouched
LEGACY_PROJECT_FILE=".seo-project.md"
LEGACY_STATE_FILE=".seo-state.json"

# ─── Helpers ───────────────────────────────────────────

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

resolve_state_files() {
    if [ ! -f "$PROJECT_FILE" ] && [ -f "$LEGACY_PROJECT_FILE" ]; then
        PROJECT_FILE="$LEGACY_PROJECT_FILE"
    fi
    if [ ! -f "$STATE_FILE" ] && [ -f "$LEGACY_STATE_FILE" ]; then
        STATE_FILE="$LEGACY_STATE_FILE"
    fi
}

banner() {
    echo ""
    echo -e "${CYAN}🧰  Freelance v${VERSION}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

check_project() {
    if [ ! -f "$PROJECT_FILE" ]; then
        echo -e "${RED}❌ Project not initialized.${NC}"
        echo "   Run: /freelance init"
        exit 1
    fi
}

check_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"project":"","last_updated":"","steps":{"discovery":{"research":"pending","interview":"pending","confirm":"pending"},"bundle":{"brief":"pending","brand":"pending","tokens":"pending","sitemap":"pending","content":"pending","tech_spec":"pending","seo":"pending","layout":"pending","handoff":"pending","build_prompt":"pending"},"research":{"competitor":"pending","keywords":"pending","serp":"pending","market_analysis":"pending"},"content":{"brief":"pending","outline":"pending","write":"pending","review":"pending"},"seo":{"onpage":"pending","technical":"pending","geo":"pending","schema":"pending"},"ads":{"platform_audit":"pending","competitor_ads":"pending","budget_plan":"pending","strategy_report":"pending"},"publish":{"obsidian":"pending","blog":"pending","social_media":"pending"}},"history":[]}' > "$STATE_FILE"
    fi
}

get_step() {
    # Usage: get_step phase step
    python3 -c "
import json, sys
with open('$STATE_FILE') as f:
    data = json.load(f)
print(data['steps']['$1']['$2'])
" 2>/dev/null || echo "pending"
}

set_step() {
    # Usage: set_step phase step status
    python3 -c "
import json, datetime
with open('$STATE_FILE', 'r') as f:
    data = json.load(f)
data['steps']['$1']['$2'] = '$3'
data['last_updated'] = datetime.datetime.now().isoformat()
if '$3' == 'done':
    data['history'].append({
        'step': '$1.$2',
        'status': 'done',
        'timestamp': datetime.datetime.now().isoformat()
    })
with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# ─── Commands ──────────────────────────────────────────

cmd_init() {
    banner
    echo -e "${BOLD}🚀 Initializing Freelance project...${NC}"
    echo ""

    if [ -f "$PROJECT_FILE" ]; then
        echo -e "${YELLOW}⚠️  $PROJECT_FILE already exists.${NC}"
        read -p "   Overwrite? (y/N): " confirm
        if [ "$confirm" != "y" ]; then
            echo "   Cancelled."
            return
        fi
    fi

    # Get client identity
    read -p "   Client / project name: " project_name
    read -p "   Website URL (blank if the site does not exist yet): " website_url
    read -p "   Business type (company-profile/umkm-kuliner/umkm-fashion/ecommerce/blog/other): " biz_type

    # Branch B (no site yet) is the common case here — the whole point is selling the build
    if [ -z "$website_url" ]; then
        echo "   ⓘ  No URL — /freelance init will research the market and draft a proposal"
    fi

    # Generate .freelance-project.md
    cat > "$PROJECT_FILE" << EOF
---
project_name: "$project_name"
website: "$website_url"
business_type: "$biz_type"

brand_voice:
  tone: ""
  style: ""
  personality: ""

target_audience:
  age_range: ""
  location: ""

products: []

primary_keywords: []

competitors: []
---

# $project_name

Client web-build project${website_url:+ — $website_url}

## Setup Checklist

- [ ] Fill in products / services
- [ ] Add primary keywords
- [ ] Add competitors
- [ ] Configure brand voice
- [ ] Set target audience
EOF

    # Generate .freelance-state.json
    cat > "$STATE_FILE" << EOF
{
  "project": "$project_name",
  "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "steps": {
    "discovery": { "research": "pending", "interview": "pending", "confirm": "pending" },
    "bundle": { "brief": "pending", "brand": "pending", "tokens": "pending", "sitemap": "pending", "layout": "pending", "content": "pending", "tech_spec": "pending", "seo": "pending", "handoff": "pending", "build_prompt": "pending" },
    "research": { "competitor": "pending", "keywords": "pending", "serp": "pending", "market_analysis": "pending" },
    "content": { "brief": "pending", "outline": "pending", "write": "pending", "review": "pending" },
    "seo": { "onpage": "pending", "technical": "pending", "geo": "pending", "schema": "pending" },
    "ads": { "platform_audit": "pending", "competitor_ads": "pending", "budget_plan": "pending", "strategy_report": "pending" },
    "publish": { "obsidian": "pending", "blog": "pending", "social_media": "pending" }
  },
  "history": []
}
EOF

    log "INIT project=$project_name"
    echo ""
    echo -e "${GREEN}✅ Project initialized!${NC}"
    echo "   📄 $PROJECT_FILE"
    echo "   📊 $STATE_FILE"
    echo ""
    echo "   Next: /freelance init runs discovery, then drafts the 10-document bundle"
    echo ""
}

cmd_status() {
    banner
    resolve_state_files
    check_project
    check_state

    echo -e "${BOLD}📊 Pipeline Status${NC}"
    echo ""

    python3 "$(dirname "$0")/status.py" "$STATE_FILE"

    echo ""
}

cmd_next() {
    banner
    resolve_state_files
    check_project
    check_state

    echo -e "${BOLD}🔍 Finding next step...${NC}"
    echo ""

    NEXT=$(python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
for phase, steps in data['steps'].items():
    for step, status in steps.items():
        if status == 'pending':
            print(f'{phase}.{step}')
            exit()
print('all_done')
")

    if [ "$NEXT" = "all_done" ]; then
        echo -e "${GREEN}🎉 All steps completed!${NC}"
        echo ""
        return
    fi

    PHASE=$(echo "$NEXT" | cut -d'.' -f1)
    STEP=$(echo "$NEXT" | cut -d'.' -f2)

    echo -e "  Next: ${CYAN}$PHASE → $STEP${NC}"
    echo ""

    case "$PHASE" in
        discovery)
            echo "  🔎 Discovery phase commands:"
            echo "     /freelance init <name-or-url>"
            echo "     defuddle parse <competitor-url> --md -o research/kompetitor.md"
            echo "     /blog discourse <topic>"
            ;;
        bundle)
            echo "  📦 Bundle phase — the 10 client handoff documents:"
            echo "     00-handoff.md        01-brief.md"
            echo "     02-brand.md          03-design-tokens.md"
            echo "     04-sitemap.md        05-layout.md"
            echo "     06-content/*.md      07-tech-spec.md"
            echo "     08-seo-foundation.md 09-build-prompt.md"
            ;;
        research)
            echo "  📋 Research phase commands:"
            echo "     defuddle parse <competitor-url> --md -o research/kompetitor.md"
            echo "     /blog discourse <topic>"
            echo "     /blog strategy <niche>"
            ;;
        content)
            echo "  📝 Content phase commands:"
            echo "     /blog brief <topic>"
            echo "     /blog outline <topic>"
            echo "     /blog write <topic>"
            ;;
        seo)
            echo "  🔍 SEO phase commands:"
            echo "     /blog seo-check <file>"
            echo "     /blog geo <file>"
            echo "     /blog schema <file>"
            ;;
        ads)
            echo "  📢 Ads phase commands:"
            echo "     /freelance ads <url>"
            ;;
        publish)
            echo "  📤 Publish phase commands:"
            echo "     cp blog/<file>.md obsidian-vault/"
            echo "     /freelance diagram"
            ;;
    esac

    echo ""
    echo -e "  Run: ${YELLOW}/freelance run $PHASE $STEP${NC}"
    echo ""
}

cmd_run() {
    banner
    resolve_state_files
    check_project
    check_state

    PHASE="${1:-}"
    STEP="${2:-}"

    if [ -z "$PHASE" ] || [ -z "$STEP" ]; then
        echo -e "${RED}Usage: /freelance run <phase> <step>${NC}"
        echo "   Example: /freelance run research competitor"
        echo ""
        cmd_next
        return
    fi

    # Validate phase.step exists
    VALID=$(python3 -c "
import json
with open('$STATE_FILE') as f:
    data = json.load(f)
if '$PHASE' in data['steps'] and '$STEP' in data['steps']['$PHASE']:
    print('valid')
else:
    print('invalid')
")

    if [ "$VALID" = "invalid" ]; then
        echo -e "${RED}❌ Invalid phase.step: $PHASE.$STEP${NC}"
        return
    fi

    echo -e "  🔄 Running: ${CYAN}$PHASE → $STEP${NC}"
    echo ""
    set_step "$PHASE" "$STEP" "running"
    log "RUN $PHASE.$STEP"

    echo -e "${GREEN}✅ Step marked as running.${NC}"
    echo "   Complete the work, then mark as done:"
    echo -e "   ${YELLOW}/freelance done $PHASE $STEP${NC}"
    echo ""
}

cmd_done() {
    banner
    resolve_state_files
    check_project
    check_state

    PHASE="${1:-}"
    STEP="${2:-}"

    if [ -z "$PHASE" ] || [ -z "$STEP" ]; then
        echo -e "${RED}Usage: /freelance done <phase> <step>${NC}"
        return
    fi

    set_step "$PHASE" "$STEP" "done"
    log "DONE $PHASE.$STEP"

    echo -e "${GREEN}✅ $PHASE.$STEP marked as done!${NC}"
    echo ""
    cmd_next
}

cmd_list() {
    banner
    echo -e "${BOLD}📋 Available Commands${NC}"
    echo ""
    echo "  /freelance init              Initialize project"
    echo "  /freelance status            Show pipeline progress"
    echo "  /freelance next              Show next pending step"
    echo "  /freelance run <phase> <step> Mark step as running"
    echo "  /freelance done <phase> <step> Mark step as done"
    echo "  /freelance list              Show this help"
    echo ""
    echo "  Phases: discovery, bundle, research, content, seo, ads, publish"
    echo ""
}

# ─── Router ────────────────────────────────────────────

COMMAND="${1:-help}"
shift 2>/dev/null || true

case "$COMMAND" in
    init)       cmd_init ;;
    status)     cmd_status ;;
    next)       cmd_next ;;
    run)        cmd_run "$@" ;;
    done)       cmd_done "$@" ;;
    list|help)  cmd_list ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        cmd_list
        ;;
esac
