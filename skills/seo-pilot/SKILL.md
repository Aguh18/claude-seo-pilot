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

One command to understand your project completely.

**What it does:**
1. Asks for website URL
2. Scrapes website → understand products, pricing, structure
3. Analyizes competitors from the market
4. Researches keywords and search demand
5. Creates all project files:

```
.seo-project.md          # Project config (products, keywords, competitors)
.seo-state.json          # Pipeline tracker
BRAND.md                 # Brand identity & positioning
VOICE.md                 # Writing tone & style guide
research/                # Research results
├── competitors/         # Competitor analysis
├── keywords/            # Keyword research
└── market/              # Market landscape
```

**After init, you have:**
- Complete understanding of your business
- Competitor landscape mapped
- Keywords identified
- Brand & voice docs ready for content creation

**Usage:**
```bash
/seo-pilot init
# → "Enter your website URL: https://keripikmangdedi.id"
# → (runs research automatically)
# → "✅ Project initialized. Next: /seo-pilot run <topic>"
```

---

## `/seo-pilot run <topic>`

Full content pipeline for a topic.

**What it does:**
1. Reads BRAND.md + VOICE.md for consistent tone
2. Researches topic (discourse, keywords, SERP)
3. Creates content brief
4. Writes optimized article
5. Runs SEO check
6. Generates schema markup
7. Saves to content folder
8. Updates status

**Usage:**
```bash
/seo-pilot run "Resep Keripik Singkong Original"
# → (runs: discourse → brief → outline → write → SEO → schema)
# → "✅ Saved to content/resep-keripik-singkong-original.md"
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
