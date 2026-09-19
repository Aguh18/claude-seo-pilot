---
name: freelance
description: >
  Client web-build orchestrator for freelancers. Turns a client — an existing
  site or just a business name — into a handoff bundle of 9 documents (brief,
  brand, design tokens, sitemap, page copy, tech spec, SEO foundation, master
  prompt, and a copy-paste build prompt) that any AI can read to build the
  website. Also runs SEO audits, blog pipelines, and ads strategy on the
  result. Use when user says "freelance", "client", "init project", "build a
  website for", "web untuk klien", "company profile", "handoff", "build prompt",
  "seo audit", "blog-write", or "reaudit".
user-invocable: true
argument-hint: "[init|blog-write|audit|reaudit|ads|status] [name-or-url]"
license: MIT
metadata:
  author: Aguh18
  version: "2.0.0"
  category: freelance
---

# Freelance

Client web-build orchestrator. Take a client from discovery to a documented build spec.
6 commands, parallel subagents.

## Commands

| Command | What It Does |
|---------|--------------|
| `/freelance init <name-or-url>` | Discovery → **9-document handoff bundle** for the build, plus overview.html, ads plan, and content plan as side outputs |
| `/freelance blog-write <topic>` | Full pipeline → keyword research → brief → write → SEO optimize → publish |
| `/freelance audit <url>` | Full SEO audit → technical + on-page + schema + GEO + report |
| `/freelance reaudit <url>` | Clean old audit files → re-run full audit with fresh timestamped output |
| `/freelance ads <url>` | Ads audit → platform analysis → budget plan → campaign structure → report |
| `/freelance status` | Show what's done and what's next |

---

## Two Ways In

`init` accepts either an existing site or just a business name. Both branches
converge on the same 9-document bundle.

**Branch A — the client already has a website** (`/freelance init https://...`):
scrape it, research the market, then *translate* that material into the bundle.
Existing design tokens, page structure, and audit findings feed documents 03, 04, and 07.

**Branch B — no website yet** (`/freelance init "Warung Kopi Kenangan"`):
there is nothing to scrape, so research first and confirm second.

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

Nine markdown documents plus one presentation page. This is the deliverable —
everything else is input to it.

| # | Document | Contents | Built from |
|---|----------|----------|------------|
| 00 | `00-handoff.md` | Master prompt: read these in order, build the site | **new** |
| 01 | `01-brief.md` | Business, goals, audience, offer, differentiators | `seo-plan` Step 1 |
| 02 | `02-brand.md` | Voice, tone, personality | `blog-brand`, `blog-persona` |
| 03 | `03-design-tokens.md` | **Visual direction** + colour, typography, spacing, radii | `high-end-visual-design`, `design-taste-frontend`, `diagram-design` |
| 04 | `04-sitemap.md` | Pages, hierarchy, navigation, CTA per page | `seo-plan` Step 3, `seo-sitemap` |
| 05 | `05-content/*.md` | Copy for each page | `seo-content-brief` page types |
| 06 | `06-tech-spec.md` | Stack, hosting, CMS, components, integrations | **new** |
| 07 | `07-seo-foundation.md` | Keywords, meta, schema, internal linking | `seo-cluster`, `seo-schema`, `seo-page` |
| 08 | `08-build-prompt.md` | Self-contained paste — all of the above inline | **new** |

Plus `overview.html` — bright theme with sidebar, same design as the audit
reports, for presenting the plan to a non-technical client.

### Two handoff formats, two consumers

`00-handoff.md` and `08-build-prompt.md` solve different problems:

- **`00-handoff.md`** is a *pointer*. It tells a builder that can read the folder
  to open the other documents in a set order. Short, and the single source of
  truth stays in documents 01–07.
- **`08-build-prompt.md`** is a *paste*. It inlines the full text of 01–07 and
  every `05-content/` page, so the whole spec survives one Ctrl-A → Ctrl-C into
  an AI that cannot see the filesystem.

**Boundary: 08 carries the website spec only.** The ads plan (Wave 5) and the
research reports are marketing collateral for *after* launch — they say how to
promote the site, not how to build it. They stay out, under `ads/` and `research/`.

Generate 08 **last**, after 01–07 are final. It is mechanical assembly — build
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
2. **Brand always lives at `klien/<slug>/02-brand.md`**, never `BRAND.md` and
   never at the project root. `blog-brand` defaults to project root; override it.
