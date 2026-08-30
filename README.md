# 🔧 SEO Marketing Toolkit for Claude Code

Complete SEO marketing workflow combining web research, content creation, SEO optimization, and visual documentation for small businesses.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blue)
![Version](https://img.shields.io/badge/Version-1.0.0-green)

## 🎯 What This Does

One toolkit to rule them all:

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

### Option 1: Install All Skills

```bash
git clone https://github.com/aguhh/seo-marketing-toolkit.git
cd seo-marketing-toolkit
./install.sh
```

### Option 2: Install Individually

```bash
# Copy specific skill to ~/.claude/skills/
cp -r skills/seo-marketing ~/.claude/skills/
```

## 📦 Included Skills

| Skill | Description | Commands |
|-------|-------------|----------|
| **seo-marketing** | Master orchestrator | `/seo-marketing research`, `/seo-marketing content` |
| **blog** | 31 blog sub-skills | `/blog write`, `/blog seo-check`, `/blog geo` |
| **seo** | 15+ SEO sub-skills | `/seo-audit`, `/seo-technical` |
| **defuddle** | Web scraping | `defuddle parse <url> --md` |
| **obsidian-markdown** | Note formatting | Wikilinks, callouts, embeds |
| **diagram-design** | Visual diagrams | Architecture, flowcharts, ERD |

## 💡 Example Workflow

### 1. Research Competitor

```bash
# Scrape competitor website
defuddle parse https://kompetitor.com --md -o research/kompetitor.md

# Keyword research via Serper API
curl -s -X POST 'https://google.serper.dev/search' \
  -H "X-API-KEY: $SERPER_API_KEY" \
  -d '{"q": "keripik singkong", "gl": "id"}'
```

### 2. Create Content

```bash
# Generate content brief
/blog brief "Resep Keripik Singkong Original"

# Write optimized blog post
/blog write "Resep Keripik Singkong Original"
```

### 3. Optimize SEO

```bash
# Check SEO quality
/blog seo-check blog/resep-keripik.md

# AI citation optimization
/blog geo blog/resep-keripik.md

# Generate schema markup
/blog schema blog/resep-keripik.md
```

### 4. Document Everything

```bash
# Save to Obsidian vault
cp blog/resep-keripik.md obsidian-vault/research/

# Create architecture diagram
# (use diagram-design skill)
```

## 🏗️ Project Structure

```
seo-marketing-toolkit/
├── skills/                 # All Claude Code skills
│   ├── seo-marketing/     # Master orchestrator
│   ├── blog/              # 31 blog sub-skills
│   ├── seo/               # 15+ SEO sub-skills
│   ├── obsidian-tools/    # Web scraping & notes
│   └── diagram-design/    # Visual diagrams
├── templates/             # Vault templates
├── examples/              # Example workflows
├── install.sh             # One-click installer
├── LICENSE                # MIT License
└── README.md              # This file
```

## 🎨 Built For

- **Small businesses** like [Keripik Mang Dedi](https://keripikmangdedi.id) (cassava chips)
- **Bloggers** who want SEO-optimized content
- **Marketers** who need competitor research
- **Developers** who want knowledge management

## 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

1. Fork the repo
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## 📝 License

MIT License - see [LICENSE](LICENSE)

## 🙏 Credits

Built with:
- [Claude Code](https://claude.ai/code) - AI-powered coding assistant
- [Obsidian](https://obsidian.md) - Knowledge management
- [Serper API](https://serper.dev) - Google Search API
- [Defuddle](https://github.com/makenotion/defuddle) - Web content extraction

---

**Made with ❤️ for small businesses who want to rank on Google**
