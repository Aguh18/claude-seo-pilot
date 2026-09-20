---
name: freelance
description: >
  Client web-build orchestrator for freelancers. Branch A (existing site):
  research, SEO audit, and marketing collateral. Branch B (no site yet):
  10-document handoff bundle for building the website. Also runs blog pipelines,
  audits, and ads strategy. Use when user says "freelance", "client",
  "init project", "build a website for", "web untuk klien", "company profile",
  "handoff", "build prompt", "seo audit", "blog-write", or "reaudit".
user-invocable: true
argument-hint: "[init|blog-write|audit|reaudit|ads|project-fix|status] [name-or-url]"
license: MIT
metadata:
  author: Aguh18
  version: "2.0.0"
  category: freelance
---

# Freelance

Client web-build orchestrator. Take a client from discovery to a documented build spec.
7 commands, parallel subagents.

## Commands

| Command | What It Does |
|---------|--------------|
| `/freelance init <name-or-url>` | **Branch A (existing site):** research + SEO audit + ads strategy. **Branch B (no site):** research → confirm → **10-document handoff bundle** + overview + ads |
| `/freelance blog-write <topic>` | Full pipeline → keyword research → brief → write → SEO optimize → publish |
| `/freelance audit <url>` | Full SEO audit → technical + on-page + schema + GEO + report |
| `/freelance reaudit <url>` | Re-run full audit → overwrite audit reports + overview with fresh data |
| `/freelance ads <url>` | Ads audit → platform analysis → budget plan → campaign structure → report |
| `/freelance project-fix <slug>` | Trace project files → fix issues based on bundle docs → report what needs manual fix |
| `/freelance status` | Show what's done and what's next |

---

## Two Ways In

`init` accepts either an existing site or just a business name. The paths
diverge: an existing site gets research + audit + marketing; a new site
gets a handoff bundle for building.

**Branch A — the client already has a website** (`/freelance init https://...`):
scrape it, research the market, run a full SEO audit, and produce marketing
collateral (ads strategy, content plan). **No build bundle** — the website
already exists; the deliverable is the audit and marketing plan.

**Branch B — no website yet** (`/freelance init "Warung Kopi Kenangan"`):
there is nothing to scrape, so research first and confirm second, then
produce the 10-document handoff bundle.

1. **Research** (parallel agents): market and competitors from the name given;
   search demand and keywords; discourse and real questions; visual references
   and site patterns common in that industry.
2. **Draft** the bundle content from what the research returned — proposed
   positioning, audience, offer, page map, brand direction, candidate tokens.
3. **Confirm with the user.** Present the draft as something to correct
   ("dari riset, audiensnya kelihatannya X — betul?"), never a from-scratch
   interview. This is deliberately cheap to correct and expensive to redo.
4. Only the corrected draft becomes the bundle.

---

## The Handoff Bundle

Ten markdown documents plus one presentation page. This is the deliverable —
everything else is input to it.

| # | Document | Contents | Built from |
|---|----------|----------|------------|
| 00 | `00-handoff.md` | Master prompt: read these in order, build the site | **new** |
| 01 | `01-brief.md` | Business, goals, audience, offer, differentiators | `seo-plan` Step 1 |
| 02 | `02-brand.md` | Voice, tone, personality | `blog-brand`, `blog-persona` |
| 03 | `03-design-tokens.md` | **Visual direction** + colour, typography, spacing, radii | `high-end-visual-design`, `design-taste-frontend`, `diagram-design` |
| 04 | `04-sitemap.md` | Pages, hierarchy, navigation, CTA per page | `seo-plan` Step 3, `seo-sitemap` |
| 05 | `05-layout.md` | **Per page: section order, visual weight, text budget** | **new** |
| 05 | `06-content/*.md` | Copy for each page | `seo-content-brief` page types |
| 06 | `07-tech-spec.md` | Stack, hosting, CMS, components, integrations | **new** |
| 07 | `08-seo-foundation.md` | Keywords, meta, schema, internal linking | `seo-cluster`, `seo-schema`, `seo-page` |
| 08 | `09-build-prompt.md` | Self-contained paste — all of the above inline | **new** |

Plus `overview.html` — bright theme with sidebar, same design as the audit
reports, for presenting the plan to a non-technical client.

### Two handoff formats, two consumers

`00-handoff.md` and `09-build-prompt.md` solve different problems:

- **`00-handoff.md`** is a *pointer*. It tells a builder that can read the folder
  to open the rest of `build/` in a set order. Short, and the single source of
  truth stays in the other seven documents.
- **`09-build-prompt.md`** is a *paste*. It inlines the full text of 01–08 and
  every `06-content/` page, so the whole spec survives one Ctrl-A → Ctrl-C into
  an AI that cannot see the filesystem.

**Boundary: 08 carries the website spec only.** The ads plan (Wave 5) and the
research reports are marketing collateral for *after* launch — they say how to
promote the site, not how to build it. They stay out — in `ads/`, `blog/`, and `seo/`.

Generate 08 **last**, after 01–08 are final. It is mechanical assembly — build
it by reading the finished files, never by regenerating their content, or the
two copies will drift.

Known trade-off: a real client's bundle runs long (10–20k words) and may exceed
a small context window. If that happens, tell the user to paste documents in
waves — `08` names the reading order so partial pastes still work. Do not
silently drop sections to shorten it.

### Three constraints that override skill defaults

1. **Canonical voice schema is `blog-persona`'s four axes**
   (`funny_serious`, `formal_casual`, `respectful_irreverent`,
   `enthusiastic_matter_of_fact`). `ads/references/voice-to-style.md` uses six
   different axes — when the ads pipeline runs, map to those explicitly rather
   than storing a second voice definition.
2. **Brand always lives at `klien/<slug>/build/02-brand.md`**, never `BRAND.md` and
   never at the project root. `blog-brand` defaults to project root; override it.
3. **`seo-content-brief` covers 9 page types but not Contact.** Write Contact
   pages from the Homepage CTA pattern: form, NAP block, map, operating hours.
4. **The bundle must decide how the site looks, not only what it says.** A
   bundle with good copy and a colour palette but no visual direction produces
   a page that ranks and looks templated — centred hero, three feature cards,
   stock footer. `03-design-tokens.md` therefore carries visual direction, and
   `09-build-prompt.md` carries the anti-slop rules. See below.

### Why 05-layout exists

A bundle that is rich in prose and silent on layout produces a text-heavy page.
That is not the builder's fault: it receives seven documents of writing plus
page copy, and no hierarchy, so it gives every section equal weight.

`05-layout.md` is the answer. It is the authority on how each page is composed:

