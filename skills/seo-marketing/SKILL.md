---
name: seo-marketing
description: Complete SEO marketing workflow combining web research, content creation, SEO optimization, and visual documentation. Uses defuddle for research, blog skills for content, SEO skills for optimization, obsidian for knowledge management, and diagram-design for visual strategy maps.
---

# SEO Marketing Skill

Gabungan lengkap untuk riset → konten → optimasi → dokumentasi.

## Workflow

### Phase 1: Research
```
# Web scraping
defuddle parse <url> --md -o research/topic.md

# SERP & keyword research (Serper API)
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"q": "keripik singkong", "gl": "id", "hl": "id"}'

# People Also Ask
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -d '{"q": "keripik singkong", "type": "search"}' | jq '.peopleAlsoAsk'

# Competitor pricing (Google Shopping)
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -d '{"q": "keripik singkong", "type": "shopping", "gl": "id"}'

/blog discourse <topik>
/blog strategy <niche>
```

### Phase 2: Content Creation
```
/blog brief <topik>
/blog outline <topik>
/blog write <topik>
```

### Phase 3: SEO Optimization
```
/blog seo-check <file>
/blog geo <file>
/blog schema <file>
/seo-audit <url>
```

### Phase 4: Knowledge Management
```
Simpan hasil ke obsidian-vault/
Buat wikilinks antar note
Export ke blog jika perlu
```

### Phase 5: Visual Strategy
```
diagram-design untuk architecture maps
customer journey maps
competitor analysis visual
```

## Quick Commands

| Command | Action |
|---------|--------|
| `/seo-marketing research <url>` | Scrape + analyze website |
| `/seo-marketing content <topic>` | Full content pipeline |
| `/seo-marketing audit <url>` | Complete SEO audit |
| `/seo-marketing strategy <niche>` | Build marketing strategy |
| `/seo-marketing competitor <url>` | Analyze competitor |

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

## Example: Full Pipeline

### 1. Research Kompetitor
```bash
defuddle parse https://kompetitor.com --md -o research/kompetitor.md
```

### 2. Buat Konten
```bash
/blog brief "Resep Keripik Singkong Original"
/blog write "Resep Keripik Singkong Original"
```

### 3. Optimasi SEO
```bash
/blog seo-check blog/resep-keripik.md
/blog geo blog/resep-keripik.md
```

### 4. Simpan ke Vault
```bash
cp blog/resep-keripik.md obsidian-vault/research/
```

### 5. Buat Diagram
```bash
# Architecture diagram untuk teknikal docs
# Customer journey untuk marketing plan
```

## Vault Structure

```
obsidian-vault/
├── research/           # Hasil riset
│   ├── kompetitor/
│   ├── tren/
│   └── sumber/
├── content/            # Draft konten
│   ├── blog/
│   ├── social/
│   └── email/
├── strategy/           # Strategi
│   ├── seo/
│   ├── marketing/
│   └── product/
├── docs/               # Dokumentasi
│   ├── architecture/
│   └── flow/
└── archive/            # Arsip lama
```
