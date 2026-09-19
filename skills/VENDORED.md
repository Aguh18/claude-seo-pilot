# Vendored design skills

These three are **not mine and not from an upstream I sync**. They were copied in from this
machine on 2026-09-19 so that `/freelance`'s visual-direction step works without depending on
whatever happens to be installed locally.

`/freelance` uses them to fill `03-design-tokens.md` (visual direction) and to inject anti-slop
rules into `08-build-prompt.md`.

## Provenance and licence status

| Skill | Source | Licence |
| --- | --- | --- |
| `frontend-design` | Anthropic official plugin, `frontend-design@claude-plugins-official` | Apache 2.0 — `LICENSE.txt` included |
| `high-end-visual-design` | `~/.agents/skills/` on the author's machine | **None found** |
| `design-taste-frontend` | `~/.agents/skills/` on the author's machine | **None found** |

## The thing to be aware of

`high-end-visual-design` and `design-taste-frontend` arrived in `~/.agents/skills/` with no
LICENSE file, no author, and no upstream URL. They do not appear in any Claude plugin catalogue.
They were added to that folder on 2026-07-30.

**They are published in this repository without a licence from their author.** That was a
deliberate call, but it is worth revisiting if this repo is ever commercialised, or if the author
is identified and objects. Removing them is a one-line change with one consequence noted below.

`frontend-design` is fine — it is Apache 2.0 from Anthropic and ships its `LICENSE.txt`.

## What breaks if you remove the unlicensed two

`/freelance` would lose the concrete design vocabulary for `03-design-tokens.md` and the
anti-slop rules it embeds into `08-build-prompt.md`. The bundle would still generate and still be
SEO-complete — this is exactly the state the skill was in before 2026-09-19, when the build prompt
described a site's content and palette but never how it should look, and generated pages read as
templated.

If you remove them, fold a small set of visual rules directly into `skills/freelance/SKILL.md`
rather than leaving the gap open.
