# Plan Status Workflow

## Steps

0. **Project Root** *(per `02-plan-artifacts.md`)* — All paths relative to current workspace root.

1. **Ensure Registry Exists**
    - Check if `./.ai/artifacts/registry.md` exists
    - If not, inform user: "No plans found in {project-name}. Use `create plan` to create one."

2. **Read Registry**
    - Parse `./.ai/artifacts/registry.md`
    - Extract full table

3. **Display Status**
    - Show project name
    - Show complete registry table
    - Highlight active plan row with `→` prefix
    - Show plan counts:
        - Active: {count}
        - Inactive: {count}
        - Completed: {count}
        - Archived: {count} (if registry_archive.md exists)

4. **Active Plan Details**
    - If active plan exists:
        - Read `./.ai/artifacts/{active-uuid}/tasks.md`
        - If `tasks.md` is missing or unreadable: show "⚠️ tasks.md missing for plan {uuid}. Use `/update-memory` to reconcile."
        - Show completed/total tasks: "Tasks: {completed}/{total}"
        - Show marker legend: `[x]` done | `[x✓]` tested | `[x!]` warnings | `[!]` failed | `[—]` skipped
        - Show plan summary from registry

5. **No Active Plan Warning**
    - If no `⏹️` status found, warn user: "No active plan in {project-name}. Use /switch-plan {uuid} to activate one."