- **Section order** per page, taken from `04-sitemap`'s page list.
- **Visual weight** per section — full-screen, half, or thin strip. Say which
  one section carries the page.
- **Text budget** per section, in words. This is a cap, not a target.
- **Media** per section — image, diagram, or none, and how much room it takes.
- **Whitespace** — where the page is allowed to breathe heavily.

**`06-content` must fit inside the budget `05-layout` sets.** The copy engine
writes SEO-dense prose by design — 40-60 word snippet answers, one definition
box per service — and left unconstrained it fills every section until the page
is a wall of text. Visual hierarchy and SEO density pull opposite ways; the
layout document is where the tie is broken, deliberately, per section.

The rule: a section with a two-line budget gets two lines on the page. Anything
longer belongs in the SEO layer (meta description, schema, an FAQ section), not
in the hero.

### Linking — the bundle is a vault, not loose files

Everything under `klien/<slug>/` is one Obsidian vault, so documents link to
each other with **`[[wiki-links]]`** — not relative paths. Wikilinks resolve by
filename anywhere in the vault, which is why the whole set must share one root.

**Rule: every document 01–08 opens with a `related:` line and carries a
`**Related:**` line at the foot listing its wikilinks.** The convention matches
what the existing vault output already does — a hub note listing everything,
each note linking sideways to its siblings, and each note linking back to the
hub. Follow that shape.

| Document | Links to | Authority it holds |
|---|---|---|
| `00-handoff.md` | all of 01–08 — it is the entry point | reading order |
| `01-brief.md` | `[[02-brand]]` `[[04-sitemap]]` `[[08-seo-foundation]]` | business goals, audience, offer |
| `02-brand.md` | `[[01-brief]]` `[[03-design-tokens]]` `[[06-content]]` | voice and tone |
| `03-design-tokens.md` | `[[02-brand]]` `[[07-tech-spec]]` | **visual direction** + colour, type, spacing — final |
| `04-sitemap.md` | `[[01-brief]]` `[[06-content]]` `[[08-seo-foundation]]` | **the page list — final** |
| `05-layout.md` | `[[03-design-tokens]]` `[[04-sitemap]]` `[[06-content]]` | **how each page is composed — final** |
| `06-content/*.md` | `[[02-brand]]` `[[04-sitemap]]` | the copy itself |
| `07-tech-spec.md` | `[[03-design-tokens]]` `[[04-sitemap]]` | stack and components — final |
| `08-seo-foundation.md` | `[[04-sitemap]]` `[[research/content-plan]]` | keywords, meta, schema |
| `00-index.md` (hub) | every bundle doc and every note | vault navigation |

**Authority matters more than the links.** Two documents can disagree —
`06-content` might invent a page that `04-sitemap` never listed, or
`07-tech-spec` might pick a colour that `03-design-tokens` already fixed. Each
row above names who wins, so a builder resolves a conflict by looking it up
rather than guessing. State the authority line explicitly in each document.

`09-build-prompt.md` is the exception: it must survive being pasted somewhere
with no folder around it, so it carries **no wikilinks and no relative paths**.
It already inlines the content those links would have pointed at.

### Visual direction — the part SEO does not cover

A bundle can be fully SEO-complete and still produce an ugly, templated site.
That is what happens when the only visual input is a colour palette: the builder
fills the gap with defaults. `03` and `08` both carry visual decisions.

**`03-design-tokens.md` carries, in this order:**

1. **Visual direction** — one paragraph naming the intended feel and the single
   idea the design is built around. Decide it from `01-brief`'s audience, not
   from taste. A warung and a law firm do not want the same thing.
2. **Layout archetype per page** — for each page in `04-sitemap`, which
   structural pattern it uses, chosen to differ across the site. A homepage and
   a services page must not share one skeleton.
3. **Section compositions** — the sections each page is built from, in order,
   with what each one carries. This is the difference between "a services page"
   and an actual services page.
4. **Then the tokens** — colour roles, type ramp, spacing grid, radii.

**Anti-slop rules.** Load `high-end-visual-design`, `design-taste-frontend`, and
`frontend-design` (all vendored under `skills/`, see `skills/VENDORED.md`) and
distil their constraints into `03`. These are the rules that stop the defaults:

- **Banned fonts:** Inter, Roboto, Arial, Open Sans, Helvetica.
- **Banned layouts:** centred hero over three equal feature cards; symmetrical
  three-column grids with no whitespace; edge-to-edge sticky navbars.
- **Banned borders and shadows:** generic 1px solid grey borders; harsh dark
  drop shadows (`shadow-md`, `rgba(0,0,0,0.3)`).
- **Banned motion:** `linear` or `ease-in-out` transitions; instant state
  changes.
- **Whitespace is not optional:** sections need generous vertical padding.
- Never the same layout twice in one site.

**Where each part lands:** the direction, layout, and composition go into `03`.
The banned lists and the builder's pre-output checklist go into `08`, because
they must survive the paste. `08` is the only place a builder that cannot see
the folder will ever read them.

---


## Output Directory

**ALL generated files go to `klien/<slug>/` folder in the project root.** Each client gets its own folder. Never scatter files.

**`<slug>` comes from whichever identifier the client actually has:**

| Situation | Slug | Example |
|---|---|---|
| Client already has a site | the domain, lowercase, no `www.` | `keripikmangdedi.id` |
| No site yet | the business name, lowercased, non-alphanumerics → `-` | `warung-kopi-kenangan` |

Branch B has no domain by definition, so never invent a fake one — a folder named
after a domain that does not exist confuses everyone who reads it later.

**The client folder IS the Obsidian vault.** Do not nest a separate `obsidian-vault/`
inside it — wiki-links resolve by filename within a vault, so the bundle documents
and the research notes can only link to each other if they share one vault root.
That shared root is `klien/<slug>/`.

Inside it, everything is grouped **by function**, the same way this repo groups
its skills. A folder holds both the documents that plan the work and the output
that work produces, so `blog/` is everything about content, not half of it.

### Branch A — existing website (no build bundle)

```
klien/<slug>/
├── 00-index.md              vault hub — links everything
├── blog/
│   ├── content-plan.md      what to publish, in what order
│   └── articles/            written posts
├── seo/
│   ├── keyword-strategy.md
│   ├── research/            competitor + discourse analysis
│   ├── reports/             audit output
│   └── diagrams/
├── ads/
│   ├── ads-strategy.md
│   └── diagrams/
├── notes/                   research notes
├── products/                product and service docs
└── strategy/                positioning, roadmap
```

