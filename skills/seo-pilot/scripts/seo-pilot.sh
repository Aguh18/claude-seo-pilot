#!/bin/bash

# ✈️ SEO Pilot - Main Orchestrator
# The brain that coordinates all SEO workflow phases

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
PROJECT_FILE=".seo-project.md"
STATE_FILE=".seo-state.json"
LOG_FILE=".seo-pilot.log"

# ─── Helpers ───────────────────────────────────────────

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

banner() {
    echo ""
    echo -e "${CYAN}✈️  SEO Pilot v${VERSION}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

check_project() {
    if [ ! -f "$PROJECT_FILE" ]; then
        echo -e "${RED}❌ Project not initialized.${NC}"
        echo "   Run: /seo-pilot init"
        exit 1
    fi
}

check_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"project":"","last_updated":"","steps":{"research":{"competitor":"pending","keywords":"pending","serp":"pending","market_analysis":"pending"},"content":{"brief":"pending","outline":"pending","write":"pending","review":"pending"},"seo":{"onpage":"pending","technical":"pending","geo":"pending","schema":"pending"},"publish":{"obsidian":"pending","blog":"pending","social_media":"pending"}},"history":[]}' > "$STATE_FILE"
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
    echo -e "${BOLD}🚀 Initializing SEO Pilot project...${NC}"
    echo ""

    if [ -f "$PROJECT_FILE" ]; then
        echo -e "${YELLOW}⚠️  $PROJECT_FILE already exists.${NC}"
        read -p "   Overwrite? (y/N): " confirm
        if [ "$confirm" != "y" ]; then
            echo "   Cancelled."
            return
        fi
    fi

    # Get project name
    read -p "   Project name: " project_name
    read -p "   Website URL: " website_url
    read -p "   Business type (umkm-kuliner/umkm-fashion/ecommerce/blog/other): " biz_type

    # Generate .seo-project.md
    cat > "$PROJECT_FILE" << EOF
---
project_name: "$project_name"
website: "$website_url"
business_type: "$biz_type"

brand_voice:
  tone: "casual"
  style: "indonesian"
  personality: ""

target_audience:
  age_range: "25-45"
  location: "Indonesia"

products: []

primary_keywords:
  - "keyword 1"
  - "keyword 2"

competitors: []
---

# $project_name

SEO project for $website_url

## Setup Checklist

- [ ] Fill in products
- [ ] Add primary keywords
- [ ] Add competitors
- [ ] Configure brand voice
- [ ] Set target audience
EOF

    # Generate .seo-state.json
    cat > "$STATE_FILE" << EOF
{
  "project": "$project_name",
  "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "steps": {
    "research": { "competitor": "pending", "keywords": "pending", "serp": "pending", "market_analysis": "pending" },
    "content": { "brief": "pending", "outline": "pending", "write": "pending", "review": "pending" },
    "seo": { "onpage": "pending", "technical": "pending", "geo": "pending", "schema": "pending" },
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
    echo "   Next: Edit $PROJECT_FILE with your business details"
    echo "   Then: /seo-pilot research"
    echo ""
}

cmd_status() {
    banner
    check_project
    check_state

    echo -e "${BOLD}📊 Pipeline Status${NC}"
    echo ""

    python3 -c "
import json

with open('$STATE_FILE') as f:
    data = json.load(f)

icons = {'done': '✅', 'running': '🔄', 'pending': '⬜', 'failed': '❌'}
total = 0
completed = 0

for phase, steps in data['steps'].items():
    phase_done = sum(1 for s in steps.values() if s == 'done')
    phase_total = len(steps)
    total += phase_total
    completed += phase_done

    pct = int((phase_done / phase_total) * 100) if phase_total > 0 else 0
    bar = '█' * (pct // 10) + '░' * (10 - pct // 10)

    print(f'  {phase.upper()}')
    print(f'    [{bar}] {pct}% ({phase_done}/{phase_total})')
    for step, status in steps.items():
        icon = icons.get(status, '?')
        print(f'    {icon} {step}')
    print()

overall = int((completed / total) * 100) if total > 0 else 0
print(f'  Overall: {completed}/{total} steps ({overall}%)')
print(f'  Last updated: {data.get(\"last_updated\", \"never\")}')
"

    echo ""
}

cmd_next() {
    banner
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
        publish)
            echo "  📤 Publish phase commands:"
            echo "     cp blog/<file>.md obsidian-vault/"
            echo "     /seo-pilot diagram"
            ;;
    esac

    echo ""
    echo -e "  Run: ${YELLOW}/seo-pilot run $PHASE $STEP${NC}"
    echo ""
}

cmd_run() {
    banner
    check_project
    check_state

    PHASE="${1:-}"
    STEP="${2:-}"

    if [ -z "$PHASE" ] || [ -z "$STEP" ]; then
        echo -e "${RED}Usage: /seo-pilot run <phase> <step>${NC}"
        echo "   Example: /seo-pilot run research competitor"
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
    echo -e "   ${YELLOW}/seo-pilot done $PHASE $STEP${NC}"
    echo ""
}

cmd_done() {
    banner
    check_project
    check_state

    PHASE="${1:-}"
    STEP="${2:-}"

    if [ -z "$PHASE" ] || [ -z "$STEP" ]; then
        echo -e "${RED}Usage: /seo-pilot done <phase> <step>${NC}"
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
    echo "  /seo-pilot init              Initialize project"
    echo "  /seo-pilot status            Show pipeline progress"
    echo "  /seo-pilot next              Show next pending step"
    echo "  /seo-pilot run <phase> <step> Mark step as running"
    echo "  /seo-pilot done <phase> <step> Mark step as done"
    echo "  /seo-pilot list              Show this help"
    echo ""
    echo "  Phases: research, content, seo, publish"
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
