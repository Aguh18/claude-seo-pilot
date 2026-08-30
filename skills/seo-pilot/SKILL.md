---
name: seo-pilot
description: Complete SEO workflow orchestrator. 4 commands that each run a full multi-skill workflow. Init project, create content, audit SEO, check status. Use when user says "seo", "seo-pilot", "init project", "blog-write", "seo audit", "site audit".
---

# SEO Pilot

SEO-focused skill. Maximize organic search visibility for your website. 4 commands, parallel subagents.

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Research project → keyword strategy, competitor SEO gaps, content plan, SEO report |
| `/seo-pilot blog-write <topic>` | Full pipeline → keyword research → brief → write → SEO optimize → publish |
| `/seo-pilot audit <url>` | Full SEO audit → technical + on-page + schema + GEO + report |
| `/seo-pilot status` | Show what's done and what's next |

---

## Output Directory

**ALL generated files go to `seo-pilot/` folder in the project root.** Never scatter files.

```
mkdir -p seo-pilot/{research/{competitors,keywords,discourse},content,reports,diagrams}
```

---

## Execution Model

**All commands use parallel subagents.** Spawn independent agents in the **same message**.

### Mandatory Skill Loading

**EVERY command, EVERY subagent MUST load ALL relevant skills before executing.** No exceptions. Skills define methodology, quality standards, and output format. More skills loaded = better output.

**Rule: When in doubt, load the skill. If a skill name contains a keyword related to your task, load it.**

| Domain | Skills to Always Consider |
|--------|--------------------------|
| SEO | `seo-technical`, `seo-content`, `seo-geo`, `seo-schema`, `seo-page`, `seo-performance`, `seo-cluster`, `seo-flow`, `seo-sxo` |
| Blog | `blog-write`, `blog-brief`, `blog-outline`, `blog-seo-check`, `blog-analyze`, `blog-schema`, `blog-strategy`, `blog-persona`, `blog-style`, `blog-discourse`, `blog-chart` |
| Content | `seo-content-brief`, `seo-content`, `blog-analyze`, `blog-reviewer` |
| Web | `defuddle`, `serper-api` |
| Visuals | `diagram-design`, `dataviz` |
| AI/GEO | `seo-geo`, `seo-flow`, `blog-geo` |

| Task | Agent Type | Skills to Load |
|------|-----------|---------------|
| Website scraping | `general-purpose` | `defuddle`, `seo-technical` |
| Competitor SEO analysis | `general-purpose` | `defuddle`, `seo-content`, `seo-technical` |
| Keyword research | `general-purpose` | `serper-api`, `seo-cluster`, `blog-brief` |
| Discourse research | `general-purpose` | `blog-discourse` |
| Content brief | `general-purpose` | `blog-brief`, `seo-content-brief`, `blog-strategy` |
| Content outline | `general-purpose` | `blog-outline`, `seo-content-brief` |
| Content writing | `blog-writer` | `blog-write`, `blog-style`, `blog-persona` |
| SEO check | `blog-seo` | `blog-seo-check`, `seo-page`, `seo-content` |
| Schema markup | `seo-schema` | `seo-schema`, `blog-schema` |
| Technical audit | `seo-technical` | `seo-technical`, `seo-performance` |
| On-page audit | `seo-content` | `seo-content`, `seo-page`, `blog-analyze` |
| GEO audit | `seo-geo` | `seo-geo`, `seo-geo` agent |
| SEO diagrams | `general-purpose` | `diagram-design`, `dataviz` |
| SEO report | `general-purpose` | `diagram-design`, `dataviz`, `blog-analyze` |
| Brand docs | `general-purpose` | `blog-brand`, `blog-persona`, `blog-style` |
| Full audit (all) | multiple agents | Each agent loads its own skills per row above |
| blog-write pipeline | multiple agents | Each wave loads its own skills per row above |

---

## `/seo-pilot init`

Set up SEO project. Scrapes site, researches keywords + competitors, creates SEO strategy.

**First:** `mkdir -p seo-pilot/{research/{competitors,keywords,discourse},content,reports,diagrams}`

**Wave 1 (parallel):**

