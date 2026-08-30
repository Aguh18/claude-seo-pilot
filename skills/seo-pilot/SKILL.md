---
name: seo-pilot
description: Complete SEO workflow orchestrator. 4 commands that each run a full multi-skill workflow. Init project, create content, audit SEO, check status. Use when user says "seo", "seo-pilot", "init project", "blog-write", "seo audit", "site audit".
---

# SEO Pilot

4 commands. Each one does a complete job. All heavy-lifting delegated to subagents in parallel.

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Research project → create brand docs, voice, config |
| `/seo-pilot blog-write <topic>` | Full pipeline → research → write → optimize → publish |
| `/seo-pilot audit <url>` | Full SEO audit → technical + content + GEO + report |
| `/seo-pilot status` | Show what's done and what's next |

---

## Execution Model

**All commands use parallel subagents.** Never run steps sequentially when they're independent.

### How to spawn

Use the `Agent` tool. Each subagent gets a focused prompt with the data it needs. Spawn independent agents in the **same message** (parallel tool calls). Only block when the next step genuinely depends on a previous result.

### Agent mapping

| Task | Agent Type | Notes |
|------|-----------|-------|
| Website scraping | `general-purpose` | Read site, extract products/pricing/structure |
| Competitor analysis | `general-purpose` | Scrape and analyze each competitor |
| Keyword research | `seo-dataforseo` | SERP data, volume, difficulty |
| Discourse research | `general-purpose` | Reddit, X, YouTube, HN via WebSearch |
| Brand docs (BRAND.md, VOICE.md) | `blog-brand` | After research completes |
| Content writing | `blog-writer` | Consumes brief + brand docs |
| SEO check | `blog-seo` | Post-write validation |
| Schema markup | `seo-schema` | JSON-LD generation |
| Technical audit | `seo-technical` | Crawlability, speed, mobile |
| On-page audit | `seo-content` | Content quality, E-E-A-T |
| GEO audit | `seo-geo` | AI citation readiness |
| Diagrams | `diagram-design` | HTML/SVG architecture diagrams |
| Obsidian vault | `general-purpose` | File organization |

---

## `/seo-pilot init`

One command to set up everything. Scrapes your site, researches the market, creates all docs.

**Execution — spawn these in parallel (Wave 1):**

```
Agent 1: Scrape target website
  - URL provided by user
  - Extract: products, pricing, structure, content, positioning
  - Save to research/market/site-analysis.md

Agent 2: Competitor analysis
  - Identify top 3-5 competitors from market context
  - Scrape each competitor site
  - Save per-competitor to research/competitors/*.md

Agent 3: Keyword research
  - Primary + secondary keywords from site context
  - SERP analysis, volume, difficulty, intent
  - Save to research/keywords/primary-keywords.md

Agent 4: Discourse research
  - Reddit, X, YouTube, HN for topic space
  - What people ask, complain, praise
  - Save to research/discourse/topic-discourse.md
```

**Wave 2 (after Wave 1 completes) — spawn these in parallel:**

```
Agent 5: Generate brand docs
  - Input: site analysis + competitor data + discourse
  - Output: BRAND.md + VOICE.md

Agent 6: Create diagrams
  - Input: site analysis
  - Output: diagrams/architecture.html, customer-journey.html, erd.html

Agent 7: Setup Obsidian vault
  - Input: all research from Wave 1
  - Output: obsidian-vault/ structure with notes
```

**Wave 3 (after Wave 2):**

```
Agent 8: Create config files
  - .seo-project.md (products, keywords, competitors)
  - .seo-state.json (pipeline tracker)
```

**Files created:**

```
.seo-project.md              # Products, keywords, competitors config
.seo-state.json              # Pipeline tracker
BRAND.md                     # Brand identity & positioning
VOICE.md                     # Writing tone & style guide

research/
├── competitors/             # Competitor analysis (per site)
│   ├── kompetitor1.md
│   └── kompetitor2.md
├── keywords/                # Keyword research
│   └── primary-keywords.md
├── discourse/               # Social listening
│   └── topic-discourse.md
└── market/                  # Market landscape
    └── market-overview.md

diagrams/
├── architecture.html        # Backend architecture
├── customer-journey.html    # Customer journey map
└── erd.html                 # Database diagram

obsidian-vault/
├── 00-index.md              # Hub
├── notes/                   # All research notes
├── products/                # Product docs
└── strategy/                # Strategy docs
```

**Usage:**
```bash
/seo-pilot init
# → "Enter your website URL: https://keripikmangdedi.id"
# → (4 agents scrape + research in parallel, then 3 agents create docs in parallel)
# → "Done! 15 files created. Next: /seo-pilot blog-write <topic>"
```

---

## `/seo-pilot blog-write <topic>`

Full content pipeline for a topic. From research to published post.

**Execution — Wave 1: Research (parallel)**

```
Agent 1: Discourse research for this specific topic
  - What people say about <topic> on Reddit, X, YouTube
  - Save to research/discourse/<topic-slug>-discourse.md

Agent 2: SERP + keyword analysis for this topic
  - Competitor content ranking for this topic
  - Keyword gaps, search volume, intent
  - Save to research/keywords/<topic-slug>-keywords.md
```