Derive the slug, then create the tree:
```
SLUG=$(echo "$URL" | sed -E 's|^https?://||; s|^www\.||; s|/.*||' | tr '[:upper:]' '[:lower:]')
mkdir -p klien/$SLUG/{blog,blog/articles,seo,seo/research,seo/reports,seo/diagrams,ads,ads/diagrams,notes,products,strategy}
```

### Branch B — no website yet (with build bundle)

```
klien/<slug>/
├── 00-index.md              vault hub — links everything
├── build/                   the handoff bundle, one self-contained package
│   ├── 01-brief.md
│   ├── 02-brand.md
│   ├── 03-design-tokens.md
│   ├── 04-sitemap.md
│   ├── 06-content/          copy for each page
│   ├── 07-tech-spec.md
│   ├── 08-seo-foundation.md
│   └── 09-build-prompt.md   paste this, or hand over the whole build/
├── blog/
│   ├── content-plan.md      what to publish, in what order
│   └── articles/            written posts
├── seo/
│   ├── keyword-strategy.md
│   ├── research/            competitor + discourse analysis
│   ├── reports/             audit output
│   └── diagrams/
├── ads/
│   ├── ads-strategy.md
│   └── diagrams/
├── site/                    optional scaffold, shaped by build/07-tech-spec.md
├── notes/                   research notes
├── products/                product and service docs
└── strategy/                positioning, roadmap
```

**`build/` is the unit you hand over.** It is complete on its own: those eight
files are everything a builder needs, and `09-build-prompt.md` is the flattened
version of the other seven for pasting somewhere with no filesystem.

Derive the slug, then create the tree:
```
SLUG=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed 's|[^a-z0-9]|-|g' | sed 's|--*|-|g' | sed 's|^-||;s|-$||')
mkdir -p klien/$SLUG/{build,build/06-content,blog,blog/articles,seo,seo/research,seo/reports,seo/diagrams,ads,ads/diagrams,notes,products,strategy}
```

Examples: `klien/keripikmangdedi.id/`, `klien/warung-kopi-kenangan/`

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
| Ads | `ads`, `ads-audit`, `ads-plan`, `ads-budget`, `ads-competitor`, `ads-create`, `ads-monitor`, `ads-optimize`, `ads-research` |
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
| Client overview report | `general-purpose` | `diagram-design`, `dataviz` |
| Brand docs | `general-purpose` | `blog-brand`, `blog-persona`, `blog-style` |
| Bundle: brief + brand | `general-purpose` | `seo-plan`, `blog-brand`, `blog-persona` |
| Bundle: tokens + sitemap | `general-purpose` | `high-end-visual-design`, `design-taste-frontend`, `frontend-design`, `diagram-design`, `seo-plan`, `seo-sitemap` |
| Bundle: layout | `general-purpose` | `high-end-visual-design`, `design-taste-frontend`, `diagram-design` |
| Bundle: page copy | `general-purpose` | `seo-content-brief` |
| Bundle: tech spec + SEO | `general-purpose` | `seo-technical`, `seo-schema`, `seo-cluster`, `seo-page` |
| Bundle: handoff (00 only, not 08) | `general-purpose` | `diagram-design` |
| Content plan (research output, not bundle) | `general-purpose` | `blog-strategy`, `blog-cluster`, `seo-cluster` |
| Bundle: 09-build-prompt assembly | `general-purpose` | none — verbatim concatenation only |
| Market discovery (no site yet) | `general-purpose` | `defuddle`, `seo-content`, `blog-discourse` |
| Discovery proposal draft | `general-purpose` | `blog-brand`, `seo-plan`, `seo-content-brief` |
| Ads platform audit | `general-purpose` | `ads`, `ads-audit`, `ads-google`, `ads-meta` |
| Competitor ads analysis | `general-purpose` | `ads`, `ads-competitor`, `ads-research` |
| Budget & campaign planning | `general-purpose` | `ads`, `ads-plan`, `ads-budget`, `ads-math` |
| Ads strategy report | `general-purpose` | `diagram-design`, `dataviz`, `ads-report` |
| Project-fix iteration | `general-purpose` | `diagram-design` (for vault hub) |
| Full audit (all) | multiple agents | Each agent loads its own skills per row above |
| blog-write pipeline | multiple agents | Each wave loads its own skills per row above |
| ads pipeline | multiple agents | Each wave loads its own skills per row above |

---

## `/freelance init`

Set up client project. Scrapes site, researches keywords + competitors, creates SEO strategy.

### Branch A — existing website

**No build bundle.** The website already exists; the deliverable is research,
audit, and marketing collateral.

**First:** `mkdir -p klien/<slug>/{blog,blog/articles,seo,seo/research,seo/reports,seo/diagrams,ads,ads/diagrams,notes,products,strategy}`

**Wave 1 (parallel) — research:**

```
Agent 1: Scrape target website
  - FIRST: Load skills: "defuddle", "seo-technical"
  - URL provided by user
  - Extract: products, pricing, site structure, existing SEO elements
    (title tags, meta descriptions, headings, schema, internal links)
  - Save to klien/<slug>/seo/research/website-analysis.md

Agent 2: Competitor SEO analysis
  - FIRST: Load skills: "defuddle", "seo-content", "seo-technical"
  - Identify top 3-5 competitors ranking for target keywords
  - Analyze their: title tags, content structure, keyword targeting,
    backlink signals, content gaps
  - Save per-competitor to klien/<slug>/seo/research/competitors/*.md

Agent 3: Keyword research
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary + secondary + long-tail keywords
  - SERP analysis, search volume estimates, difficulty, intent
  - Keyword gap analysis (what competitors rank for that we don't)
  - Save to klien/<slug>/seo/research/keywords/keyword-strategy.md

Agent 4: Discourse / question research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic (Reddit, Google, forums)
  - Question-based keywords for FAQ content
  - Save to klien/<slug>/seo/research/discourse/questions.md

Agent 5: Extract brand + design tokens from the live site
  - FIRST: Load skills: "diagram-design", "blog-brand"
  - Follow diagram-design/references/onboarding.md § URL: fetch 2-3 pages,
    map detected colours to semantic roles, trace every font to its source
  - Produce the brand fidelity receipt (Step 4)
  - Save to klien/<slug>/seo/research/brand-extraction.md
```

**Wave 2 (5 parallel) — SEO audit:**

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

**Wave 3 (parallel) — reports + strategy:**