```
Agent 1: Scrape target website
  - FIRST: Load skills: "defuddle", "seo-technical"
  - URL provided by user
  - Extract: products, pricing, site structure, existing SEO elements
    (title tags, meta descriptions, headings, schema, internal links)
  - Save to seo-pilot/research/website-analysis.md

Agent 2: Competitor SEO analysis
  - FIRST: Load skills: "defuddle", "seo-content", "seo-technical"
  - Identify top 3-5 competitors ranking for target keywords
  - Analyze their: title tags, content structure, keyword targeting,
    backlink signals, content gaps
  - Save per-competitor to seo-pilot/research/competitors/*.md

Agent 3: Keyword research
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary + secondary + long-tail keywords
  - SERP analysis, search volume estimates, difficulty, intent
  - Keyword gap analysis (what competitors rank for that we don't)
  - Save to seo-pilot/research/keywords/keyword-strategy.md

Agent 4: Discourse / question research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic (Reddit, Google, forums)
  - Question-based keywords for FAQ content
  - Save to seo-pilot/research/discourse/questions.md
```

**Wave 2 (parallel):**

```
Agent 5: Generate SEO strategy report
  - FIRST: Load skills: "diagram-design", "dataviz", "blog-analyze"
  - Input: all Wave 1 research
  - Output: seo-pilot/seo-strategy.html (interactive HTML report)
  - See "Report Requirements" below

Agent 6: Generate SEO planning diagrams
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: keyword + competitor data
  - Output:
    - seo-pilot/diagrams/keyword-gap.html (bar chart: our keywords vs competitors)
    - seo-pilot/diagrams/content-cluster.html (hub-and-spoke content map)
    - seo-pilot/diagrams/seo-priority.html (action items by impact/effort)
```

**Wave 3 (single agent):**

```
Agent 7: Create config files
  - seo-pilot/.seo-project.md (site info, target keywords, competitors)
  - seo-pilot/.seo-state.json (pipeline tracker)
```

**Init is NOT complete until Wave 3 finishes.**

### Report Requirements

`seo-pilot/seo-strategy.html` — single self-contained HTML, dark theme, charts as inline SVG/CSS.

**Sections:**

1. **Hero** — Site name, URL, date, one-line positioning
2. **Site SEO Overview** — Current SEO health snapshot: title tags, meta descriptions, schema status, content count, internal link depth
3. **Keyword Strategy** — Bar chart: search volume by keyword, color-coded by intent (transactional/informational/mixed). Priority table.
4. **Keyword Gap Analysis** — Side-by-side: keywords competitors rank for vs our gaps. Horizontal bar chart.
5. **Competitor SEO Breakdown** — Per-competitor cards: their top keywords, content structure, SEO strengths/weaknesses
6. **Content Plan** — Recommended blog topics mapped to keywords, funnel stage, and difficulty. Content cluster diagram.
7. **Technical SEO Checklist** — Crawlability, indexability, CWV, mobile, schema status. Pass/fail indicators.
8. **GEO / AI Readiness** — How ready is the site for AI citation (ChatGPT, Perplexity, AI Overviews)
9. **Prioritized Action Plan** — SEO actions by impact (Critical → High → Medium → Low) with estimated effort

**Files created:**

```
seo-pilot/
├── seo-strategy.html              # SEO strategy report (HERO OUTPUT)
├── .seo-project.md                # Site config, keywords, competitors
├── .seo-state.json                # Pipeline tracker
├── diagrams/
│   ├── keyword-gap.html           # Keyword gap vs competitors
│   ├── content-cluster.html       # Hub-and-spoke content map
│   └── seo-priority.html          # Action items by impact/effort
├── research/
│   ├── website-analysis.md        # Scraped site + SEO elements
│   ├── competitors/*.md           # Per-competitor SEO analysis
│   ├── keywords/keyword-strategy.md
│   └── discourse/questions.md     # Question-based content ideas
├── content/                       # Generated blog posts
└── reports/                       # Audit reports
```

---

## `/seo-pilot blog-write <topic>`

Full SEO content pipeline. From keyword research to published post.

**Precondition:** `seo-pilot/` must exist with `.seo-project.md`. If missing:
> "Jalankan `/seo-pilot init` dulu."

