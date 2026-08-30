---
name: seo-pilot
description: Complete SEO marketing workflow combining web research, content creation, SEO optimization, and visual documentation. Uses defuddle for research, blog skills for content, SEO skills for optimization, obsidian for knowledge management, and diagram-design for visual strategy maps.
---

# SEO Pilot

Complete SEO workflow — research → content → optimize → publish.

## First-Time Setup

### 1. Init Project Context

Create `.seo-project.md` in your project root:

```bash
cp ~/.claude/skills/seo-pilot/templates/.seo-project.template.md .seo-project.md
```

### 2. Init Pipeline State

```bash
cp ~/.claude/skills/seo-pilot/templates/.seo-state.template.json .seo-state.json
```

### 3. Verify Setup

```bash
ls -la .seo-project.md .seo-state.json
```

## Commands

| Command | Description |
|---------|-------------|
| `/seo-pilot init` | Initialize project (create .seo-project.md) |
| `/seo-pilot status` | Show pipeline progress |
| `/seo-pilot next` | Run next pending step |
| `/seo-pilot run-all` | Run full pipeline |
| `/seo-pilot research` | Run research phase |
| `/seo-pilot content` | Run content phase |
| `/seo-pilot optimize` | Run SEO optimization phase |
| `/seo-pilot diagram` | Create visual diagrams |

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
# Architecture diagram, customer journey, competitor analysis
# use diagram-design skill
```

## Project Context File

Expects `.seo-project.md` di root project:

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
│                   SEO PILOT                     │
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

| Tool | Purpose | Credit |
|------|---------|--------|
| defuddle | Web scraping | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) |
| blog-* | Content creation & SEO | [claude-blog](https://github.com/anthropics/claude-code) |
| seo-* | Full SEO audit | [claude-seo](https://github.com/anthropics/claude-code) |
| diagram-design | Visual diagrams | [cathrynlavery/diagram-design](https://github.com/cathrynlavery/diagram-design) |
| obsidian-markdown | Knowledge notes | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) |
| Serper API | SERP & keyword data | [serper.dev](https://serper.dev) |

## Vault Structure

```
obsidian-vault/
├── research/
│   ├── competitor/
│   ├── keywords/
│   └── serp/
├── content/
│   ├── blog/
│   ├── social/
│   └── email/
├── strategy/
│   ├── seo/
│   ├── marketing/
│   └── product/
├── docs/
│   ├── architecture/
│   └── flow/
└── archive/
```