```
Agent 1: Combined audit report (HTML + MD) + overview update
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all 5 audit results from Wave 2
  - Output:
    - klien/<slug>/seo/reports/audit.html (interactive HTML, bright theme + sidebar + top nav bar)
    - klien/<slug>/seo/reports/audit.md
    - klien/<slug>/overview.html (overwrite — merge new audit scores into existing overview + top nav bar)
    - klien/<slug>/overview.md (overwrite)
  - See "Report Requirements" below — all HTML reports must include cross-navigation top bar

Agent 2: SEO planning diagrams
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: keyword + competitor data from Wave 1
  - Output:
    - klien/<slug>/seo/diagrams/keyword-gap.html
    - klien/<slug>/seo/diagrams/content-cluster.html
    - klien/<slug>/seo/diagrams/build-priority.html

Agent 3: Content plan
  - FIRST: Load skills: "blog-strategy", "blog-cluster", "seo-cluster"
  - Input: keyword strategy, discourse questions, competitor gaps
  - Output: klien/<slug>/blog/content-plan.md

Agent 4: Ads strategy report + diagrams
  - FIRST: Load skills: "ads", "ads-audit", "ads-plan", "ads-budget", "ads-competitor", "diagram-design", "dataviz"
  - Input: all Wave 1 research
  - Output:
    - klien/<slug>/ads/ads-strategy.html (interactive HTML, bright theme + sidebar)
    - klien/<slug>/ads/ads-strategy.md
    - klien/<slug>/ads/diagrams/platform-fit.html
    - klien/<slug>/ads/diagrams/budget-split.html
    - klien/<slug>/ads/diagrams/campaign-flow.html
```

**Wave 4 (single agent) — config:**

```
Agent 1: Config files + vault hub
  - .seo-project.md at the client root (client info, keywords, competitors)
  - klien/<slug>/.seo-state.json (pipeline tracker)
  - klien/<slug>/00-index.md — the vault hub, linking everything with [[wiki-links]]
```

### Branch B — no website yet

**With build bundle.** Nothing to scrape; research first, confirm second,
then produce the handoff bundle.

**First:** `mkdir -p klien/<slug>/{build,build/06-content,blog,blog/articles,seo,seo/research,seo/reports,seo/diagrams,ads,ads/diagrams,notes,products,strategy}`

**Wave 1 (parallel) — research:**

```
Agent 1: Market + competitor discovery
  - FIRST: Load skills: "defuddle", "seo-content"
  - From the business name/industry given, find 3-5 real competitors and what
    their sites do well and badly
  - Save to klien/<slug>/seo/research/competitors/*.md + competitive-overview.md

Agent 2: Search demand + keywords
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - What this audience actually searches, grouped by intent
  - Save to klien/<slug>/seo/research/keywords/keyword-strategy.md

Agent 3: Discourse / real questions
  - FIRST: Load skill: "blog-discourse"
  - Questions people ask about this category, in their own words
  - Save to klien/<slug>/seo/research/discourse/questions.md

Agent 4: Visual + structural references
  - FIRST: Load skills: "defuddle", "diagram-design"
  - How good sites in this industry are laid out and styled; note the page
    patterns buyers expect
  - Save to klien/<slug>/seo/research/industry-references.md
```

**Wave 2 — draft, then confirm (single agent, then STOP):**

```
Agent 5: Draft the discovery proposal
  - FIRST: Load skills: "blog-brand", "seo-plan", "seo-content-brief"
  - Input: all Wave 1 research
  - Draft, as a short reviewable proposal:
    - Positioning and differentiator (what makes this client different)
    - Target audience — who, where, what they care about
    - Offer — what is actually being sold, at what price band
    - Page map — which pages the site needs, and why each earns its place
    - Brand direction — tone, personality, visual character
    - Candidate design tokens — proposed palette and type pairing
  - Save to klien/<slug>/seo/research/discovery-draft.md

  THEN PRESENT IT AND STOP. Ask the user to correct it:
    "Dari riset, saya usul X — betul, atau perlu dikoreksi?"
  - Never write the bundle on an unconfirmed draft
```

The confirmed draft becomes the input to Wave 3 below.

**Wave 3 (parallel) — the handoff bundle. THIS IS THE DELIVERABLE.**

Write all 10 documents. Nothing else in this skill matters as much.

```
Agent 6: Brief + brand
  - FIRST: Load skills: "seo-plan", "blog-brand", "blog-persona"
  - 01-brief.md — business, goals, audience, offer, differentiators,
    what success looks like
  - 02-brand.md — voice on blog-persona's four axes, do/don't lists,
    voice samples, taboo phrases
  - Brand ALWAYS at klien/<slug>/build/02-brand.md — never BRAND.md, never
    the project root (blog-brand's default is wrong for this skill)
  - Derive from the confirmed discovery-draft.md

Agent 7: Design tokens + sitemap
  - FIRST: Load skills: "high-end-visual-design", "design-taste-frontend",
    "frontend-design", "diagram-design", "seo-plan", "seo-sitemap"
  - 03-design-tokens.md — write it in this order:
      1. Visual direction — one paragraph: the intended feel, and the single
         idea the design is built around. Derive it from 01-brief's audience,
         never from your own taste.
      2. Layout archetype per page — for each page in 04-sitemap, which
         structural pattern it uses. Vary them; the homepage and the services
         page must not share one skeleton.
      3. The tokens — semantic roles (paper, paper-2, ink, muted, rule,
         accent, link) in light + dark, the type ramp, the 4px spacing grid,
         radii, breakpoints, elevation. Carry over the brand fidelity receipt
         from onboarding.md Step 4 so the client can see what was sampled.
    - Distil the anti-slop constraints from the three design skills into the
      tokens section: banned fonts, banned layouts, banned borders/shadows,
      banned motion, and the whitespace floor.
    - Constraints: WCAG AA ink-on-paper, exactly one accent, paper is never
      pure white.
  - 04-sitemap.md — page list, URL hierarchy, navigation, and for each page
    its purpose, primary CTA, and target keyword. Start from the matching
    tree in seo-plan/assets/<industry>.md.

Agent 8: Layout
  - FIRST: Load skills: "high-end-visual-design", "design-taste-frontend",
    "diagram-design"
  - 05-layout.md — one section per page, and for each page a table of its
    sections in render order:
      | # | Section | Visual weight | Text budget | Media |
    - Visual weight: full-screen / half / thin strip. Exactly one section per
      page carries it — the hero on a homepage, the service list on a services
      page. Everything else is subordinate to that one.
    - Text budget: a word CAP per section, not a target. A hero gets roughly
      8-12 words for its headline and one CTA. A card gets a title plus one
      line. If a section cannot be said in its budget, the section is wrong,
      not the budget.
    - Media: image, diagram, or none, and how much room it takes.
    - Note where the page breathes: which gaps are deliberately large.
  - Then a short typographic hierarchy per page: what is H1, what is body,
    what is a caption, and the relative scale between them.
  - THIS DOCUMENT OWNS SECTION ORDER AND TEXT LENGTH. Agent 9 must fit inside
    it. Derive the sections from 04-sitemap's page list and 03-design-tokens'
    archetypes, but the budget is yours to set — and you must set one.
  - The failure this prevents: a page where every section carries equal weight
    and full SEO paragraphs, which reads as a wall of text no matter how good
    the copy is.

Agent 9: Page copy
  - FIRST: Load skills: "seo-content-brief"
  - 06-content/<page-slug>.md — one file per page from 04-sitemap.md
  - Follow the 9 page types in
    seo-content-brief/references/page-type-templates.md
  - OBEY 05-layout.md's text budget for every section. This is a hard cap.
    The page-type templates specify SEO-dense formats (40-60 word snippet
    answers, definition boxes); those belong in the SEO layer, not in a
    section whose budget is two lines
  - Split each page file in two:
      ## Tampilan   — exactly the text that renders, within budget
      ## SEO layer  — meta description, schema, the long-form answers that
                      index but never appear on the page
    A builder renders Tampilan and uses SEO layer for head tags and markup
  - Contact is NOT among them — write it from the Homepage CTA pattern:
    form, NAP block, map, operating hours
  - Respect the Website Relevance Rule: every claim must be something this
    client can credibly say about its actual offer

Agent 10: Tech spec + SEO foundation
  - FIRST: Load skills: "seo-technical", "seo-schema", "seo-cluster", "seo-page"
  - 07-tech-spec.md — stack, rendering strategy per page type (SSR for
    dynamic/SEO pages, SSG for static, CSR for authenticated only), hosting,
    CMS, component inventory, forms, analytics, integrations. State the stack
    explicitly: the scaffold step reads this file to decide what to generate.
  - 08-seo-foundation.md — keyword map, per-page meta (title + description),
    schema per page type, internal linking plan, CWV targets

Agent 11: Master prompt
  - FIRST: Load skills: "diagram-design"
  - 00-handoff.md — the master prompt: reading order of the other 7 documents,
    what to build, what is fixed vs open for the builder to decide, and
    acceptance checks. Must stand alone in a fresh session with no other
    context.
```