**First:** `mkdir -p seo-pilot/content`

**Wave 1 (parallel):**

```
Agent 1: Keyword research for this topic
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary keyword, secondary keywords, long-tail variations
  - SERP analysis: who ranks, what content type, gaps
  - Save to seo-pilot/research/keywords/<topic-slug>-keywords.md

Agent 2: Discourse research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic
  - Save to seo-pilot/research/discourse/<topic-slug>-questions.md
```

**Wave 2 (sequential):**

```
Agent 3: Content brief
  - FIRST: Load skills: "blog-brief", "seo-content-brief", "blog-strategy"
  - Input: keyword research + questions
  - Target keywords, sections, word count, internal linking zones

Agent 4: Outline
  - FIRST: Load skills: "blog-outline", "seo-content-brief"
  - Input: brief + SERP analysis
  - SERP-informed H2/H3 structure
```

**Wave 3 (single):**

```
Agent 5: Write article
  - FIRST: Load skills: "blog-write", "blog-style", "blog-persona"
  - (blog-writer agent self-loads blog-write)
  - Input: brief + outline + seo-pilot/BRAND.md + seo-pilot/VOICE.md
  - Output: seo-pilot/content/<topic-slug>.md
```

**Wave 4 (parallel):**

```
Agent 6: SEO check + fix
  - FIRST: Load skills: "blog-seo-check", "seo-page", "seo-content"
  - Title tag, meta description, headings, links, schema

Agent 7: Schema markup
  - FIRST: Load skills: "seo-schema", "blog-schema"
  - JSON-LD for Article/BlogPosting, FAQ, Breadcrumb
```

**Wave 5:**

```
Agent 8: Final assembly
  - Merge article + schema
  - Save to seo-pilot/content/<topic-slug>.md
  - Update seo-pilot/.seo-state.json
```

---

## `/seo-pilot audit <url>`

Full SEO audit. All 5 audits run in parallel.

**Precondition:** `seo-pilot/` must exist. If missing:
> "Jalankan `/seo-pilot init` dulu."

**First:** `mkdir -p seo-pilot/reports`

**Wave 1 (5 parallel):**

```
Agent 1: Technical SEO
  - FIRST: Load skills: "seo-technical", "seo-performance"
  - Crawlability, indexability, robots.txt, sitemap, CWV, page speed, mobile, security headers

Agent 2: On-page SEO
  - FIRST: Load skills: "seo-content", "seo-page", "blog-analyze"
  - Title tags, meta descriptions, headings, internal/external links, images, URL structure

Agent 3: Schema validation
  - FIRST: Load skills: "seo-schema", "blog-schema"
  - Detect existing, validate against Google requirements, recommend missing

Agent 4: GEO / AI citation
  - FIRST: Load skills: "seo-geo", "seo-flow"
  - AI crawlers, llms.txt, passage citability, ChatGPT/Perplexity/Gemini readiness

Agent 5: Content quality
  - FIRST: Load skills: "seo-content", "blog-analyze", "seo-content-brief"
  - E-E-A-T, readability, depth, freshness, thin content detection
```

**Wave 2:**

```
Agent 6: Combined audit report
  - Input: all 5 results
  - Output: seo-pilot/reports/audit-<domain>-<date>.md
  - Prioritized: Critical → High → Medium → Low
```

---

## `/seo-pilot status`

**Precondition:** `seo-pilot/.seo-state.json` must exist. If missing:
> "Jalankan `/seo-pilot init` dulu."

**Load skills:** `blog-analyze` (for content scoring if content exists)

Read `.seo-state.json` + scan `content/` and `research/` dirs. Report: done, in progress, pending.

---

## Example

```bash
/seo-pilot init
# → Enter URL: https://mysite.com
# → Wave 1: 4 agents (scrape, competitors, keywords, questions) in parallel
# → Wave 2: SEO report + 3 diagrams in parallel
# → Wave 3: config files
# → Done! Open seo-pilot/seo-strategy.html

/seo-pilot blog-write "Resep Keripik Singkong Original"
# → Keyword research → brief → write → SEO check → schema → publish

/seo-pilot audit https://mysite.com
# → 5 audits parallel → combined report

/seo-pilot status
```
