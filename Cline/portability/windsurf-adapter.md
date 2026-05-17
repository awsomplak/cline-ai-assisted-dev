# Windsurf Adapter Guide

This guide explains how to use the Cline AI Rules system with [Windsurf](https://codeium.com/windsurf) (Cascade).

## Rules Mapping

| Cline | Windsurf | Notes |
|-------|----------|-------|
| `~/Documents/Cline/Rules/*.md` | `.windsurfrules` file | Windsurf uses a single file. Concatenate all rule files into one `.windsurfrules` at project root. |
| Global rules | `~/.windsurfrules` | Place combined rules here for global scope. |

### Setup
1. Concatenate all rule files: combine content of `01-memory-bank.md` through `06-project-scanner.md` into a single `.windsurfrules` file
2. Use `## ` headers to separate each rule section
3. Place at project root for project-scoped rules

### Concatenation Order
```
01-memory-bank.md → 02-plan-artifacts.md → 03-token-strategies.md → 04-commands.md → 05-environment.md → 06-project-scanner.md
```

## Workflows Mapping

| Cline | Windsurf | Notes |
|-------|----------|-------|
| `~/Documents/Cline/Workflows/*.md` | Include in `.windsurfrules` | Append workflow definitions to the rules file under a `# Workflows` section. |
| `/plan-status` | Type naturally in Cascade | "Show plan status" — Cascade reads workflows from `.windsurfrules`. |
| `/switch-plan {uuid}` | Type naturally | "Switch to plan {uuid}" |
| `/update-memory` | Type naturally | "Update the memory bank" |

## Skills Mapping

| Cline | Windsurf | Notes |
|-------|----------|-------|
| `plan-creator/SKILL.md` | Include in `.windsurfrules` | Add the skill steps under a `# Plan Creator` section in the rules file. |
| Skill frontmatter triggers | Windsurf Flows (if available) | Or include trigger instructions in the rules file. |

## Per-Project `.ai/` Directory

Works identically. File-based and tool-agnostic.

## Key Differences

| Aspect | Cline | Windsurf |
|--------|-------|----------|
| Rule format | Multiple `.md` files | Single `.windsurfrules` file |
| Skill activation | Frontmatter-based auto-trigger | Manual reference or Flows |
| Context management | Cascade has built-in context management that may overlap with your memory bank |

## Templates

Include the template table from SKILL.md Step 7 in your `.windsurfrules` file. Windsurf can read template files from `Cline/Skills/plan-creator/templates/` when referenced.