3. **`seo-content-brief` covers 9 page types but not Contact.** Write Contact
   pages from the Homepage CTA pattern: form, NAP block, map, operating hours.
4. **The bundle must decide how the site looks, not only what it says.** A
   bundle with good copy and a colour palette but no visual direction produces
   a page that ranks and looks templated — centred hero, three feature cards,
   stock footer. `03-design-tokens.md` therefore carries visual direction, and
   `08-build-prompt.md` carries the anti-slop rules. See below.

### Linking — the bundle is a vault, not loose files

Everything under `klien/<slug>/` is one Obsidian vault, so documents link to
each other with **`[[wiki-links]]`** — not relative paths. Wikilinks resolve by
filename anywhere in the vault, which is why the whole set must share one root.

**Rule: every document 01–07 opens with a `related:` line and carries a
`**Related:**` line at the foot listing its wikilinks.** The convention matches
what the existing vault output already does — a hub note listing everything,
each note linking sideways to its siblings, and each note linking back to the
hub. Follow that shape.

| Document | Links to | Authority it holds |
|---|---|---|
| `00-handoff.md` | all of 01–08 — it is the entry point | reading order |
| `01-brief.md` | `[[02-brand]]` `[[04-sitemap]]` `[[07-seo-foundation]]` | business goals, audience, offer |
| `02-brand.md` | `[[01-brief]]` `[[03-design-tokens]]` `[[05-content]]` | voice and tone |
| `03-design-tokens.md` | `[[02-brand]]` `[[06-tech-spec]]` | **visual direction** + colour, type, spacing — final |
| `04-sitemap.md` | `[[01-brief]]` `[[05-content]]` `[[07-seo-foundation]]` | **the page list — final** |
| `05-content/*.md` | `[[02-brand]]` `[[04-sitemap]]` | the copy itself |
| `06-tech-spec.md` | `[[03-design-tokens]]` `[[04-sitemap]]` | stack and components — final |
| `07-seo-foundation.md` | `[[04-sitemap]]` `[[research/content-plan]]` | keywords, meta, schema |
| `00-index.md` (hub) | every bundle doc and every note | vault navigation |

**Authority matters more than the links.** Two documents can disagree —
`05-content` might invent a page that `04-sitemap` never listed, or
`06-tech-spec` might pick a colour that `03-design-tokens` already fixed. Each
row above names who wins, so a builder resolves a conflict by looking it up
rather than guessing. State the authority line explicitly in each document.

`08-build-prompt.md` is the exception: it must survive being pasted somewhere
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
(top level) and the research notes (in subfolders) can only link to each other if
they share one vault root. That shared root is `klien/<slug>/`.

Derive the slug, then create the tree:
```
if [ -n "$URL" ]; then
    SLUG=$(echo "$URL" | sed -E 's|^https?://||; s|^www\.||; s|/.*||' | tr '[:upper:]' '[:lower:]')
else
    SLUG=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed 's|[^a-z0-9]|-|g' | sed 's|--*|-|g' | sed 's|^-||;s|-$||')
fi
mkdir -p klien/$SLUG/{blog,seo,ads,notes,products,strategy}
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
| Bundle: page copy | `general-purpose` | `seo-content-brief` |
| Bundle: tech spec + SEO | `general-purpose` | `seo-technical`, `seo-schema`, `seo-cluster`, `seo-page` |
| Bundle: handoff (00 only, not 08) | `general-purpose` | `diagram-design` |
| Content plan (research output, not bundle) | `general-purpose` | `blog-strategy`, `blog-cluster`, `seo-cluster` |
| Bundle: 08-build-prompt assembly | `general-purpose` | none — verbatim concatenation only |
| Market discovery (no site yet) | `general-purpose` | `defuddle`, `seo-content`, `blog-discourse` |
| Discovery proposal draft | `general-purpose` | `blog-brand`, `seo-plan`, `seo-content-brief` |
| Ads platform audit | `general-purpose` | `ads`, `ads-audit`, `ads-google`, `ads-meta` |
| Competitor ads analysis | `general-purpose` | `ads`, `ads-competitor`, `ads-research` |
| Budget & campaign planning | `general-purpose` | `ads`, `ads-plan`, `ads-budget`, `ads-math` |
| Ads strategy report | `general-purpose` | `diagram-design`, `dataviz`, `ads-report` |
| Full audit (all) | multiple agents | Each agent loads its own skills per row above |
| blog-write pipeline | multiple agents | Each wave loads its own skills per row above |
| ads pipeline | multiple agents | Each wave loads its own skills per row above |

---

## `/freelance init`

Set up client project. Scrapes site, researches keywords + competitors, creates SEO strategy.

**First:** `mkdir -p klien/<slug>/{blog,seo,ads,notes,products,strategy}`

### Branch A — existing website

Scrape and research as before, then feed the findings into the bundle rather
than treating them as the deliverable.

**Wave 1 (parallel):**

```
Agent 1: Scrape target website
  - FIRST: Load skills: "defuddle", "seo-technical"
  - URL provided by user
  - Extract: products, pricing, site structure, existing SEO elements
    (title tags, meta descriptions, headings, schema, internal links)
  - Save to klien/<slug>/research/website-analysis.md

