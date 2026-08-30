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

## Output Directory

**ALL generated files go to `seo-pilot/` folder in the project root.** Never scatter files across the project root.

On first run, create the directory:
```
mkdir -p seo-pilot/{research/{market,competitors,keywords,discourse},content,reports,diagrams}
```

All file paths in this skill are relative to `seo-pilot/`.

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
| Keyword research | `general-purpose` | Uses serper-api skill via WebSearch for SERP data |
| Discourse research | `general-purpose` | Reddit, X, YouTube, HN via WebSearch |
| Brand docs (BRAND.md, VOICE.md) | `general-purpose` | After research completes |
| Content writing | `blog-writer` | Consumes brief + brand docs |
| SEO check | `blog-seo` | Post-write validation |
| Schema markup | `seo-schema` | JSON-LD generation |
| Technical audit | `seo-technical` | Crawlability, speed, mobile |
| On-page audit | `seo-content` | Content quality, E-E-A-T |
| GEO audit | `seo-geo` | AI citation readiness |
| Diagrams | `diagram-design` | HTML/SVG architecture diagrams |

---

## `/seo-pilot init`

One command to set up everything. Scrapes your site, researches the market, creates all docs.

**First:** `mkdir -p seo-pilot/{research/{market,competitors,keywords,discourse},content,reports,diagrams}`

**Execution — spawn these in parallel (Wave 1):**

```
Agent 1: Scrape target website
  - URL provided by user
  - Extract: products, pricing, structure, content, positioning
  - Save to seo-pilot/research/market/site-analysis.md

Agent 2: Competitor analysis
  - Identify top 3-5 competitors from market context
  - Scrape each competitor site
  - Save per-competitor to seo-pilot/research/competitors/*.md

Agent 3: Keyword research
  - Primary + secondary keywords from site context
  - SERP analysis, volume, difficulty, intent
  - Save to seo-pilot/research/keywords/primary-keywords.md

Agent 4: Discourse research
  - Reddit, X, YouTube, HN for topic space
  - What people ask, complain, praise
  - Save to seo-pilot/research/discourse/topic-discourse.md
```

**Wave 2 (after Wave 1 completes) — spawn these in parallel:**

```
Agent 5: Generate brand docs
  - Input: site analysis + competitor data + discourse
  - Output: seo-pilot/BRAND.md + seo-pilot/VOICE.md

Agent 6: Generate full interactive HTML report
  - Input: all Wave 1 research data
  - Output: seo-pilot/report.html
  - MUST be completed before init is considered done
  - See "Report Requirements" below for details
```

**Wave 3 (after Wave 2 completes) — single agent:**

```
Agent 7: Create config files
  - seo-pilot/.seo-project.md (products, keywords, competitors)
  - seo-pilot/.seo-state.json (pipeline tracker)
```

**Init is NOT complete until Wave 3 finishes. All 3 waves must run to completion — no partial init.**

### Report Requirements

The `seo-pilot/report.html` is the **hero output** of init — a single, self-contained HTML file that opens in any browser. It serves as the complete project blueprint.

