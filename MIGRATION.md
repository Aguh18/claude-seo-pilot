# Migrating from SEO Pilot to Freelance

The `seo-pilot` skill became `freelance` on 2026-09-19. Same engine, wider job: it now produces a
client web-build handoff bundle, and works for clients who have no website yet.

**The rename already landed in this repo.** This file covers the work that intentionally did not,
because it lives outside the repository or needs your decision.

## What already changed here

| Before | After |
|---|---|
| `skills/seo-pilot/` | `skills/freelance/` |
| `/seo-pilot <cmd>` | `/freelance <cmd>` |
| `seo-pilot/<domain>/` | `klien/<slug>/` |
| `.seo-project.md` | `.freelance-project.md` |
| `.seo-state.json` | `.freelance-state.json` |
| `.seo-pilot.log` | `.freelance.log` |
| `scripts/seo-pilot.sh` | `skills/freelance/scripts/freelance.sh` |
| `templates/.seo-*.template.*` | `skills/freelance/templates/.freelance-*.template.*` |
| `~/.seo-pilot/` (install target) | `~/.freelance/` |

Two structural cleanups happened alongside the rename:

- **Duplicate scripts consolidated.** `scripts/seo-pilot.sh` and `skills/seo-pilot/scripts/seo-pilot.sh`
  had drifted apart (368 vs 363 lines; the root copy had the `ads` phase, the skill copy did not).
  The root copy won and now lives only at `skills/freelance/scripts/freelance.sh`.
  `skills/*/scripts/check-updates.sh` and `update-skills.sh` were also stale duplicates of the root
  versions and were removed — the root copies are the ones that know about `AgriciDaniel/claude-ads`.
- **Duplicate templates consolidated.** Root `templates/` and `skills/seo-pilot/templates/` had
  drifted the same way; the root state JSON had the `ads` phase, the skill project MD had the
  Indonesian localization. Merged into one pair under `skills/freelance/templates/`.

Backward compatibility was kept deliberately: `freelance.sh` falls back to `.seo-project.md` and
`.seo-state.json` when the new names are absent, so existing projects keep working untouched. The
fallback is in `resolve_state_files()`.

## What still needs doing

### 1. Rename the GitHub repository

The remote is still `Aguh18/claude-seo-pilot`. Renaming is safe — GitHub redirects the old URL — but
three places hardcode it and should be updated after:

- `install.sh:4` and `install.sh:5` (the curl one-liner and repo comment)
- `install.sh:43` (the `git clone` target)
- `README.md` install section

Note the install command in `README.md` and `install.sh` will **keep working only through GitHub's
redirect** until the rename. If you rename, update those three lines in the same commit.

### 2. Update the environment variable

`install.sh` used to read `SEO_PILOT_REF` for the branch to install. It now reads `FREELANCE_REF`.
If you have `SEO_PILOT_REF` set in a shell profile or CI, rename it there too.

### 3. Install path moved

`install.sh` now installs to `~/.freelance/` and symlinks `~/.local/bin/freelance`. The old
`~/.seo-pilot/` directory is not removed and not read. Safe to delete it once you have re-run
`./install.sh`:

```bash
rm -rf ~/.seo-pilot
rm -f ~/.local/bin/seo-pilot
```

### 4. Remove the old global skill

The global install still has `seo-pilot` alongside the new `freelance`. Having both means two skills
with overlapping triggers. Once you have re-run `./install.sh`, remove the old one:

```bash
rm -rf ~/.claude/skills/seo-pilot
```

### 5. Per-project migration

Existing projects keep working through the fallback, but the old filenames remain. To move one over:

```bash
cd <project>
mv .seo-project.md .freelance-project.md   # only if it exists
mv .seo-state.json .freelance-state.json
rm -f .seo-pilot.log
```

Do **not** rename the output directory blindly. `seo-pilot/<domain>/` → `klien/<slug>/` is a
different convention (per-domain inside one folder, rather than a folder per project), so a rename
alone will not match what the skill now expects.

### 6. `dedi/AGENTS.md`

The parent repo's `AGENTS.md` still documents `tools/seo-pilot/` and the `/seo-pilot` skill. This
file only covers the `seo-marketing-toolkit` repo, so it was left alone. Worth updating:

- `AGENTS.md:11` — the repo map entry `seo-pilot/  # SEO Pilot output`
- `AGENTS.md:21` and `:23` — the "Tools Reference" heading and the skill name
- `AGENTS.md:58`, `:74-77` — the practical pointers to `tools/seo-pilot/` paths

### 7. Keripik Mang Dedi's existing output

`keripik-mang-dedi/tools/seo-pilot/` holds real work: `seo-strategy.html`, `FIX-PLAN.md`, five audit
reports, competitor research, and an obsidian vault. It is perfectly usable as-is, including the
`.seo-project.md` and `.seo-state.json` the fallback reads.

Two options when you next touch it:

- **Leave it.** It is a completed SEO engagement, not a web build. The fallback means `/freelance
  status` still reads it correctly.
- **Convert it.** Move it to a client folder and let `/freelance init` regenerate the handoff bundle
  from the existing research. More work, but it makes the project a reusable reference for the new
  workflow.

## Not changed on purpose

- **Upstream skills.** `blog-*`, `seo-*`, `ads-*`, `diagram-design`, `defuddle`, `knap` are vendored
  and synced by `scripts/update-skills.sh`. `/freelance` calls them; it does not modify them.
- **`scripts/ads-scripts/release.py`.** It derives the skill list from frontmatter (enforcing
  `name` == directory name, which the rename satisfies) and `PACKAGE_PREFIXES` already covers
  `skills/`. It is vendored from the claude-ads repo and cannot run here anyway — it requires
  `.claude-plugin/plugin.json`, which this repo does not have.
- **`install.sh`'s GitHub URLs.** See item 1 — deliberately deferred until you rename the repo.