**Wave 4 (parallel) — side outputs: overview, ads plan, research reports.**

These are NOT part of the handoff bundle. The overview is a client presentation;
the rest is post-launch marketing collateral. None of it goes into
`09-build-prompt.md`, and none of it goes into 01–08.

```
Agent 12: Generate client overview report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz", "blog-analyze"
  - Input: all Wave 1 research
  - Output:
    - klien/<slug>/overview.html (interactive HTML report, dark theme, charts)
    - klien/<slug>/overview.md (markdown version for quick reference)
  - See "Report Requirements" below

Agent 13: Generate SEO planning diagrams
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: keyword + competitor data
  - Output:
    - klien/<slug>/seo/diagrams/keyword-gap.html (bar chart: our keywords vs competitors)
    - klien/<slug>/seo/diagrams/content-cluster.html (hub-and-spoke content map)
    - klien/<slug>/seo/diagrams/build-priority.html (action items by impact/effort)

Agent 14: Content plan (research output, NOT part of the bundle)
  - FIRST: Load skills: "blog-strategy", "blog-cluster", "seo-cluster"
  - Input: keyword strategy, discourse questions, competitor gaps
  - Output: klien/<slug>/blog/content-plan.md
  - Contents: the article list with publish order, target keyword and intent
    per article, content type, and which page each links back to. Cluster the
    articles hub-and-spoke so the internal linking in 07 has somewhere to land.
  - This stays under `blog/` and out of 09-build-prompt.md: a content
    calendar describes what to publish after launch, not what to build now.
    Articles are written later with `/freelance blog-write`.

Agent 15: Ads strategy report + diagrams
  - FIRST: Load skills: "ads", "ads-audit", "ads-plan", "ads-budget", "ads-competitor", "diagram-design", "dataviz"
  - Input: all Wave 1 research (website analysis, competitor data, keywords)
  - Analyze: which ad platforms fit this business, budget allocation, campaign structure, competitor ad strategy
  - Output:
    - klien/<slug>/ads/ads-strategy.html (interactive HTML report, bright theme with sidebar)
    - klien/<slug>/ads/ads-strategy.md (markdown version for quick reference)
    - klien/<slug>/ads/diagrams/platform-fit.html (radar chart: platform suitability scores)
    - klien/<slug>/ads/diagrams/budget-split.html (pie/donut chart: budget allocation per platform)
    - klien/<slug>/ads/diagrams/campaign-flow.html (flowchart: campaign structure & funnel)
  - Sections: recommended platforms, budget split, campaign types, competitor ad gaps, creative brief, measurement plan
  - Design: same bright theme + sidebar as overview.html
```

**Wave 5 (single agent):**

```
Agent 16: Config files + vault hub
  - .freelance-project.md at the client root (client info, keywords, competitors)
  - klien/<slug>/.freelance-state.json (pipeline tracker)
  - klien/<slug>/00-index.md — the vault hub, and the ONLY index in the vault.
    It links out to everything with [[wiki-links]], grouped by the same
    function folders the files live in:
      Build      → [[01-brief]] [[02-brand]] [[03-design-tokens]] [[04-sitemap]]
                   the pages in [[06-content]] [[07-tech-spec]]
                   [[08-seo-foundation]] [[09-build-prompt]]
      Blog       → [[content-plan]] and each article
      SEO        → [[keyword-strategy]], the audit reports, the diagrams
      Ads        → [[ads-strategy]], the ads diagrams
      Notes      → the research notes, products, and strategy docs
  - Every other note links back to [[00-index]], and sideways to its siblings.
    The client folder is already the vault root — do NOT create a nested
    index, a separate obsidian-vault/ folder, or per-folder index files.
```

**Wave 6 (single agent) — the paste file:**

