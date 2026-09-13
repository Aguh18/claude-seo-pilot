---
name: seo-pilot
description: >
  Complete SEO workflow orchestrator. 5 commands that each run a full
  multi-skill workflow. Init project, create content, audit SEO, re-audit,
  check status. Use when user says "seo", "seo-pilot", "init project",
  "blog-write", "seo audit", "reaudit", "site audit".
user-invocable: true
argument-hint: "[init|blog-write|audit|reaudit|status] [topic-or-url]"
license: MIT
metadata:
  author: Aguh18
  version: "1.1.0"
  category: seo
---

# SEO Pilot

SEO-focused skill. Maximize organic search visibility for your website. 5 commands, parallel subagents.

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Research project → keyword strategy, competitor SEO gaps, content plan, SEO report |
| `/seo-pilot blog-write <topic>` | Full pipeline → keyword research → brief → write → SEO optimize → publish |
| `/seo-pilot audit <url>` | Full SEO audit → technical + on-page + schema + GEO + report |
| `/seo-pilot reaudit <url>` | Clean old audit files → re-run full audit with fresh timestamped output |
| `/seo-pilot status` | Show what's done and what's next |

---

## Output Directory

**ALL generated files go to `seo-pilot/<domain>/` folder in the project root.** Each website gets its own folder. Never scatter files.

On first run, extract domain from URL and create:
```
DOMAIN=$(echo "$URL" | sed 's|https\?://||' | sed 's|/.*||')
mkdir -p seo-pilot/$DOMAIN/{research/{competitors,keywords,discourse},content,reports,diagrams,obsidian-vault/{notes,products,strategy}}
```

Example: `seo-pilot/keripikmangdedi.id/`, `seo-pilot/example.com/`

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
Agent 5: Generate SEO strategy report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz", "blog-analyze"
  - Input: all Wave 1 research
  - Output:
    - seo-pilot/seo-strategy.html (interactive HTML report, dark theme, charts)
    - seo-pilot/seo-strategy.md (markdown version for quick reference)
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
Agent 7: Create config files + Obsidian vault
  - seo-pilot/.seo-project.md (site info, target keywords, competitors)
  - seo-pilot/.seo-state.json (pipeline tracker)
  - seo-pilot/obsidian-vault/ (knowledge base structure)
    ├── 00-index.md (hub page linking all notes)
    ├── notes/ (research notes from Wave 1)
    ├── products/ (product docs)
    └── strategy/ (SEO strategy docs)
```

**Init is NOT complete until Wave 3 finishes.**

### Report Requirements

`seo-pilot/seo-strategy.html` — single self-contained HTML, **bright theme with sidebar navigation**, charts as inline SVG/CSS.

#### Design Requirements (MANDATORY)

**Theme: Bright & Clean**
- White/light background (`#f8fafc` or `#ffffff`), dark text (`#1e293b`)
- Accent colors: Blue (`#3b82f6`), Green (`#10b981`), Yellow (`#f59e0b`), Orange (`#f97316`), Red (`#ef4444`)
- Cards with subtle shadows (`box-shadow: 0 1px 3px rgba(0,0,0,0.1)`)
- Rounded corners (`border-radius: 12px`)
- NO dark theme — must be easy to read in daylight

**Sidebar Navigation (REQUIRED)**
- Fixed left sidebar (width: 260px) with section links
- Sticky on scroll (position: sticky, top: 0, height: 100vh)
- Collapsible on mobile (hamburger menu)
- Sections listed with icons (emoji or SVG)
- Active section highlighted as user scrolls
- Smooth scroll to section on click
- Sidebar includes: site name, health score badge, section list

**Layout:**
```
┌──────────────┬────────────────────────────────┐
│   SIDEBAR    │         MAIN CONTENT           │
│              │                                │
│ 🏠 Summary   │  [Hero Section]                │
│ 📊 Scores    │  [Score Cards]                 │
│ 🔧 Technical │  [Category Details]            │
│ 📝 On-page   │                                │
│ 🏷️ Schema    │                                │
│ 🤖 GEO       │                                │
│ 📖 Content   │                                │
│ ✅ Actions   │                                │
└──────────────┴────────────────────────────────┘
```

**Sections:**

1. **Hero** — Site name, URL, date, one-line positioning, health score gauge
2. **Score Overview** — 5 category score cards with horizontal progress bars (Technical, On-page, Schema, GEO, Content)
3. **Critical Issues** — Red-highlighted cards with issue details
4. **High Priority** — Orange-highlighted cards
5. **Medium Priority** — Yellow-highlighted cards
6. **Low Priority** — Blue-highlighted cards
7. **Technical SEO Details** — Collapsible section with pass/fail checklist
8. **On-Page SEO Details** — Collapsible section with element analysis
9. **Schema Details** — Collapsible section with validation results
10. **GEO / AI Readiness** — Collapsible section with platform scores
11. **Content Quality** — Collapsible section with E-E-A-T breakdown
12. **Action Plan** — Prioritized table with effort/impact matrix

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
Agent 6: Combined audit report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all 5 audit results
  - Output:
    - seo-pilot/reports/audit.html (interactive HTML report, BRIGHT theme with sidebar)
    - seo-pilot/reports/audit.md (markdown version for quick reference)
  - Prioritized: Critical → High → Medium → Low
  - HTML MUST include:
    - Fixed sidebar navigation with section links
    - Bright theme (white bg, colored accents)
    - Health scores as gauge + horizontal bars
    - Pass/fail checklist with ✅❌⚠️ icons
    - Priority action items color-coded
    - Collapsible sections per category
    - Responsive design (sidebar collapses on mobile)
  - See "Report Requirements" above for full design spec
