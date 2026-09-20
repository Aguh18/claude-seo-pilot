# 🧰 Freelance for Claude Code

Freelance is a client web-build workflow for Claude Code — 6 commands that take a client from
discovery to a **handoff bundle of 10 documents** any AI can read to build the website.

Works whether the client already has a site or only has a business name.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blue)
![Version](https://img.shields.io/badge/Version-2.0.0-green)

## How It Works

![Freelance Workflow](docs/diagrams/workflow.svg)

Freelance runs tasks in parallel where possible, then chains dependent steps together.

## Two Ways In

`init` accepts either an existing site or just a business name. Both converge on the same bundle.

- **Client already has a website** — `/freelance init https://klien.com`. Scrapes it, researches
  the market, then translates that material into the bundle. Existing tokens, page structure, and
  audit findings feed documents 03, 04, and 07.
- **No website yet** — `/freelance init "Warung Kopi Kenangan"`. Nothing to scrape, so it researches
  the market first, drafts a proposal, and **stops for your correction** before writing anything.

## The Handoff Bundle

This is the deliverable. Everything else is input to it.

| # | Document | Contents |
|---|----------|----------|
| 00 | `00-handoff.md` | Master prompt: read these in order, build the site |
| 01 | `01-brief.md` | Business, goals, audience, offer, differentiators |
| 02 | `02-brand.md` | Voice, tone, personality |
| 03 | `03-design-tokens.md` | Colour, typography, spacing, radii |
| 04 | `04-sitemap.md` | Pages, hierarchy, navigation, CTA per page |
| 05 | `05-layout.md` | **Per page: section order, visual weight, text budget** |
| 06 | `06-content/*.md` | Copy for each page — rendering text plus an SEO layer |
| 07 | `07-tech-spec.md` | Stack, hosting, CMS, components, integrations |
| 08 | `08-seo-foundation.md` | Keywords, meta, schema, internal linking |
| 09 | `09-build-prompt.md` | Copy-paste version — all of the above inlined |

Plus `overview.html` — a bright, sidebar-navigated page for presenting the plan to a
non-technical client.

The client folder is also the Obsidian vault: a single `00-index.md` at its root links every
document with `[[wiki-links]]`, across all the folders.

### Organised by function

Each folder holds both the documents that plan the work and the output that work produces, so
`blog/` is everything about content rather than half of it.

```
klien/<slug>/
├── 00-index.md        vault hub — links everything
├── build/             the handoff bundle — hand this folder over
├── blog/              content plan + written articles
├── seo/               keyword strategy, research, reports, diagrams
├── ads/               ads strategy + diagrams
├── site/              optional scaffold
└── notes/ products/ strategy/
```

`build/` is the unit you hand over: eight files, complete on their own, with `09-build-prompt.md`
as the flattened paste version.

### Two handoff formats

- **`00-handoff.md`** is a *pointer*. For a builder AI that can read the folder — it opens
  documents 01–08 in a set order.
- **`09-build-prompt.md`** is a *paste*. It inlines the full text of 01–08 plus every page of
  `06-content/`, so the whole spec survives one Ctrl-A → Ctrl-C into an AI that cannot see the
  filesystem.

A real bundle runs 10–20k words. If that exceeds your target AI's context window, paste in waves —
`08` names the reading order so partial pastes still work.

## Commands

| Command | What It Does |
|---------|--------------|
| `/freelance init <name-or-url>` | Discovery → **10-document handoff bundle** + overview.html + ads strategy |
| `/freelance blog-write <topic>` | Keyword research → Brief → Outline → Write → SEO Check → Schema → Publish |
| `/freelance audit <url>` | Technical SEO + On-Page + Schema + GEO + Content Quality → Report |
| `/freelance reaudit <url>` | Clean old audit files → re-run full audit with fresh timestamped output |
| `/freelance ads <url>` | Ads Audit + Platform Analysis + Budget Plan + Campaign Structure → Report |
| `/freelance status` | Show pipeline progress |

## Optional Scaffold

Once `07-tech-spec.md` exists, Freelance can scaffold a starter project at `klien/<slug>/site/`.
**It reads the stack from the tech spec** — Next.js, Astro, or static HTML — rather than assuming
one. Design tokens become CSS custom properties; one placeholder file is created per page in the
sitemap. Structure only: the builder AI fills in the content from `06-content/`.

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

## What Gets Created

After `init`, everything lives in `klien/<slug>/`:

![File Structure](docs/diagrams/file-structure.svg)

## Precondition

`blog-write`, `audit`, `reaudit`, `ads`, and `status` require `klien/<slug>/` to exist. If missing:

> Run `/freelance init` first to set up the project.

## Built-in Skills

| Skill | Credit |
|-------|--------|
| freelance | [Aguh18](https://github.com/Aguh18) |
| blog | [Agrici Daniel](https://github.com/AgriciDaniel) |
| seo | [Agrici Daniel](https://github.com/AgriciDaniel) |
| ads | [Agrici Daniel](https://github.com/AgriciDaniel) |
| diagram-design | [cathrynlavery](https://github.com/cathrynlavery/diagram-design) |
| defuddle | [Notion Labs](https://github.com/makenotion/defuddle) |
| Serper API | [serper.dev](https://serper.dev) |

## 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📝 License

MIT License — see [LICENSE](LICENSE)

---

> Made with ❤️ for freelancers who'd rather spec the work than guess at it
