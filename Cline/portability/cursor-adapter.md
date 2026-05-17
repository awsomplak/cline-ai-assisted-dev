# Cursor Adapter Guide

This guide explains how to use the Cline AI Rules system with [Cursor](https://cursor.com).

## Rules Mapping

| Cline | Cursor | Notes |
|-------|--------|-------|
| `~/Documents/Cline/Rules/*.md` | `.cursor/rules/` directory | Place rule files here. Cursor auto-loads all `.md` files in this directory. |
| Numbered files (01-06) | Same naming works | Cursor processes rules alphabetically, so numbered prefixes maintain order. |

### Setup
1. Copy all files from `Cline/Rules/` into your project's `.cursor/rules/` directory (project-scoped) or `~/.cursor/rules/` (global)
2. Cursor reads these as "Rule Files" — they appear in the Rules panel

## Workflows Mapping

| Cline | Cursor | Notes |
|-------|--------|-------|
| `~/Documents/Cline/Workflows/*.md` | `.cursor/rules/` | Cursor doesn't have a separate "Workflows" concept. Merge workflow instructions into rule files or use Notepads. |
| `/plan-status` | Type "plan status" in chat | No `/` prefix — just use natural language. |
| `/switch-plan {uuid}` | Type "switch plan {uuid}" | Same — natural language trigger. |
| `/update-memory` | Type "update memory" | Same — natural language trigger. |

### Recommendation
Create a single `.cursor/rules/workflows.md` file containing all three workflow definitions. Cursor treats it as additional context.

## Skills Mapping

| Cline | Cursor | Notes |
|-------|--------|-------|
| `~/.agents/skills/plan-creator/SKILL.md` | Cursor **Notepads** | Create a Notepad named "plan-creator" with the SKILL.md content. Reference it with `@plan-creator` in chat. |
| Skill frontmatter triggers | Not supported | Cursor doesn't auto-trigger based on phrases. You must explicitly reference the Notepad. |

## Per-Project `.ai/` Directory

Works identically in Cursor. The `.ai/` directory structure, registry, memory bank, and artifacts are all file-based and tool-agnostic.

## Unsupported Features

| Feature | Workaround |
|---------|-----------|
| Auto-trigger skills | Use `@notepad` mention instead |
| `follow rules` command | Rules load automatically in Cursor — just start chatting |
| Workflow `/` prefix | Use natural language equivalents |

## Templates

Copy `Cline/Skills/plan-creator/templates/` into your project. Reference templates manually in chat: "Use the bugfix template to create a plan for..."