```

---

## `/seo-pilot reaudit <url>`

**Full re-audit: clean slate.** Deletes old audit artifacts, then re-runs the complete audit from scratch with fresh timestamped files.

**Precondition:** `seo-pilot/` must exist. If missing:
> "Jalankan `/seo-pilot init` dulu."

### Phase 0: CLEAN — Remove stale files

```bash
DOMAIN=$(echo "$URL" | sed 's|https\?://||' | sed 's|/.*||')

# Delete all old audit reports (HTML, MD)
rm -f seo-pilot/$DOMAIN/reports/audit-*.html
rm -f seo-pilot/$DOMAIN/reports/audit-*.md
rm -f seo-pilot/$DOMAIN/reports/technical-audit.md
rm -f seo-pilot/$DOMAIN/reports/onpage-audit.md
rm -f seo-pilot/$DOMAIN/reports/schema-audit.md
rm -f seo-pilot/$DOMAIN/reports/geo-audit.md
rm -f seo-pilot/$DOMAIN/reports/content-quality-audit.md

# Delete old diagrams
rm -f seo-pilot/$DOMAIN/diagrams/*.html

# Delete old SEO strategy
rm -f seo-pilot/$DOMAIN/seo-strategy.html
rm -f seo-pilot/$DOMAIN/seo-strategy.md

# Recreate clean dirs
mkdir -p seo-pilot/$DOMAIN/{reports,diagrams}
```

**Do NOT delete:**
- `.seo-project.md` — project config (persistent)
- `.seo-state.json` — pipeline state (persistent)
- `research/` — keyword & competitor research (reusable)
- `obsidian-vault/` — knowledge base (persistent)
- `content/` — blog posts (persistent)

**Log what was deleted:**
```
🗑️  Cleaned 7 old files from seo-pilot/$DOMAIN/reports/
🗑️  Cleaned 3 old diagrams from seo-pilot/$DOMAIN/diagrams/
```

### Phase 1: AUDIT — Fresh 5-agent parallel audit

Generate timestamp: `TIMESTAMP=$(date +"%Y-%m-%d-%H%M")` (e.g., `2026-08-31-1430`)

All output files use format: `audit-<domain>-<TIMESTAMP>.html` / `.md`

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

### Phase 2: REPORT — Combined report

```
Agent 6: Combined audit report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all 5 audit results from Phase 1
  - Output:
    - seo-pilot/reports/audit.html (BRIGHT theme with sidebar navigation)
    - seo-pilot/reports/audit.md
  - Include: health scores, pass/fail checklist, priority actions, per-category breakdowns
  - See "Report Requirements" above for full design spec (sidebar, bright theme, collapsible sections)
```

### Output files (fresh, timestamped)

```
seo-pilot/$DOMAIN/
├── reports/
│   ├── audit-<domain>-<TIMESTAMP>.html    ← NEW (replaces old)
│   ├── audit-<domain>-<TIMESTAMP>.md      ← NEW (replaces old)
│   ├── technical-audit.md                 ← NEW
│   ├── onpage-audit.md                    ← NEW
│   ├── schema-audit.md                    ← NEW
│   ├── geo-audit.md                       ← NEW
│   └── content-quality-audit.md           ← NEW
├── diagrams/
│   ├── keyword-gap.html                   ← NEW (if regenerated)
│   ├── content-cluster.html               ← NEW (if regenerated)
│   └── seo-priority.html                  ← NEW (if regenerated)
├── .seo-project.md                        ← KEPT
├── .seo-state.json                        ← KEPT
├── research/                              ← KEPT
├── content/                               ← KEPT
└── obsidian-vault/                        ← KEPT
```

### Summary output

```
🔄 Re-audit complete for <domain>

🗑️  Cleaned: 7 old reports, 3 old diagrams
🆕 Generated: 2026-08-31 14:30 WIB

Files:
  📊 reports/audit-<domain>-2026-08-31-1430.html  (open in browser)
  📄 reports/audit-<domain>-2026-08-31-1430.md
  🔧 reports/technical-audit.md
  📝 reports/onpage-audit.md
  🏷️  reports/schema-audit.md
  🤖 reports/geo-audit.md
  📖 reports/content-quality-audit.md

Health Score: XX/100
Critical: X | High: X | Medium: X | Low: X
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
