---
name: seo-pilot
description: Complete SEO workflow orchestrator. Single entry point for research, content creation, SEO optimization, and publishing. Routes internally to blog, seo, defuddle, diagram-design, and obsidian skills. Use when user says "seo", "seo-pilot", "research competitor", "write blog", "optimize seo", "seo audit".
---

# SEO Pilot

Single command for everything. No need to remember individual skill commands.

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Initialize project — create .seo-project.md |
| `/seo-pilot status` | Show pipeline progress |
| `/seo-pilot next` | Show next pending step |
| `/seo-pilot research` | Run full research phase |
| `/seo-pilot content` | Run full content creation phase |
| `/seo-pilot optimize` | Run full SEO optimization phase |
| `/seo-pilot publish` | Run full publish phase |
| `/seo-pilot run-all` | Run entire pipeline |
| `/seo-pilot update` | Check & update upstream skills |

## How It Works

User says: `/seo-pilot research competitor https://kompetitor.com`

Orchestrator does internally:
1. Reads `.seo-project.md` for context
2. Runs `defuddle parse https://kompetitor.com --md -o research/kompetitor.md`
3. Runs keyword research via Serper API
4. Updates `.seo-state.json` progress
5. Saves results to `research/` folder

User says: `/seo-pilot content write "Resep Keripik Singkong"`

Orchestrator does internally:
1. Reads `.seo-project.md` for brand voice & keywords
2. Generates brief internally
3. Generates outline internally
4. Writes optimized blog post
5. Runs SEO check internally
6. Saves to `content/` folder
7. Updates `.seo-state.json`

User says: `/seo-pilot optimize blog/content/resep-keripik.md`

Orchestrator does internally:
1. Runs on-page SEO check
2. Runs GEO (AI citation) optimization
3. Generates schema markup
4. Saves optimized version
5. Updates `.seo-state.json`

## Phase Details

### Phase 1: Research

| Sub-command | Action |
|-------------|--------|
| `/seo-pilot research competitor <url>` | Scrape competitor website |
| `/seo-pilot research keywords <topic>` | Keyword research via Serper API |
| `/seo-pilot research serp <keyword>` | SERP analysis |
| `/seo-pilot research discourse <topic>` | What people are saying (last 30 days) |
| `/seo-pilot research all <topic>` | Run all research for topic |

### Phase 2: Content

| Sub-command | Action |
|-------------|--------|
| `/seo-pilot content brief <topic>` | Generate content brief |
| `/seo-pilot content outline <topic>` | Generate outline |
| `/seo-pilot content write <topic>` | Write full blog post |
| `/seo-pilot content rewrite <file>` | Rewrite existing post |
| `/seo-pilot content discourse <topic>` | Research discourse first |
| `/seo-pilot content all <topic>` | Brief → outline → write → check |

### Phase 3: Optimize

| Sub-command | Action |
|-------------|--------|
| `/seo-pilot optimize onpage <file>` | On-page SEO check |
| `/seo-pilot optimize geo <file>` | AI citation optimization |
| `/seo-pilot optimize schema <file>` | Generate JSON-LD schema |
| `/seo-pilot optimize audit <url>` | Full SEO audit |
| `/seo-pilot optimize all <file>` | Onpage + geo + schema |

### Phase 4: Publish

| Sub-command | Action |
|-------------|--------|
| `/seo-pilot publish obsidian <file>` | Save to Obsidian vault |
| `/seo-pilot publish diagram <topic>` | Create visual diagram |
| `/seo-pilot publish all <file>` | Obsidian + diagram |

## Project Context

Reads `.seo-project.md` automatically for:
- Business info (name, website, type)
- Products & pricing
- Target keywords
- Competitors
- Brand voice

## Pipeline State

Tracks progress in `.seo-state.json`:
- Which steps are done/pending/running
- History of completed actions
- Last updated timestamp

## Tools Used (Internal)

| Tool | When |
|------|------|
| defuddle | Web scraping, competitor research |
| Serper API | Keyword research, SERP analysis |
| blog-write | Content creation |
| blog-seo | SEO validation |
| blog-geo | AI citation optimization |
| blog-schema | Schema markup generation |
| blog-discourse | Social listening |
| diagram-design | Visual diagrams |
| obsidian-markdown | Knowledge management |

## Update Skills

```bash
/seo-pilot update
```

Checks upstream repos for new versions and syncs automatically.

## Example: Full Pipeline

```bash
# 1. Setup
/seo-pilot init

# 2. Research
/seo-pilot research all "keripik singkong"

# 3. Content
/seo-pilot content all "Resep Keripik Singkong Original"

# 4. Optimize
/seo-pilot optimize all content/resep-keripik.md

# 5. Publish
/seo-pilot publish all content/resep-keripik.md

# 6. Check progress
/seo-pilot status
```
