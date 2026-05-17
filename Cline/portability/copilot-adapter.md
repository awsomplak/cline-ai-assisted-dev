# GitHub Copilot Adapter Guide

This guide explains how to use the Cline AI Rules system with [GitHub Copilot](https://github.com/features/copilot).

## Rules Mapping

| Cline | Copilot | Notes |
|-------|---------|-------|
| `~/Documents/Cline/Rules/*.md` | `.github/copilot-instructions.md` | Copilot uses a single instruction file per repository. Concatenate rules into this file. |
| Global rules | Not directly supported | Copilot instructions are per-repo only. Use a template repo or copy instructions to each project. |

### Setup
1. Create `.github/copilot-instructions.md` in your repository root
2. Concatenate all rule files (01–06) into this single file
3. Copilot Chat will automatically use these instructions as context

### Alternative: Organization-Level Instructions
GitHub Enterprise users can set organization-wide instructions that apply to all repos. Place the concatenated rules there for global coverage.

## Workflows Mapping

| Cline | Copilot | Notes |
|-------|---------|-------|
| Workflow files | Include in `copilot-instructions.md` | Copilot doesn't have a separate workflow system. Embed workflow steps in the instructions. |
| `/plan-status` | Type in Copilot Chat | "Show me the plan status" — Copilot reads instructions and can follow the workflow steps. |
| `/switch-plan {uuid}` | Type in Copilot Chat | "Switch to plan {uuid}" |
| `/update-memory` | Type in Copilot Chat | "Update the memory bank" |

## Skills Mapping

| Cline | Copilot | Notes |
|-------|---------|-------|
| `plan-creator/SKILL.md` | Include in `copilot-instructions.md` | Add skill steps as a section. Copilot doesn't have a skill/trigger system. |
| Auto-trigger on phrases | **Not supported** | You must explicitly ask Copilot to follow the plan creation steps. |

## Per-Project `.ai/` Directory

Works identically. Copilot Chat can read and write files in the `.ai/` directory when given tool access.

## Limitations

| Feature | Status | Workaround |
|---------|--------|-----------|
| Auto-trigger skills | ❌ Not supported | Explicitly instruct: "Follow the plan-creator steps to create a plan" |
| `follow rules` command | ❌ Not a concept | Instructions load automatically with every Copilot Chat interaction |
| File creation/editing | ⚠️ Limited | Copilot Chat can suggest edits but may need manual apply. Use Copilot Workspace for multi-file changes. |
| Shell command execution | ⚠️ Limited | Copilot Chat can suggest commands but may not execute them directly |
| Phase-by-phase execution | ⚠️ Requires discipline | Copilot may try to complete all phases at once. Reinforce "one phase at a time" in instructions. |

## Templates

Reference templates in your prompt: "Use the auth-flow template from the templates directory to create a plan." Copilot can read the template files if they're in the repository.

## Recommendation

Copilot works best as a **secondary** tool alongside Cline. Use Cline for plan creation and phase execution (where tool access is critical), and Copilot for inline code completion within the planned tasks.