```
Agent 17: Assemble 09-build-prompt.md
  - Runs LAST, after every other document is final
  - Read the finished 01-brief.md … 08-seo-foundation.md and every
    06-content/*.md file, and concatenate them verbatim
  - DO NOT regenerate any content — assembly only, or the copies drift
  - IN SCOPE: 01–08 plus 06-content/. NOTHING ELSE.
  - OUT OF SCOPE: the ads plan, research reports, and diagrams. Do not include
    them — they are post-launch marketing collateral, and folding them in
    would bury the build spec
  - MUST ALSO CARRY the anti-slop rules inline, as a section near the front,
    before the inlined documents. This is the one thing 09 adds rather than
    copies: a builder receiving only this paste has no access to the vendored
    design skills, and without these rules it will produce a centred hero over
    three feature cards. Include the banned lists (fonts, layouts, borders and
    shadows, motion), the whitespace floor, and the pre-output checklist the
    builder should tick before delivering
  - Structure:
      1. Opening instruction: what this is, what to build, and the two rules a
         builder must not get wrong — **05-layout governs section order,
         visual weight and text length**; and a section's budget is a cap, so
         do not pour the full copy into it. The sitemap defines the page list,
         the tech spec defines the stack
      2. `---` separator, then `# 01 — BRIEF` followed by the full text of
         01-brief.md
      3. Repeat for 02 through 08, so 05-layout lands in sequence and reads as
         binding rather than optional
      4. Then one section per page from 06-content/, headed with its URL, and
         carrying BOTH of that file's parts — Tampilan (what renders) and SEO
         layer. State plainly which one the builder renders
  - The result must be understandable with zero access to the folder — no
    "see 04-sitemap.md" cross-references, no relative links
```

**Init is NOT complete until Wave 6 finishes.**

### Scaffold (Branch B only, optional, after the bundle)

Once `07-tech-spec.md` exists, offer to scaffold the starter project at
`klien/<slug>/site/`. **Read the stack from the tech spec** — do not assume
Next.js.

| `07-tech-spec.md` says | Generate |
|---|---|
| `next` / `nextjs` | `app/` route dir, `layout.tsx`, `globals.css`, `tailwind.config.ts` |
| `astro` | `src/pages/`, `src/layouts/`, `src/styles/`, `astro.config.mjs` |
| `static` / `html` | `index.html` + one file per page from 04-sitemap.md, `assets/` |
| anything else | Ask the user rather than guessing |

In every case: write `03-design-tokens.md`'s values out as CSS custom
properties in the token stylesheet, and create one placeholder file per page
listed in `04-sitemap.md`. Scaffolding is structure only — the builder AI fills
in the content from `06-content/`.

### Report Requirements (Branch A primary output, Branch B side output)

`klien/<slug>/overview.html` — single self-contained HTML, **bright theme with sidebar navigation**, charts as inline SVG/CSS.

#### Cross-Navigation (MANDATORY)

All HTML reports must link to each other via a **shared cross-navigation component**.
This is a single `<nav>` element that is included in every HTML file, providing
consistent navigation across all reports.

**Component: `cross-nav.html`**

Create a reusable HTML snippet at `klien/<slug>/components/cross-nav.html` that
all reports include. This ensures:
- Consistent styling across all reports
- Easy maintenance (update once, applies everywhere)
- Automatic link generation based on which files exist

**Top bar layout:**

```
┌──────────────────────────────────────────────────────────────────────┐
│  🏠 Overview  │  📊 Audit  │  📈 Keywords  │  💰 Ads  │  🕸️ Cluster │
└──────────────────────────────────────────────────────────────────────┘
```

**Implementation:**

Each HTML report includes the cross-nav component:
```html
<!-- Cross-navigation bar (shared component) -->
<nav class="cross-nav" data-cross-nav>
  <a href="../overview.html" class="nav-item">🏠 Overview</a>
  <a href="audit.html" class="nav-item active">📊 Audit</a>
  <a href="../seo/diagrams/keyword-gap.html" class="nav-item">📈 Keywords</a>
  <!-- Only include links to files that exist -->
</nav>
```

**Rules:**
- Top bar is a horizontal `<nav>` element, fixed below the page header
- Each report links only to files that **exist** in `klien/<slug>/`
- The current report is highlighted (not a link), uses accent color
- Links use **relative paths** (e.g., `../overview.html`, `seo/reports/audit.html`)
- If a report doesn't exist yet, omit it from the bar
- Branch A (existing site) omits `build/` references; Branch B includes them
- The sidebar remains untouched — it only has internal section links
- **All reports share the same cross-nav component** — update once, applies everywhere

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
│   SIDEBAR    │  📁 Cross-Nav (shared)         │
│              │  Overview │ Audit │ Ads │ ...   │
│ 🏠 Summary   ├────────────────────────────────┤
│ 📊 Scores    │                                │
│ 🔧 Technical │  [Hero Section]                │
│ 📝 On-page   │  [Score Cards]                 │
│ 🏷️ Schema    │  [Category Details]            │
│ 🤖 GEO       │                                │
│ 📖 Content   │                                │
│ ✅ Actions   │                                │
└──────────────┴────────────────────────────────┘
```

**Cross-nav component location:**
```
klien/<slug>/
├── components/
│   └── cross-nav.html        ← shared navigation snippet
├── overview.html              ← includes cross-nav
├── seo/reports/audit.html     ← includes cross-nav
├── seo/diagrams/*.html        ← includes cross-nav
└── ads/ads-strategy.html      ← includes cross-nav
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
klien/<slug>/
├── overview.html              # client overview report (HERO OUTPUT)
├── .freelance-project.md                # Site config, keywords, competitors
├── .freelance-state.json                # Pipeline tracker
├── diagrams/
│   ├── keyword-gap.html           # Keyword gap vs competitors
│   ├── content-cluster.html       # Hub-and-spoke content map
│   └── build-priority.html          # Action items by impact/effort
├── ads/
│   ├── ads-strategy.html          # Ads strategy report (platforms, budget, campaigns)
│   ├── ads-strategy.md            # Ads strategy markdown
│   └── diagrams/
│       ├── platform-fit.html      # Radar chart: platform suitability
│       ├── budget-split.html      # Donut chart: budget allocation
│       └── campaign-flow.html     # Flowchart: campaign structure & funnel
├── research/
│   ├── website-analysis.md        # Scraped site + SEO elements
│   ├── competitors/*.md           # Per-competitor SEO analysis
│   ├── keywords/keyword-strategy.md
│   └── discourse/questions.md     # Question-based content ideas
├── content/                       # Generated blog posts
└── reports/                       # Audit reports
```

---

## `/freelance blog-write <topic>`

Full SEO content pipeline. From keyword research to published post.

**Precondition:** `klien/<slug>/` must exist with `.freelance-project.md`. If missing:
> "Jalankan `/freelance init` dulu."

**First:** `mkdir -p klien/<slug>/blog/articles`

**Wave 1 (parallel):**

