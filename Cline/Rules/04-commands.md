# Command Reference

## Session Commands

| User Input | Action |
|------------|--------|
| `follow rules` | 1. **Load environment:** Read `./.ai/memory-bank/environment.md`. If missing or older than 7 days, run environment detection first (see `05-environment.md`). 2. Parse `registry.md` for active plan (⏹️). 3. Load **only** that plan's `tasks.md`. Do not load other memory bank files unless required by the next user request. |
| `create plan` | Activate the `plan-creator` skill to generate a new plan and populate the memory bank. |
| `/switch-plan {uuid}` | Execute switch-plan workflow with specified UUID in current project. |
| `/plan-status` | Execute plan-status workflow for current project. |
| `/update-memory` | Execute update-memory workflow for current project. |
| `summarize session` | Update `progress.md` with current state, prepare for context reset. |

## Workflow Commands

Available workflows invoked with `/` prefix:

| Command | Purpose |
|---------|---------|
| `/switch-plan {uuid}` | Change active plan in current project's registry |
| `/plan-status` | Display registry table with active plan highlighted |
| `/update-memory` | Sync memory bank files with current project state |

## Project Scanning

- **Allowed**: Scan project source directories for code analysis and understanding
- **Required**: During plan creation (via `plan-creator` skill), scan project to populate memory-bank files with real data
- **Forbidden**: Scan `./.ai/artifacts/` directory (use registry.md)
- **Forbidden**: Scan `./.ai/memory-bank/` directory (files are known, load directly by name)

## Task Tracking

- Use `[ ]` for pending tasks in `tasks.md`
- Use `[x]` for completed tasks
- Update task status in real-time as work progresses