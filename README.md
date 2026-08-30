# ✈️ SEO Pilot for Claude Code

Complete SEO workflow — 5 commands, each does a complete job. Research, write, optimize, audit — all orchestrated automatically.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blue)
![Version](https://img.shields.io/badge/Version-1.0.0-green)

## How It Works

![SEO Pilot Workflow](docs/diagrams/workflow.html)

```
seo-pilot/
├── init    → Scrape site → Competitors → Keywords → Brand docs → Diagrams → Vault
├── write   → Research → Brief → Outline → Write → SEO → Schema → Publish
├── audit   → Technical → On-page → Schema → GEO → Report
├── status  → Check progress
└── update  → Sync upstream skills
```

## 🚀 Install

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

## 📋 Commands

| Command | What It Does |
|---------|--------------|
| `/seo-pilot init` | Research project → BRAND.md, VOICE.md, diagrams, vault |
| `/seo-pilot write <topic>` | Research → write → optimize → publish |
| `/seo-pilot audit <url>` | Full SEO audit → technical + content + GEO |
| `/seo-pilot status` | Show pipeline progress |
| `/seo-pilot update` | Check & update upstream skills |

## Example

```bash
# First time — research everything about your project
/seo-pilot init
# Enter URL: https://mysite.com
# → Creates: BRAND.md, VOICE.md, diagrams, vault, config

# Write a blog post — full pipeline
/seo-pilot write "How to Choose the Best [Product]"
# → Researches topic, writes article, optimizes SEO, publishes

# Audit your site
/seo-pilot audit https://mysite.com
# → Full report with prioritized fixes

# Check what's done
/seo-pilot status
```

## What Gets Created

After `init`:

```
your-project/
├── .seo-project.md          # Config (products, keywords, competitors)
├── .seo-state.json          # Pipeline tracker
├── BRAND.md                 # Brand identity
├── VOICE.md                 # Writing tone & style
├── research/
│   ├── competitors/         # Competitor analysis
│   ├── keywords/            # Keyword research
│   └── market/              # Market landscape
├── content/                 # Created content
├── reports/                 # Audit reports
├── diagrams/                # Visual diagrams
│   ├── architecture.html
│   ├── customer-journey.html
│   └── erd.html
└── obsidian-vault/          # Knowledge base
```

## 🏗️ Repo Structure

```
claude-seo-pilot/
├── skills/
│   ├── seo-pilot/           # Orchestrator
│   ├── blog/                # Content creation
│   ├── seo/                 # SEO optimization
│   ├── diagram-design/      # Visual diagrams
│   └── obsidian-tools/      # Knowledge management
├── templates/
├── examples/
├── docs/diagrams/           # Workflow diagrams
├── install.sh
└── README.md
```

## Built-in Skills

| Skill | Credit |
|-------|--------|
| seo-pilot | [Aguh18](https://github.com/Aguh18) |
| blog | [Agrici Daniel](https://github.com/AgriciDaniel) |
| seo | [Agrici Daniel](https://github.com/AgriciDaniel) |
| obsidian-skills | [kepano](https://github.com/kepano/obsidian-skills) |
| diagram-design | [cathrynlavery](https://github.com/cathrynlavery/diagram-design) |
| defuddle | [Notion Labs](https://github.com/makenotion/defuddle) |
| Serper API | [serper.dev](https://serper.dev) |

## 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📝 License

MIT License — see [LICENSE](LICENSE)

---

> Made with ❤️ for anyone who wants to rank on Google