```
Agent 1: Keyword research for this topic
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary keyword, secondary keywords, long-tail variations
  - SERP analysis: who ranks, what content type, gaps
  - Save to klien/<slug>/seo/research/keywords/<topic-slug>-keywords.md

Agent 2: Discourse research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic
  - Save to klien/<slug>/seo/research/discourse/<topic-slug>-questions.md
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
  - Input: brief + outline + klien/<slug>/build/02-brand.md
  - Output: klien/<slug>/build/06-content/<page-slug>.md
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
  - Save to klien/<slug>/blog/articles/<topic-slug>.md
  - Update klien/<slug>/.freelance-state.json
```

---

## `/freelance audit <url>`

Full SEO audit. All 5 audits run in parallel.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

**First:** `mkdir -p klien/<slug>/seo/reports`

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
Agent 6: Combined audit report (HTML + MD) + overview update
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all 5 audit results
  - Output:
    - klien/<slug>/seo/reports/audit.html (interactive HTML report, BRIGHT theme with sidebar + top nav bar)
    - klien/<slug>/seo/reports/audit.md (markdown version for quick reference)
    - klien/<slug>/overview.html (overwrite — merge new audit scores into existing overview + top nav bar)
    - klien/<slug>/overview.md (overwrite)
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

## `/freelance reaudit <url>`

**Full re-audit: overwrite.** Re-runs the complete audit and overwrites all audit
files with fresh data. Single canonical path — no timestamps, no duplicates.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

### Phase 1: AUDIT — Fresh 5-agent parallel audit

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

### Phase 2: REPORT — Combined report + overview update

```
Agent 6: Combined audit report (HTML + MD) + overview update
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all 5 audit results from Phase 1
  - Output:
    - klien/<slug>/seo/reports/audit.html (overwrite — BRIGHT theme with sidebar navigation + top nav bar)
    - klien/<slug>/seo/reports/audit.md (overwrite)
    - klien/<slug>/overview.html (overwrite — merge new audit scores into existing overview + top nav bar)
    - klien/<slug>/overview.md (overwrite)
  - Include: health scores, pass/fail checklist, priority actions, per-category breakdowns
  - See "Report Requirements" above for full design spec (sidebar, bright theme, collapsible sections, cross-navigation top bar)
```

### Overwritten files

```
klien/$SLUG/
├── seo/reports/
│   ├── audit.html                          ← OVERWRITTEN
│   ├── audit.md                            ← OVERWRITTEN
│   ├── technical-audit.md                  ← OVERWRITTEN
│   ├── onpage-audit.md                     ← OVERWRITTEN
│   ├── schema-audit.md                     ← OVERWRITTEN
│   ├── geo-audit.md                        ← OVERWRITTEN
│   └── content-quality-audit.md            ← OVERWRITTEN
├── overview.html                           ← OVERWRITTEN
├── overview.md                             ← OVERWRITTEN
├── seo/diagrams/
│   ├── keyword-gap.html                    ← OVERWRITTEN
│   ├── content-cluster.html                ← OVERWRITTEN
│   └── build-priority.html                 ← OVERWRITTEN
└── ads/                                    ← NOT TOUCHED (use /freelance ads for that)
```

### Summary output

```
🔄 Re-audit complete for <slug>

📁 Overwritten:
  📊 seo/reports/audit.html
  📄 seo/reports/audit.md
  🔧 seo/reports/technical-audit.md
  📝 seo/reports/onpage-audit.md
  🏷️  seo/reports/schema-audit.md
  🤖 seo/reports/geo-audit.md
  📖 seo/reports/content-quality-audit.md
  🏠 overview.html + overview.md

Health Score: XX/100
Critical: X | High: X | Medium: X | Low: X
```

---

## `/freelance ads <url>`

Full ads strategy audit. Analyzes ad platform fit, budget allocation, campaign structure, and competitor ad gaps.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

**First:** `mkdir -p klien/<slug>/ads/diagrams`

**Wave 1 (parallel):**

```
Agent 1: Ads platform audit
  - FIRST: Load skills: "ads", "ads-audit", "ads-google", "ads-meta"
  - Analyze: which ad platforms fit this business (Google Ads, Meta, TikTok, LinkedIn, etc.)
  - Check: existing ad accounts, tracking setup, conversion pixels
  - Save to klien/<slug>/ads/platform-audit.md

Agent 2: Competitor ads analysis
  - FIRST: Load skills: "ads", "ads-competitor", "ads-research"
  - Analyze: competitor ad presence across platforms
  - Find: competitor ad copy, creative angles, bidding strategies
  - Save to klien/<slug>/ads/competitor-ads.md

Agent 3: Budget & campaign planning
  - FIRST: Load skills: "ads", "ads-plan", "ads-budget", "ads-math"
  - Input: keyword data + competitor analysis + business goals
  - Output: recommended budget split, campaign structure, bidding strategy
  - Save to klien/<slug>/ads/budget-plan.md
```

**Wave 2 (single agent):**

```
Agent 4: Combined ads strategy report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: all Wave 1 ads research
  - Output:
    - klien/<slug>/ads/ads-strategy.html (interactive HTML report, bright theme with sidebar)
    - klien/<slug>/ads/ads-strategy.md (markdown version)
  - Sections: platform recommendations, budget allocation (pie chart), campaign structure,
    competitor ad gaps, creative brief, measurement plan, ROI projections
  - Design: same bright theme + sidebar as overview.html
```

### Output files

```
klien/<slug>/ads/
├── ads-strategy.html          # Ads strategy report (HERO OUTPUT)
├── ads-strategy.md            # Ads strategy markdown
├── platform-audit.md          # Platform analysis
├── competitor-ads.md          # Competitor ad analysis
└── budget-plan.md             # Budget & campaign plan
```

---

## `/freelance project-fix <slug>`

Trace the actual project directory, compare against the bundle documents,
and fix issues in the project files. This is NOT about fixing the bundle
documents — it's about fixing the **project itself** (the website code,
content files, config, etc.) based on what the bundle specifies.

**Precondition:** `klien/<slug>/` must exist with bundle documents.
The project directory must also exist (e.g., `keripik-mang-dedi/`).

### How it works

1. **Read the audit report** (PRIMARY) — this is what's wrong:
   - `seo/reports/audit.html` or `audit.md` → all issues by priority
   - Critical and High priority = MUST fix
   - Medium = SHOULD fix
   - Low = NICE to fix

2. **Read the bundle docs** (REFERENCE) — this is what it should be:
   - `04-sitemap.md` → which pages should exist
   - `06-content/*.md` → what content each page should have
   - `07-tech-spec.md` → what stack, components, config
   - `08-seo-foundation.md` → meta tags, schema, internal links

3. **Scan the project** — map audit issues to actual files:
   - Find which project files correspond to each audit issue
   - Check if the fix is possible (code change vs needs rewrite)

