---
name: seo-marketing
description: Complete SEO marketing workflow combining web research, content creation, SEO optimization, and visual documentation. Uses defuddle for research, blog skills for content, SEO skills for optimization, obsidian for knowledge management, and diagram-design for visual strategy maps.
---

# SEO Marketing Skill

Gabungan lengkap untuk riset → konten → optimasi → dokumentasi.

## First-Time Setup

### 1. Init Project Context

Create `.seo-project.md` in your project root:

```bash
# Copy template
cp ~/.claude/skills/seo-marketing/templates/.seo-project.template.md .seo-project.md

# Edit with your business info
```

### 2. Init Pipeline State

```bash
cp ~/.claude/skills/seo-marketing/templates/.seo-state.template.json .seo-state.json
```

### 3. Verify Setup

```bash
ls -la .seo-project.md .seo-state.json
```

## Commands

| Command | Description |
|---------|-------------|
| `/seo-marketing init` | Initialize project (create .seo-project.md) |
| `/seo-marketing status` | Show pipeline progress |
| `/seo-marketing next` | Run next pending step |
| `/seo-marketing run-all` | Run full pipeline |
| `/seo-marketing research` | Run research phase |
| `/seo-marketing content` | Run content phase |
| `/seo-marketing optimize` | Run SEO optimization phase |

## Pipeline Phases

### Phase 1: Research
```bash
# Web scraping
defuddle parse <url> --md -o research/topic.md

# SERP & keyword research (Serper API)
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"q": "your keyword", "gl": "id", "hl": "id"}'

# People Also Ask
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -d '{"q": "your keyword", "type": "search"}' | jq '.peopleAlsoAsk'

# Competitor pricing (Google Shopping)
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -d '{"q": "your keyword", "type": "shopping", "gl": "id"}'

/blog discourse <topic>
/blog strategy <niche>
```

### Phase 2: Content Creation
```bash
/blog brief <topic>
/blog outline <topic>
/blog write <topic>
```

### Phase 3: SEO Optimization
```bash
/blog seo-check <file>
/blog geo <file>
/blog schema <file>
/seo-audit <url>
```

### Phase 4: Knowledge Management
```bash
# Save to obsidian vault
cp blog/<file>.md obsidian-vault/research/
```

### Phase 5: Visual Strategy
```bash
# Architecture diagram
# Customer journey map
# Competitor analysis
```

## Project Context File

Skill ini expects `.seo-project.md` di root project:

```yaml
---
project_name: my-business
website: https://mywebsite.com
business_type: umkm-kuliner
products:
  - name: Product A
    price: 10000
primary_keywords:
  - keyword 1
competitors:
  - url: kompetitor.com
---
```

## Pipeline State

Progress disimpan di `.seo-state.json`:

```json
{
  "steps": {
    "research": { "competitor": "done", "keywords": "pending" },
    "content": { "brief": "pending", "write": "pending" }
  }
}
```

## Integration Map

```
┌─────────────────────────────────────────────────┐
│                SEO MARKETING                    │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    │
│  │RESEARCH │ →  │ CONTENT │ →  │   SEO   │    │
│  └─────────┘    └─────────┘    └─────────┘    │
│       ↓              ↓              ↓          │
│  ┌─────────────────────────────────────────┐  │
│  │         KNOWLEDGE BASE (Obsidian)        │  │
│  └─────────────────────────────────────────┘  │
│       ↓              ↓              ↓          │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    │
│  │DIAGRAMS │    │ EXPORT  │    │ TRACK   │    │
│  └─────────┘    └─────────┘    └─────────┘    │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Tools Used

| Tool | Purpose | Skill |
|------|---------|-------|
| defuddle | Web scraping | obsidian-skills |
| blog-write | Content creation | blog |
| blog-seo | SEO validation | blog |
| blog-geo | AI citation | blog |
| seo-audit | Full audit | seo |
| diagram-design | Visual maps | diagram-design |
| obsidian-vault | Knowledge base | obsidian-skills |

## Vault Structure

```
obsidian-vault/
├── research/           # Research results
│   ├── competitor/
│   ├── keywords/
│   └── serp/
├── content/            # Content drafts
│   ├── blog/
│   ├── social/
│   └── email/
├── strategy/           # Strategies
│   ├── seo/
│   ├── marketing/
│   └── product/
├── docs/               # Documentation
│   ├── architecture/
│   └── flow/
└── archive/            # Old archives
```
