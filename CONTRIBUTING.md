# 🤝 Contributing to SEO Marketing Toolkit

Thanks for your interest in contributing!

## How to Contribute

### 1. Fork & Clone

```bash
git clone https://github.com/your-username/seo-marketing-toolkit.git
cd seo-marketing-toolkit
```

### 2. Create Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Add new skills to `skills/` folder
- Follow the existing folder structure
- Include SKILL.md with proper frontmatter

### 4. Test

```bash
./install.sh
# Restart Claude Code and test your changes
```

### 5. Commit & Push

```bash
git add .
git commit -m "feat: add your feature description"
git push origin feature/your-feature-name
```

### 6. Open PR

Go to GitHub and create a Pull Request.

## Skill Structure

Each skill should have:

```
skills/your-skill/
├── SKILL.md           # Required - skill definition
├── references/        # Optional - reference docs
└── scripts/           # Optional - helper scripts
```

### SKILL.md Format

```markdown
---
name: your-skill
description: What this skill does
---

# Your Skill Name

## What It Does
...

## How to Use
...

## Examples
...
```

## Code Style

- Use Markdown for documentation
- Use bash for scripts
- Use Python for data processing
- Keep files under 5000 lines

## Questions?

Open an issue on GitHub!
