---
name: seo-pilot
description: Complete SEO workflow orchestrator. 5 commands that each run a full multi-skill workflow. Init project, create content, audit SEO, check status, update skills. Use when user says "seo", "seo-pilot", "init project", "write blog", "seo audit", "site audit".
---

# SEO Pilot

5 commands. Each one does a complete job.

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Research project → create brand docs, voice, config |
| `/seo-pilot run <topic>` | Full pipeline → research → write → optimize → publish |
| `/seo-pilot audit <url>` | Full SEO audit → technical + content + GEO + report |
| `/seo-pilot status` | Show what's done and what's next |
| `/seo-pilot update` | Check & update upstream skills |

---

## `/seo-pilot init`

One command to set up everything. Scrapes your site, researches the market, creates all docs.

**What it does:**

1. **Scrape website** — understand products, pricing, structure, content
2. **Analyze competitors** — scrape top 3-5 competitors
3. **Research keywords** — SERP analysis, autocomplete, demand scoring
4. **Research discourse** — what people say about this topic (Reddit, X, YouTube)
5. **Generate brand docs** — BRAND.md, VOICE.md
6. **Create diagrams** — architecture, customer journey
7. **Setup Obsidian vault** — knowledge base structure
8. **Create config** — .seo-project.md, .seo-state.json

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

**After init, you have:**
- ✅ Complete understanding of your business
- ✅ Competitor landscape mapped
- ✅ Keywords identified with demand scores
- ✅ Brand & voice docs for consistent content
- ✅ Visual diagrams for strategy
- ✅ Obsidian vault as knowledge base
- ✅ Everything linked and organized

**Usage:**
```bash
/seo-pilot init
# → "Enter your website URL: https://keripikmangdedi.id"
# → (scrapes site, researches market, creates everything)
# → "✅ Done! 15 files created. Next: /seo-pilot run <topic>"
```

---

## `/seo-pilot run <topic>`

Full content pipeline for a topic. From research to published post.

**What it does:**

1. **Research** — discourse, keywords, SERP analysis
2. **Brief** — content brief with target keywords
3. **Outline** — SERP-informed structure
4. **Write** — full article using BRAND.md + VOICE.md
5. **SEO check** — on-page optimization
6. **Schema** — JSON-LD markup
7. **Diagram** — chart if data-heavy
8. **Publish** — save to content/ + obsidian-vault/
9. **Status** — update progress

**Usage:**
```bash
/seo-pilot run "Resep Keripik Singkong Original"
# → Full pipeline: research → write → optimize → publish
# → Saved to content/resep-keripik-singkong-original.md
```

**Also works for:**
```bash
/seo-pilot run "Why Our Chips Are Better"       # Blog post
/seo-pilot run "Kripset Jadul"                   # Product page
/seo-pilot run "Complete Guide to Cassava Chips" # Pillar page
```

---

## `/seo-pilot audit <url>`

Full SEO audit with actionable report.

**What it does:**
1. Technical SEO (crawlability, speed, mobile)
2. On-page SEO (title, headings, links, images)
3. Schema markup validation
4. AI citation readiness (ChatGPT, Perplexity, Gemini)
5. Content quality analysis
6. Generates combined report with prioritized fixes

**Usage:**
```bash
/seo-pilot audit https://keripikmangdedi.id
# → (runs: technical + onpage + schema + GEO + content)
# → "✅ Report saved to reports/audit-keripikmangdedi.id-2026-08-30.md"
```

---

## `/seo-pilot status`

Check pipeline progress.

**Shows:**
- Which research is done
- Which content is created
- Which SEO checks passed
- What's pending next

---

## `/seo-pilot update`

Check upstream skills for new versions and sync.

**What it does:**
1. Checks AgriciDaniel/claude-blog for updates
2. Checks AgriciDaniel/claude-seo for updates
3. Checks kepano/obsidian-skills for updates
4. Checks cathrynlavery/diagram-design for updates
5. Downloads and syncs to ~/.claude/skills/

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
# → Scrapes site, creates BRAND.md, VOICE.md, .seo-project.md

# 2. Create your first blog post
/seo-pilot run "How to Choose the Best [Your Product]"
# → Full pipeline: research → write → optimize

# 3. Audit your site
/seo-pilot audit https://mysite.com
# → Full report with fixes

# 4. Check progress
/seo-pilot status
```
