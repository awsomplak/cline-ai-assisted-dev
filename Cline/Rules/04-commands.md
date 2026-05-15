# Command Reference

## Session Commands

| User Input | Action |
|------------|--------|
| `follow rules` | Parse registry for active plan in current project, load relevant memory bank files |
| `create plan` | Execute /create-plan workflow for current project |
| `plan switch {uuid}` | Execute /switch-plan workflow with specified UUID in current project |
| `plan status` | Execute /plan-status workflow for current project |
| `update memory` | Execute /update-memory workflow for current project |
| `summarize session` | Update progress.md with current state, prepare for context reset |

## Workflow Commands
Available workflows invoked with `/` prefix:

| Command | Purpose |
|---------|---------|
| `/create-plan` | Generate new plan artifacts and update registry in current project |
| `/switch-plan {uuid}` | Change active plan in current project's registry |
| `/plan-status` | Display registry table with active plan highlighted |
| `/update-memory` | Sync memory bank files with current project state |

## Project Scanning
- **Allowed**: Scan project source directories for code analysis and understanding
- **Required**: During plan creation, scan project to populate memory-bank files with real data
- **Forbidden**: Scan `./.ai/artifacts/` directory (use registry.md)
- **Forbidden**: Scan `./.ai/memory-bank/` directory (files are known, load directly by name)

## Task Tracking
- Use `[ ]` for pending tasks in `tasks.md`
- Use `[x]` for completed tasks
- Update task status in real-time as work progresses