**Requirements:**
- Single HTML file, no external dependencies (all CSS/JS inline)
- Dark theme (#0f0f1a background, light text), responsive
- Charts and diagrams rendered as inline SVG or CSS (no chart libraries)
- Interactive: collapsible sections, hover tooltips on charts
- Professional, polished design — this is what gets shared with stakeholders

**Sections to include (minimum):**

1. **Hero Header** — Project name, URL, date, one-line positioning
2. **Website Overview** — Product table (all variants + pricing), site structure diagram
3. **Competitor Landscape** — Bar chart comparing price ranges, radar/spider chart for dimensions (brand recognition, social media, authenticity, DTC, product range), per-competitor cards
4. **Keyword Strategy** — Horizontal bar chart for search volume by keyword, color-coded by intent (transactional/informational/mixed), priority matrix table
5. **Voice of Customer** — Sentiment breakdown (positive/negative pie chart), top complaints bar chart, trending topics tags
6. **Customer Journey** — 3 persona flow diagrams (housephone snacker, oleh-oleh buyer, reseller)
7. **Content Architecture** — Site architecture tree, blog cluster map, internal linking zones
8. **Strategic Plan** — Prioritized action items (Critical/High/Medium/Low) with timeline, quick wins section
9. **Brand & Voice** — Tone dimension sliders, do's/don'ts cards

**Files created:**

```
seo-pilot/
├── report.html                   # Full interactive HTML report (HERO OUTPUT)
├── .seo-project.md               # Products, keywords, competitors config
├── .seo-state.json               # Pipeline tracker
├── BRAND.md                      # Brand identity & positioning
├── VOICE.md                      # Writing tone & style guide
├── research/
│   ├── market/
│   │   └── site-analysis.md      # Scraped site data
│   ├── competitors/
│   │   ├── maicih.md             # Per-competitor analysis
│   │   ├── qtela.md
│   │   ├── diplomat.md
│   │   ├── garudafood.md
│   │   └── artisanal.md
│   ├── keywords/
│   │   └── primary-keywords.md   # Keyword research
│   └── discourse/
│       └── topic-discourse.md    # Social listening
├── content/                      # Generated blog posts (empty until blog-write)
└── reports/                      # Audit reports (empty until audit)
```

**Usage:**
```bash
/seo-pilot init
# → "Enter your website URL: https://keripikmangdedi.id"
# → (4 agents scrape + research in parallel, then brand docs + HTML report in parallel)
# → "Done! Open seo-pilot/report.html in your browser. Next: /seo-pilot blog-write <topic>"
```

---

## `/seo-pilot blog-write <topic>`

Full content pipeline for a topic. From research to published post.

**Precondition:** Check that `seo-pilot/` folder exists and contains `BRAND.md`, `VOICE.md`, `.seo-project.md`. If missing, respond with:
> "Project belum di-init. Jalankan `/seo-pilot init` dulu untuk setup brand docs, voice, dan config."

**First:** `mkdir -p seo-pilot/content`

**Execution — Wave 1: Research (parallel)**

```
Agent 1: Discourse research for this specific topic
  - What people say about <topic> on Reddit, X, YouTube
  - Save to seo-pilot/research/discourse/<topic-slug>-discourse.md

Agent 2: SERP + keyword analysis for this topic
  - Competitor content ranking for this topic
  - Keyword gaps, search volume, intent
  - Save to seo-pilot/research/keywords/<topic-slug>-keywords.md
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
  - Input: brief + outline + seo-pilot/BRAND.md + seo-pilot/VOICE.md
  - Output: complete article in seo-pilot/content/<topic-slug>.md
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
  - Save to seo-pilot/content/<topic-slug>.md
  - Update seo-pilot/.seo-state.json
```

**Usage:**
```bash
/seo-pilot blog-write "Resep Keripik Singkong Original"
# → Saved to seo-pilot/content/resep-keripik-singkong-original.md
```

---

## `/seo-pilot audit <url>`

Full SEO audit with actionable report. All audit types run in parallel.

**Precondition:** Check that `seo-pilot/` folder exists. If missing, respond with:
> "Project belum di-init. Jalankan `/seo-pilot init` dulu untuk setup project."

**First:** `mkdir -p seo-pilot/reports`

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
  - Save to seo-pilot/reports/audit-<domain>-<date>.md
```

**Usage:**
```bash
/seo-pilot audit https://keripikmangdedi.id
# → Report saved to seo-pilot/reports/audit-keripikmangdedi.id-2026-08-30.md
```

---

## `/seo-pilot status`

Check pipeline progress.

**Precondition:** Check that `seo-pilot/` folder exists and contains `.seo-state.json`. If missing, respond with:
> "Project belum di-init. Jalankan `/seo-pilot init` dulu untuk setup project."

**Execution: single agent, reads seo-pilot/.seo-state.json**

```
Agent 1: Read seo-pilot/.seo-state.json + scan seo-pilot/content/ and seo-pilot/research/ dirs
  - Report: what's done, what's in progress, what's next
```

**Shows:**
- Which research is done
- Which content is created
- Which SEO checks passed
- What's pending next

---

## Project Files

After init, everything lives under `seo-pilot/`:

| File | Purpose |
|------|---------|
| `seo-pilot/.seo-project.md` | Products, keywords, competitors, config |
| `seo-pilot/.seo-state.json` | Pipeline progress tracker |
| `seo-pilot/BRAND.md` | Brand identity, positioning, audience |
| `seo-pilot/VOICE.md` | Writing tone, style, do's and don'ts |
| `seo-pilot/seo-pilot-init.md` | Compiled research summary |
| `seo-pilot/research/` | Research results |
| `seo-pilot/content/` | Created content |
| `seo-pilot/reports/` | Audit reports |
| `seo-pilot/diagrams/` | Visual diagrams |

## Example: First Time Setup

```bash
# 1. Initialize — research everything about your project
/seo-pilot init
# Enter URL: https://mysite.com
# → All output saved to seo-pilot/

# 2. Create your first blog post
/seo-pilot blog-write "How to Choose the Best [Your Product]"
# → Saved to seo-pilot/content/

# 3. Audit your site
/seo-pilot audit https://mysite.com
# → Report saved to seo-pilot/reports/

# 4. Check progress
/seo-pilot status
```