4. **Fix project files** — spawn parallel agents to fix each issue

### What can be fixed by project-fix

| Bundle Says | Project Check | Fix |
|-------------|---------------|-----|
| `04-sitemap.md` lists `/produk` | Page doesn't exist | Create page from `06-content/produk.md` |
| `06-content/homepage.md` has hero text | Homepage has different text | Update homepage content |
| `08-seo-foundation.md` says title = "..." | Actual `<title>` is different | Fix the title tag |
| `08-seo-foundation.md` says schema = FAQPage | No schema or wrong type | Add/correct JSON-LD |
| `07-tech-spec.md` says Next.js | Project uses different stack | Flag (needs manual decision) |
| `08-seo-foundation.md` says internal links to X | Links are missing or broken | Fix the links |

### What CANNOT be fixed (report only)

| Issue | Why |
|-------|-----|
| Stack mismatch | Needs rewrite, not fix |
| Missing pages with no content | Needs content creation |
| Design/token mismatches | Needs visual review |
| Performance issues | Needs optimization, not fix |

### Execution — parallel fix agents

**Phase 1: Read audit + bundle + scan project**

The audit report is the PRIMARY input — it tells us what's wrong.
The bundle docs tell us what the project SHOULD look like.

```
Agent 1: Read audit report (PRIMARY INPUT)
  - Read klien/<slug>/seo/reports/audit.html or audit.md
  - Extract all issues by priority: Critical → High → Medium → Low
  - Each issue has: what's wrong, where, how to fix
  - This is the FIX LIST — the starting point for Phase 2

Agent 2: Read bundle documents (REFERENCE)
  - Read klien/<slug>/build/04-sitemap.md → page list
  - Read klien/<slug>/build/06-content/*.md → content per page
  - Read klien/<slug>/build/07-tech-spec.md → stack + config
  - Read klien/<slug>/build/08-seo-foundation.md → SEO requirements
  - Cross-reference with audit findings for context

Agent 3: Scan project directory
  - Find the project root (from .freelance-project.md or user input)
  - Scan for all pages, components, config files
  - Map audit issues to actual project files
  - List: which file needs which fix
```

**Phase 2: Fix project code (parallel)**

For EVERY issue found, spawn a dedicated agent to fix the actual code.
Each agent reads the project file, understands the codebase context,
and applies the fix using Edit/Write tools.

```
For EACH discrepancy found, spawn a parallel agent:
  - Receives: project file path + what's wrong + what it should be
  - Reads the full project file to understand codebase context
  - Applies the fix to the actual code (Edit tool, Write tool)
  - Example fixes:
    - Missing page → create component/page file from 06-content/
    - Wrong <title> → edit the actual HTML/JSX/meta tag
    - Missing schema → add JSON-LD script to the page
    - Broken internal links → fix href/src in the code
    - Wrong meta description → update the meta tag
  - Returns: file path + what was changed

Example: if homepage has wrong title, missing FAQ schema, and /kontak page
doesn't exist → spawn 3 agents, each fixing the actual project code
```

**Phase 3: Update bundle documents (mark as done)**

After project fixes are applied, update the bundle documents to mark
which issues have been resolved. This keeps the bundle in sync with the
actual project state — a checklist that reflects reality.

```
For EACH fix applied in Phase 2, update the corresponding bundle doc:
  - 04-sitemap.md → mark pages as ✅ created/fixed
  - 06-content/*.md → mark content as ✅ applied to project
  - 07-tech-spec.md → mark config as ✅ implemented
  - 08-seo-foundation.md → mark meta/schema/links as ✅ applied

Format in bundle docs:
  ## Homepage
  - [x] Title tag: "Keripik Mang Dedi — Original" ✅ applied
  - [x] FAQPage schema: added ✅ applied
  - [ ] Internal links to /produk: needs review
```

**Phase 4: Regenerate outputs (overwrite HTML + MD)**

After bundle docs are updated, regenerate the audit and overview to
reflect the corrected project state.

```
Agent: Regenerate audit report
  - Overwrite klien/<slug>/seo/reports/audit.html + .md
  - Overwrite klien/<slug>/overview.html + .md
```

### Summary output

```
🔧 Project-fix complete for <slug>

✅ Fixed (X issues):
  📄 homepage.html — updated <title> to match 08-seo-foundation.md
  📄 homepage.html — added FAQPage JSON-LD schema
  📄 /produk/index.html — created from 06-content/produk.md
  📄 /kontak/index.html — created from 06-content/kontak.md

📋 Bundle docs updated:
  ✅ 08-seo-foundation.md — marked 2 meta tags as applied
  ✅ 04-sitemap.md — marked /produk and /kontak as created
  ✅ 06-content/homepage.md — marked hero text as applied

📁 Regenerated outputs:
  📊 seo/reports/audit.html (overwritten)
  🏠 overview.html (overwritten)

⚠️  Needs manual fix (Y issues):
  📄 Stack mismatch — bundle says Next.js, project uses Astro
  📄 /blog page exists but no content in 06-content/
```

---

## `/freelance status`

**Precondition:** `.freelance-state.json` (or legacy `.seo-state.json`) must exist. If missing:
> "Jalankan `/freelance init` dulu."

**Load skills:** `blog-analyze` (for content scoring if content exists)

Read the state file + scan `research/`, `06-content/`, and the bundle documents. Report: done, in progress, pending.

---

## Example

```bash
# Branch A — client already has a site (no build bundle)
/freelance init https://mysite.com
# → Wave 1: scrape + competitors + keywords + questions + brand extraction
# → Wave 2: 5 audit agents (technical, on-page, schema, GEO, content)
# → Wave 3: audit report + diagrams + content plan + ads strategy
# → Wave 4: config files + vault hub
# → Done! Open klien/mysite.com/seo/reports/ for audit, or ads/ for ads strategy

# Branch B — no site yet, just a business name (with build bundle)
/freelance init "Warung Kopi Kenangan"
# → Wave 1: market + demand + discourse + industry references
# → Wave 2: drafts a proposal and STOPS for your correction
# → Wave 3: the 10-document bundle, built from the confirmed draft
# → Wave 4: overview report + diagrams + content plan + ads strategy
# → Wave 5: config files + vault hub
# → Wave 6: assemble 09-build-prompt.md

/freelance blog-write "Resep Keripik Singkong Original"
# → Keyword research → brief → write → SEO check → schema → publish

/freelance audit https://mysite.com
# → 5 audits parallel → combined report

/freelance project-fix keripikmangdedi.id
# → trace project files vs bundle docs → fix discrepancies → report manual fixes

/freelance status
```
