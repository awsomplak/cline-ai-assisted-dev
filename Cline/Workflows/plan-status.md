# Plan Status Workflow

## Steps

0. **Determine Project Root**
    - Identify the current workspace/project root directory

1. **Ensure Registry Exists**
    - Check if `./.ai/artifacts/registry.md` exists
    - If not, inform user: "No plans found in {project-name}. Use /create-plan to create one."

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

4. **Active Plan Details**
    - If active plan exists:
        - Read `./.ai/artifacts/{active-uuid}/tasks.md`
        - Show completed/total tasks: "Tasks: {completed}/{total}"
        - Show plan summary from registry

5. **No Active Plan Warning**
    - If no `⏹️` status found, warn user: "No active plan in {project-name}. Use /switch-plan {uuid} to activate one."