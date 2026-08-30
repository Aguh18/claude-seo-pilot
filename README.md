# ✈️ SEO Pilot for Claude Code

Complete SEO workflow — research → content → optimize → publish. Built for anyone who wants to rank on Google.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blue)
![Version](https://img.shields.io/badge/Version-1.0.0-green)

## 🎯 What This Does

```
Research → Content → SEO → Visual → Knowledge Base
```

| Phase | Tools | Output |
|-------|-------|--------|
| **Research** | defuddle, Serper API | Competitor analysis, keyword data |
| **Content** | blog-write, blog-brief | Optimized blog posts |
| **SEO** | seo-audit, blog-seo, blog-geo | SEO-optimized content |
| **Visual** | diagram-design | Architecture & flow diagrams |
| **Knowledge** | obsidian-vault | Organized documentation |

## 🚀 Quick Start

### Install

```bash
git clone https://github.com/Aguh18/seo-pilot.git
cd seo-pilot
./install.sh
```

### Usage

```bash
# One command to rule them all
/seo-pilot init          # Setup project context
/seo-pilot research      # Research phase
/seo-pilot content       # Create content
/seo-pilot optimize      # SEO optimization
/seo-pilot diagram       # Visual diagrams
```

## 📦 Included Skills

| Skill | Commands | Credit |
|-------|----------|--------|
| **seo-pilot** | `/seo-pilot research`, `/seo-pilot content` | Built by [Aguh18](https://github.com/Aguh18) |
| **blog** | `/blog write`, `/blog seo-check`, `/blog geo` | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| **seo** | `/seo-audit`, `/seo-technical` | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| **defuddle** | `defuddle parse <url> --md` | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) |
| **obsidian-markdown** | Wikilinks, callouts, embeds | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) |
| **diagram-design** | Architecture, flowcharts, ERD | [cathrynlavery/diagram-design](https://github.com/cathrynlavery/diagram-design) |
| **Serper API** | SERP & keyword research | [serper.dev](https://serper.dev) |

## 💡 Example Workflow

### 1. Initialize Project

```bash
cp ~/.claude/skills/seo-pilot/templates/.seo-project.template.md .seo-project.md
# Edit with your business info
```

### 2. Research Competitor

```bash
defuddle parse https://kompetitor.com --md -o research/kompetitor.md
```

### 3. Create Content

```bash
/blog brief "Your Blog Topic"
/blog write "Your Blog Topic"
```

### 4. Optimize SEO

```bash
/blog seo-check blog/your-post.md
/blog geo blog/your-post.md
/blog schema blog/your-post.md
```

## 🏗️ Project Structure

```
seo-pilot/
├── skills/
│   ├── seo-pilot/         # Master orchestrator
│   ├── blog/              # 31 blog sub-skills
│   ├── seo/               # 15+ SEO sub-skills
│   ├── obsidian-tools/    # Web scraping & notes
│   └── diagram-design/    # Visual diagrams
├── templates/
│   ├── .seo-project.template.md
│   └── .seo-state.template.json
├── examples/
│   └── keripik-mang-dedi/ # Demo project
├── install.sh
├── LICENSE
└── README.md
```

## 🎨 Built For

- **Small businesses** who want to rank on Google
- **Bloggers** who want SEO-optimized content
- **Marketers** who need competitor research
- **Content creators** who want AI-powered workflow
- **Anyone** who wants a complete SEO toolkit

## 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

1. Fork the repo
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## 📝 License

MIT License — see [LICENSE](LICENSE)

## 🙏 Credits

| Project | Author | License |
|---------|--------|---------|
| [claude-code](https://github.com/anthropics/claude-code) | Anthropic | MIT |
| [obsidian-skills](https://github.com/kepano/obsidian-skills) | kepano | MIT |
| [diagram-design](https://github.com/cathrynlavery/diagram-design) | cathrynlavery | MIT |
| [defuddle](https://github.com/makenotion/defuddle) | Notion Labs | MIT |
| [Serper API](https://serper.dev) | Serper | Commercial |
| [Obsidian](https://obsidian.md) | obsidian.md | Free |

---

**Made with ❤️ for anyone who wants to rank on Google**
