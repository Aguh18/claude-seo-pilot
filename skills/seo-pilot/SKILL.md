---
name: seo-pilot
description: Complete SEO workflow orchestrator. Single entry point for research, content creation, SEO optimization, and publishing. Routes internally to blog, seo, defuddle, diagram-design, and obsidian skills. Use when user says "seo", "seo-pilot", "research competitor", "write blog", "optimize seo", "seo audit", "content refresh", "keyword research", "product page".
---

# SEO Pilot

Single command for everything. Each command runs a complete workflow combining multiple skills.

## Commands

### 📊 Research

| Command | What It Does |
|---------|--------------|
| `/seo-pilot competitor <url>` | Scrape site, analyze products/pricing, compare with us |
| `/seo-pilot keywords <topic>` | Keyword research + SERP + autocomplete analysis |
| `/seo-pilot discourse <topic>` | What people are saying last 30 days (Reddit, X, YouTube) |
| `/seo-pilot market <topic>` | Market landscape: competitors, trends, gaps |

### ✍️ Content

| Command | What It Does |
|---------|--------------|
| `/seo-pilot blog-post <topic>` | Brief → outline → write → SEO check → schema |
| `/seo-pilot rewrite <file>` | Analyze existing post → rewrite → optimize |
| `/seo-pilot content-refresh <file>` | Check decay → update stats → re-optimize |
| `/seo-pilot product-page <product>` | E-commerce product page with schema |
| `/seo-pilot pillar-page <topic>` | Long-form pillar content with internal links |

### 🔍 SEO

| Command | What It Does |
|---------|--------------|
| `/seo-pilot site-audit <url>` | Full technical SEO audit (speed, schema, crawlability) |
| `/seo-pilot page-audit <url>` | Single page: onpage + geo + schema + performance |
| `/seo-pilot schema <file>` | Generate JSON-LD for any content |
| `/seo-pilot geo-audit <file>` | AI citation readiness (ChatGPT, Perplexity, Gemini) |

### 📐 Visual & Docs

| Command | What It Does |
|---------|--------------|
| `/seo-pilot diagram architecture` | Backend architecture diagram |
| `/seo-pilot diagram erd` | Database ER diagram |
| `/seo-pilot diagram flow <process>` | Process flowchart |
| `/seo-pilot diagram journey` | Customer journey map |

### 🔄 System

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Initialize project |
| `/seo-pilot status` | Show pipeline progress |
| `/seo-pilot update` | Check & update upstream skills |

## How Each Command Works

### `/seo-pilot competitor <url>`

Internally runs:
1. `defuddle parse <url>` — scrape website
2. Extract products, pricing, structure
3. Compare with `.seo-project.md` data
4. Save to `research/competitors/<domain>.md`
5. Update `.seo-state.json`

### `/seo-pilot blog-post <topic>`

Internally runs:
1. Read `.seo-project.md` for context
2. `/blog discourse <topic>` — what people are saying
3. `/blog brief <topic>` — content brief
4. `/blog outline <topic>` — SERP-informed outline
5. `/blog write <topic>` — full article
6. `/blog seo-check <file>` — SEO validation
7. `/blog schema <file>` — schema markup
8. Save to `content/<slug>.md`
9. Update `.seo-state.json`

### `/seo-pilot site-audit <url>`

Internally runs:
1. `/seo-technical <url>` — technical SEO
2. `/seo-performance <url>` — Core Web Vitals
3. `/seo-schema <url>` — schema validation
4. `/seo-geo <url>` — AI citation audit
5. Generate combined report
6. Save to `reports/audit-<domain>-<date>.md`

### `/seo-pilot content-refresh <file>`

Internally runs:
1. Analyze current content
2. Check for outdated stats/info
3. Research fresh data
4. Rewrite with updates
5. Re-run SEO check
6. Save updated version

### `/seo-pilot product-page <product>`

Internally runs:
1. Read product data from `.seo-project.md`
2. Research competitor product pages
3. Write optimized product description
4. Generate Product schema JSON-LD
5. Add FAQ section
6. Save to `content/products/<slug>.md`

## Example Workflows

### New Blog Post

```bash
/seo-pilot blog-post "10 Resep Keripik Singkong Kekinian"
```

### Check Competitor

```bash
/seo-pilot competitor https://kompetitor.com
```

### Full Site Audit

```bash
/seo-pilot site-audit https://mysite.com
```

### Refresh Old Content

```bash
/seo-pilot content-refresh content/resep-keripik.md
```

### Build Product Page

```bash
/seo-pilot product-page "Kripset Jadul"
```

## Project Context

All commands read `.seo-project.md` automatically for:
- Business info, products, pricing
- Target keywords & competitors
- Brand voice & audience

## Pipeline State

Progress tracked in `.seo-state.json` automatically.
