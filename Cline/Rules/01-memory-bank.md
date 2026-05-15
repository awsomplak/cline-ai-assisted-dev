# Memory Bank Rules

## CRITICAL: Project-Scoped Operations
All memory bank paths are relative to the CURRENT PROJECT ROOT.
- `./.ai/memory-bank/` means `{current-workspace-root}/.ai/memory-bank/`
- Each project maintains its own independent memory bank
- Never read or write memory files from a different project's directory
- If no project is open, ask the user which project to operate on

## Auto-Setup
If `./.ai/` directory does not exist in the current project root, create it silently:
- `./.ai/`
- `./.ai/memory-bank/`
- `./.ai/artifacts/`

## Core Files
Maintain these files in `./.ai/memory-bank/` with current project knowledge:

- `brief.md` - Project overview, core project requirements and goals
- `context.md` - Problem space, user needs, key decisions made
- `patterns.md` - Architectures, tech stack, conventions, technical standards, key libraries
- `progress.md` - Current status, completed, in progress, upcoming (next steps), known issues

When user asking for creating a plan or when your first analyzing the project, on first check `./.ai/memory-bank/` and if you found that directory is blank auto-generate All core files with content extracted from project scanning. Do NOT ask for confirmation.

## Loading Strategy
- On session start with "follow rules": Parse `./.ai/artifacts/registry.md` for active plan, then load only the memory bank files relevant to the current task.
- Never load all memory files at startup unless the task explicitly requires full project context.
- Load additional files on-demand as the task scope expands.

## Update Triggers
Update relevant memory bank file(s) immediately after:
- Architectural decisions or pattern changes → `patterns.md`
- New requirements discovered → `brief.md`
- Task completion or scope change → `progress.md`
- Key insights about users/problems → `context.md`

## Update Rules
- Append new information, preserve existing content.
- Use `##` sections for organization within each file.
- Add timestamps to progress entries: `[YYYY-MM-DD HH:MM] Description of change`.