**Wave 2: Brief + Outline (sequential — brief needs research)**

```
Agent 3: Create content brief
  - Input: discourse + keyword research from Wave 1
  - Output: content brief with target keywords, sections, word count
  - Use blog-brief skill

Agent 4: Create outline
  - Input: same research + brief
  - Output: SERP-informed H2/H3 structure
  - Use blog-outline skill
```

**Wave 3: Write (single agent — needs brief + outline)**

```
Agent 5: Write full article
  - Input: brief + outline + BRAND.md + VOICE.md
  - Output: complete article in content/<topic-slug>.md
  - Use blog-writer skill
```

**Wave 4: Optimize + Enhance (parallel — all independent on written article)**

```
Agent 6: SEO check
  - Input: written article
  - Output: SEO validation + fixes applied
  - Use blog-seo skill

Agent 7: Schema markup
  - Input: article metadata
  - Output: JSON-LD schema
  - Use seo-schema skill

Agent 8: Diagram/chart (if data-heavy topic)
  - Input: article data points
  - Output: SVG chart embedded in article
  - Use blog-chart or diagram-design skill
```

**Wave 5: Publish**

```
Agent 9: Final assembly + save
  - Merge article + schema + chart
  - Save to content/<topic-slug>.md
  - Copy to obsidian-vault/notes/
  - Update .seo-state.json
```

**Usage:**
```bash
/seo-pilot blog-write "Resep Keripik Singkong Original"
# → Wave 1: 2 agents (discourse + keywords) in parallel
# → Wave 2: 2 agents (brief + outline) in parallel
# → Wave 3: 1 agent (write)
# → Wave 4: 3 agents (SEO + schema + chart) in parallel
# → Wave 5: publish
# → Saved to content/resep-keripik-singkong-original.md
```

**Also works for:**
```bash
/seo-pilot blog-write "Why Our Chips Are Better"       # Blog post
/seo-pilot blog-write "Kripset Jadul"                   # Product page
/seo-pilot blog-write "Complete Guide to Cassava Chips" # Pillar page
```

---

## `/seo-pilot audit <url>`

Full SEO audit with actionable report. All audit types run in parallel.

**Execution — spawn ALL 5 in parallel (single wave):**

```
Agent 1: Technical SEO audit
  - Crawlability, indexability, robots.txt, sitemap
  - Core Web Vitals, page speed, mobile
  - Security headers, HTTPS
  - Use seo-technical skill

Agent 2: On-page SEO audit
  - Title tags, meta descriptions, headings
  - Internal/external links, anchor text
  - Image optimization, alt text
  - URL structure
  - Use seo-content skill

Agent 3: Schema markup validation
  - Detect existing schema
  - Validate against Google requirements
  - Recommend missing schema
  - Use seo-schema skill

Agent 4: GEO / AI citation audit
  - AI crawler accessibility
  - Passage-level citability
  - ChatGPT, Perplexity, Gemini readiness
  - llms.txt compliance
  - Use seo-geo skill

Agent 5: Content quality analysis
  - E-E-A-T signals
  - Readability, depth, freshness
  - Thin content detection
  - Use seo-content skill
```

**After all 5 complete:**

```
Agent 6: Generate combined report
  - Input: all 5 audit results
  - Output: prioritized report (Critical → High → Medium → Low)
  - Save to reports/audit-<domain>-<date>.md
```

**Usage:**
```bash
/seo-pilot audit https://keripikmangdedi.id
# → 5 audit agents run in parallel
# → 1 agent merges into final report
# → "Report saved to reports/audit-keripikmangdedi.id-2026-08-30.md"
```

---

## `/seo-pilot status`

Check pipeline progress.

**Execution: single agent, reads .seo-state.json**

```
Agent 1: Read .seo-state.json + scan content/ and research/ dirs
  - Report: what's done, what's in progress, what's next
```

**Shows:**
- Which research is done
- Which content is created
- Which SEO checks passed
- What's pending next

---

## Project Files

After init, these files exist in your project:

| File | Purpose |
|------|---------|
| `.seo-project.md` | Products, keywords, competitors, config |
| `.seo-state.json` | Pipeline progress tracker |
| `BRAND.md` | Brand identity, positioning, audience |
| `VOICE.md` | Writing tone, style, do's and don'ts |
| `research/` | Research results |
| `content/` | Created content |
| `reports/` | Audit reports |
| `obsidian-vault/` | Knowledge base |

## Example: First Time Setup

```bash
# 1. Initialize — research everything about your project
/seo-pilot init
# Enter URL: https://mysite.com
# → 4 agents parallel (scrape + competitors + keywords + discourse)
# → 3 agents parallel (brand docs + diagrams + vault)
# → Config created

# 2. Create your first blog post
/seo-pilot blog-write "How to Choose the Best [Your Product]"
# → Full pipeline: research → write → optimize

# 3. Audit your site
/seo-pilot audit https://mysite.com
# → 5 audit agents parallel → combined report

# 4. Check progress
/seo-pilot status
```
