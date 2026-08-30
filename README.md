# ✈️ SEO Pilot for Claude Code

Complete SEO workflow — 4 commands, each does a complete job. Keyword research, content creation, SEO optimization, site auditing — all orchestrated automatically with parallel subagents.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blue)
![Version](https://img.shields.io/badge/Version-2.0.0-green)

## How It Works

![SEO Pilot Workflow](docs/diagrams/workflow.svg)

SEO Pilot runs in **waves** — independent tasks launch as parallel subagents, dependent tasks wait for their inputs. Every subagent **loads relevant skills** before executing.

```
/seo-pilot init
  Wave 1 (parallel): Scrape + Competitors + Keywords + Questions
  Wave 2 (parallel): SEO Report + Diagrams
  Wave 3 (single):   Config files

/seo-pilot blog-write <topic>
  Wave 1 (parallel): Keyword Research + Discourse
  Wave 2 (sequential): Brief → Outline
  Wave 3 (single):   Write Article
  Wave 4 (parallel): SEO Check + Schema
  Wave 5 (single):   Final Assembly

/seo-pilot audit <url>
  Wave 1 (5 parallel): Technical + On-Page + Schema + GEO + Content Quality
  Wave 2 (single):     Combined Report
```

## Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Scrape site → Competitors → Keywords → SEO Report + Diagrams |
| `/seo-pilot blog-write <topic>` | Keyword research → Brief → Outline → Write → SEO Check → Schema → Publish |
| `/seo-pilot audit <url>` | Technical SEO + On-Page + Schema + GEO + Content Quality → Report |
| `/seo-pilot status` | Show pipeline progress |

## Mandatory Skill Loading

Every subagent loads **all relevant skills** before executing. More context = better output.

| Domain | Skills Loaded |
|--------|--------------|
| SEO | `seo-technical`, `seo-content`, `seo-geo`, `seo-schema`, `seo-page`, `seo-performance`, `seo-cluster`, `seo-flow` |
| Blog | `blog-write`, `blog-brief`, `blog-outline`, `blog-seo-check`, `blog-analyze`, `blog-schema`, `blog-strategy`, `blog-persona`, `blog-style`, `blog-discourse`, `blog-chart` |
| Content | `seo-content-brief`, `seo-content`, `blog-analyze` |
| Web | `defuddle`, `serper-api` |
| Visuals | `diagram-design`, `dataviz` |
| AI/GEO | `seo-geo`, `seo-flow`, `blog-geo` |

## Install

### One-Command (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Aguh18/claude-seo-pilot/main/install.sh | bash
```

### Clone & Install

```bash
git clone https://github.com/Aguh18/claude-seo-pilot.git
cd claude-seo-pilot
./install.sh
```

## Example

```bash
# First time — SEO research for your project
/seo-pilot init
# → Enter URL: https://mysite.com
# → Creates: seo-strategy.html, diagrams, keyword research, competitor analysis

# Write blog post — full SEO pipeline
/seo-pilot blog-write "How to Choose the Best [Product]"
# → Keyword research → Brief → Write → SEO Check → Schema → Published

# Audit site — all SEO dimensions
/seo-pilot audit https://mysite.com
# → 5 parallel audits → combined prioritized report

# Check progress
/seo-pilot status
```

## What Gets Created

After `init`, everything lives in `seo-pilot/`:

```
seo-pilot/
├── seo-strategy.html              # SEO strategy report (open in browser)
├── .seo-project.md                # Site config, keywords, competitors
├── .seo-state.json                # Pipeline tracker
├── diagrams/
│   ├── keyword-gap.html           # Keyword gap vs competitors
│   ├── content-cluster.html       # Hub-and-spoke content map
│   └── seo-priority.html          # Action items by impact/effort
├── research/
│   ├── website-analysis.md        # Site SEO elements
│   ├── competitors/*.md           # Per-competitor SEO analysis
│   ├── keywords/keyword-strategy.md
│   └── discourse/questions.md
├── content/                       # Generated blog posts
└── reports/                       # Audit reports
```

## Precondition

`blog-write`, `audit`, and `status` require `seo-pilot/` to exist. If missing:

> Run `/seo-pilot init` first to set up the project.

## Built-in Skills

| Skill | Credit |
|-------|--------|
| seo-pilot | [Aguh18](https://github.com/Aguh18) |
| blog | [Agrici Daniel](https://github.com/AgriciDaniel) |
| seo | [Agrici Daniel](https://github.com/AgriciDaniel) |
| diagram-design | [cathrynlavery](https://github.com/cathrynlavery/diagram-design) |
| defuddle | [Notion Labs](https://github.com/makenotion/defuddle) |
| Serper API | [serper.dev](https://serper.dev) |

## 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📝 License

MIT License — see [LICENSE](LICENSE)

---

> Made with ❤️ for anyone who wants to rank on Google