Agent 2: Competitor SEO analysis
  - FIRST: Load skills: "defuddle", "seo-content", "seo-technical"
  - Identify top 3-5 competitors ranking for target keywords
  - Analyze their: title tags, content structure, keyword targeting,
    backlink signals, content gaps
  - Save per-competitor to klien/<slug>/research/competitors/*.md

Agent 3: Keyword research
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary + secondary + long-tail keywords
  - SERP analysis, search volume estimates, difficulty, intent
  - Keyword gap analysis (what competitors rank for that we don't)
  - Save to klien/<slug>/research/keywords/keyword-strategy.md

Agent 4: Discourse / question research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic (Reddit, Google, forums)
  - Question-based keywords for FAQ content
  - Save to klien/<slug>/research/discourse/questions.md

Agent 5: Extract brand + design tokens from the live site
  - FIRST: Load skills: "diagram-design", "blog-brand"
  - Follow diagram-design/references/onboarding.md § URL: fetch 2-3 pages,
    map detected colours to semantic roles, trace every font to its source
  - Produce the brand fidelity receipt (Step 4) — it becomes 03-design-tokens.md
  - Save to klien/<slug>/research/brand-extraction.md
```

### Branch B — no website yet

Nothing to scrape. Research the market the business lives in, then present a
draft for correction. Do **not** write the bundle before the user confirms.

**Wave 1 (parallel):**

```
Agent 1: Market + competitor discovery
  - FIRST: Load skills: "defuddle", "seo-content"
  - From the business name/industry given, find 3-5 real competitors and what
    their sites do well and badly
  - Save to klien/<slug>/research/competitors/*.md + competitive-overview.md

Agent 2: Search demand + keywords
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - What this audience actually searches, grouped by intent
  - Save to klien/<slug>/research/keywords/keyword-strategy.md

Agent 3: Discourse / real questions
  - FIRST: Load skill: "blog-discourse"
  - Questions people ask about this category, in their own words
  - Save to klien/<slug>/research/discourse/questions.md

Agent 4: Visual + structural references
  - FIRST: Load skills: "defuddle", "diagram-design"
  - How good sites in this industry are laid out and styled; note the page
    patterns buyers expect
  - Save to klien/<slug>/research/industry-references.md
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
  - Save to klien/<slug>/research/discovery-draft.md

  THEN PRESENT IT AND STOP. Ask the user to correct it:
    "Dari riset, saya usul X — betul, atau perlu dikoreksi?"
  - Never write the bundle on an unconfirmed draft
```

The confirmed draft becomes the input to Wave 3 below.

**Wave 4 (parallel) — the handoff bundle. THIS IS THE DELIVERABLE.**

Write all 9 documents. Nothing else in this skill matters as much.

```
Agent 6: Brief + brand
  - FIRST: Load skills: "seo-plan", "blog-brand", "blog-persona"
  - 01-brief.md — business, goals, audience, offer, differentiators,
    what success looks like
  - 02-brand.md — voice on blog-persona's four axes, do/don't lists,
    voice samples, taboo phrases
  - Brand ALWAYS at klien/<slug>/02-brand.md — never BRAND.md, never
    the project root (blog-brand's default is wrong for this skill)
  - Branch A: derive from website-analysis.md
  - Branch B: derive from the confirmed discovery-draft.md

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
      3. Section compositions — the sections each page is built from, in
         order, and what each carries.
      4. The tokens — semantic roles (paper, paper-2, ink, muted, rule,
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

Agent 8: Page copy
  - FIRST: Load skills: "seo-content-brief"
  - 05-content/<page-slug>.md — one file per page from 04-sitemap.md
  - Follow the 9 page types in
    seo-content-brief/references/page-type-templates.md
  - Contact is NOT among them — write it from the Homepage CTA pattern:
    form, NAP block, map, operating hours
  - Respect the Website Relevance Rule: every claim must be something this
    client can credibly say about its actual offer

Agent 9: Tech spec + SEO foundation
  - FIRST: Load skills: "seo-technical", "seo-schema", "seo-cluster", "seo-page"
  - 06-tech-spec.md — stack, rendering strategy per page type (SSR for
    dynamic/SEO pages, SSG for static, CSR for authenticated only), hosting,
    CMS, component inventory, forms, analytics, integrations. State the stack
    explicitly: the scaffold step reads this file to decide what to generate.
  - 07-seo-foundation.md — keyword map, per-page meta (title + description),
    schema per page type, internal linking plan, CWV targets

Agent 10: Master prompt
  - FIRST: Load skills: "diagram-design"
  - 00-handoff.md — the master prompt: reading order of the other 7 documents,
    what to build, what is fixed vs open for the builder to decide, and
    acceptance checks. Must stand alone in a fresh session with no other
    context.
```

**Wave 5 (parallel) — side outputs: overview, ads plan, research reports.**

These are NOT part of the handoff bundle. The overview is a client presentation;
the rest is post-launch marketing collateral. None of it goes into
`08-build-prompt.md`, and none of it goes into 01–07.

```
Agent 11: Generate client overview report (HTML + MD)
  - FIRST: Load skills: "diagram-design", "dataviz", "blog-analyze"
  - Input: all Wave 1 research
  - Output:
    - klien/<slug>/overview.html (interactive HTML report, dark theme, charts)
    - klien/<slug>/overview.md (markdown version for quick reference)
  - See "Report Requirements" below

Agent 12: Generate SEO planning diagrams
  - FIRST: Load skills: "diagram-design", "dataviz"
  - Input: keyword + competitor data
  - Output:
    - klien/<slug>/diagrams/keyword-gap.html (bar chart: our keywords vs competitors)
    - klien/<slug>/diagrams/content-cluster.html (hub-and-spoke content map)
    - klien/<slug>/diagrams/build-priority.html (action items by impact/effort)

Agent 13: Content plan (research output, NOT part of the bundle)
  - FIRST: Load skills: "blog-strategy", "blog-cluster", "seo-cluster"
  - Input: keyword strategy, discourse questions, competitor gaps
  - Output: klien/<slug>/research/content-plan.md
  - Contents: the article list with publish order, target keyword and intent
    per article, content type, and which page each links back to. Cluster the
    articles hub-and-spoke so the internal linking in 07 has somewhere to land.
  - This stays under `research/` and out of 08-build-prompt.md: a content
    calendar describes what to publish after launch, not what to build now.
    Articles are written later with `/freelance blog-write`.

Agent 14: Ads strategy report + diagrams
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

**Wave 6 (single agent):**

```
Agent 15: Create config files + vault hub
  - klien/<slug>/.freelance-project.md (client info, keywords, competitors)
  - klien/<slug>/.freelance-state.json (pipeline tracker)
  - klien/<slug>/00-index.md — the vault hub. Links every bundle document
    and every note with [[wiki-links]], grouped by section
  - klien/<slug>/ vault folders (the client folder IS the vault root):
    ├── notes/ (research notes)
    ├── products/ (product docs)
    └── strategy/ (strategy docs)
```

**Wave 7 (single agent) — the paste file:**

```
Agent 16: Assemble 08-build-prompt.md
  - Runs LAST, after every other document is final
  - Read the finished 01-brief.md … 07-seo-foundation.md and every
    05-content/*.md file, and concatenate them verbatim
  - DO NOT regenerate any content — assembly only, or the copies drift
  - IN SCOPE: 01–07 plus 05-content/. NOTHING ELSE.
  - OUT OF SCOPE: the ads plan, research reports, and diagrams. Do not include
    them — they are post-launch marketing collateral, and folding them in
    would bury the build spec
  - MUST ALSO CARRY the anti-slop rules inline, as a section near the front,
    before the inlined documents. This is the one thing 08 adds rather than
    copies: a builder receiving only this paste has no access to the vendored
    design skills, and without these rules it will produce a centred hero over
    three feature cards. Include the banned lists (fonts, layouts, borders and
    shadows, motion), the whitespace floor, and the pre-output checklist the
    builder should tick before delivering
  - Structure:
      1. Opening instruction: what this is, what to build, and the reminder
         that the sitemap defines the page list and the tech spec defines
         the stack
      2. `---` separator, then `# 01 — BRIEF` followed by the full text of
         01-brief.md
      3. Repeat for 02 through 07
      4. Then one section per page from 05-content/, headed with its URL
  - The result must be understandable with zero access to the folder — no
    "see 04-sitemap.md" cross-references, no relative links
```

**Init is NOT complete until Wave 7 finishes.**

### Scaffold (optional, after the bundle)

Once `06-tech-spec.md` exists, offer to scaffold the starter project at
`klien/<slug>/site/`. **Read the stack from the tech spec** — do not assume
Next.js.

| `06-tech-spec.md` says | Generate |
|---|---|
| `next` / `nextjs` | `app/` route dir, `layout.tsx`, `globals.css`, `tailwind.config.ts` |
| `astro` | `src/pages/`, `src/layouts/`, `src/styles/`, `astro.config.mjs` |
| `static` / `html` | `index.html` + one file per page from 04-sitemap.md, `assets/` |
| anything else | Ask the user rather than guessing |

In every case: write `03-design-tokens.md`'s values out as CSS custom
properties in the token stylesheet, and create one placeholder file per page
listed in `04-sitemap.md`. Scaffolding is structure only — the builder AI fills
in the content from `05-content/`.

### Report Requirements

`klien/<slug>/overview.html` — single self-contained HTML, **bright theme with sidebar navigation**, charts as inline SVG/CSS.

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

**First:** `mkdir -p klien/<slug>/content`

**Wave 1 (parallel):**

```
Agent 1: Keyword research for this topic
  - FIRST: Load skills: "serper-api", "seo-cluster", "blog-brief"
  - Primary keyword, secondary keywords, long-tail variations
  - SERP analysis: who ranks, what content type, gaps
  - Save to klien/<slug>/research/keywords/<topic-slug>-keywords.md

Agent 2: Discourse research
  - FIRST: Load skill: "blog-discourse"
  - What people ask about this topic
  - Save to klien/<slug>/research/discourse/<topic-slug>-questions.md
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
  - Input: brief + outline + klien/<slug>/02-brand.md
  - Output: klien/<slug>/05-content/<page-slug>.md
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
  - Save to klien/<slug>/content/<topic-slug>.md
  - Update klien/<slug>/.freelance-state.json
```

---

## `/freelance audit <url>`

Full SEO audit. All 5 audits run in parallel.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

**First:** `mkdir -p klien/<slug>/reports`

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
    - klien/<slug>/reports/audit.html (interactive HTML report, BRIGHT theme with sidebar)
    - klien/<slug>/reports/audit.md (markdown version for quick reference)
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

**Full re-audit: clean slate.** Deletes old audit artifacts, then re-runs the complete audit from scratch with fresh timestamped files.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

### Phase 0: CLEAN — Remove stale files

```bash
SLUG=$(echo "$URL" | sed -E 's|^https?://||; s|^www\.||; s|/.*||' | tr '[:upper:]' '[:lower:]')

# Delete all old audit reports (HTML, MD)
rm -f klien/$SLUG/reports/audit-*.html
rm -f klien/$SLUG/reports/audit-*.md
rm -f klien/$SLUG/reports/technical-audit.md
rm -f klien/$SLUG/reports/onpage-audit.md
rm -f klien/$SLUG/reports/schema-audit.md
rm -f klien/$SLUG/reports/geo-audit.md
rm -f klien/$SLUG/reports/content-quality-audit.md

# The handoff bundle is NOT touched — reaudit refreshes audit output only
mkdir -p klien/$SLUG/{reports,diagrams}
```

**Do NOT delete:**
- `00-handoff.md` … `07-seo-foundation.md` — the client handoff bundle
- `overview.html` — the client-facing presentation
- `05-content/` — page copy
- `06-tech-spec.md` — stack decisions the scaffold depends on
- `.freelance-project.md` — project config (persistent)
- `.freelance-state.json` — pipeline state (persistent)
- `research/` — keyword & competitor research (reusable)
- `00-index.md` + `notes/` `products/` `strategy/` — vault (persistent)
- `diagrams/` — planning diagrams (overwritten by new ones)
- `ads/` — ads strategy + diagrams (overwritten by new ones)

**Log what was deleted:**
```
🗑️  Cleaned 7 old files from klien/$SLUG/reports/
🔄  Diagrams & ads strategy will be overwritten with fresh data
```

### Phase 1: AUDIT — Fresh 5-agent parallel audit

Generate timestamp: `TIMESTAMP=$(date +"%Y-%m-%d-%H%M")` (e.g., `2026-08-31-1430`)

All output files use format: `audit-<slug>-<TIMESTAMP>.html` / `.md`

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
    - klien/<slug>/reports/audit.html (BRIGHT theme with sidebar navigation)
    - klien/<slug>/reports/audit.md
  - Include: health scores, pass/fail checklist, priority actions, per-category breakdowns
  - See "Report Requirements" above for full design spec (sidebar, bright theme, collapsible sections)
```

### Output files (fresh, timestamped)

```
klien/$SLUG/
├── reports/
│   ├── audit-<slug>-<TIMESTAMP>.html    ← NEW (replaces old)
│   ├── audit-<slug>-<TIMESTAMP>.md      ← NEW (replaces old)
│   ├── technical-audit.md                 ← NEW
│   ├── onpage-audit.md                    ← NEW
│   ├── schema-audit.md                    ← NEW
│   ├── geo-audit.md                       ← NEW
│   └── content-quality-audit.md           ← NEW
├── diagrams/
│   ├── keyword-gap.html                   ← OVERWRITTEN
│   ├── content-cluster.html               ← OVERWRITTEN
│   └── build-priority.html                ← OVERWRITTEN
├── ads/
│   ├── ads-strategy.html                  ← OVERWRITTEN
│   ├── ads-strategy.md                    ← OVERWRITTEN
│   └── diagrams/
│       ├── platform-fit.html              ← OVERWRITTEN
│       ├── budget-split.html              ← OVERWRITTEN
│       └── campaign-flow.html             ← OVERWRITTEN
├── .freelance-project.md                  ← KEPT
├── .freelance-state.json                  ← KEPT
├── 00-handoff.md … 07-seo-foundation.md   ← KEPT (the handoff bundle)
├── 05-content/                            ← KEPT (page copy)
├── overview.html                          ← KEPT
├── research/                              ← KEPT
└── 00-index.md + notes/ products/ strategy/  ← KEPT
```

### Summary output

```
🔄 Re-audit complete for <slug>

🗑️  Cleaned: 7 old reports, 3 old diagrams
🆕 Generated: 2026-08-31 14:30 WIB

Files:
  📊 reports/audit-<slug>-2026-08-31-1430.html  (open in browser)
  📄 reports/audit-<slug>-2026-08-31-1430.md
  🔧 reports/technical-audit.md
  📝 reports/onpage-audit.md
  🏷️  reports/schema-audit.md
  🤖 reports/geo-audit.md
  📖 reports/content-quality-audit.md

Health Score: XX/100
Critical: X | High: X | Medium: X | Low: X
```

---

## `/freelance ads <url>`

Full ads strategy audit. Analyzes ad platform fit, budget allocation, campaign structure, and competitor ad gaps.

**Precondition:** `klien/<slug>/` must exist. If missing:
> "Jalankan `/freelance init` dulu."

**First:** `mkdir -p klien/<slug>/ads`

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

## `/freelance status`

**Precondition:** `.freelance-state.json` (or legacy `.seo-state.json`) must exist. If missing:
> "Jalankan `/freelance init` dulu."

**Load skills:** `blog-analyze` (for content scoring if content exists)

Read the state file + scan `research/`, `05-content/`, and the bundle documents. Report: done, in progress, pending.

---

## Example

```bash
# Branch A — client already has a site
/freelance init https://mysite.com
# → Wave 1: scrape + competitors + keywords + questions + brand extraction
# → Wave 4: the 9-document bundle (brief, brand, tokens, sitemap, copy, tech spec, SEO, handoff, build prompt)
# → Wave 5: overview report + diagrams
# → Waves 6-7: config, vault, then 08-build-prompt.md
# → Done! Open klien/mysite.com/00-handoff.md and hand it to a builder AI

# Branch B — no site yet, just a business name
/freelance init "Warung Kopi Kenangan"
# → Wave 1: market + demand + discourse + industry references
# → Wave 2: drafts a proposal and STOPS for your correction
# → Wave 4: the 9-document bundle, built from the confirmed draft

/freelance blog-write "Resep Keripik Singkong Original"
# → Keyword research → brief → write → SEO check → schema → publish

/freelance audit https://mysite.com
# → 5 audits parallel → combined report

/freelance status
```
