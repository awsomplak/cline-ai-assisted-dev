# Switch Plan Workflow

## Steps

0. **Determine Project Root**
    - Identify the current workspace/project root directory
    - All paths are relative to this root

1. **Validate Input**
    - Require UUID argument: `/switch-plan {uuid}`
    - If no UUID provided, read registry and display available plans, then ask for one

2. **Read Registry**
    - Parse `./.ai/artifacts/registry.md`
    - Verify target UUID exists in registry
    - If not found, display error with available UUIDs from registry

3. **Update Registry**
    - Change current `⏹️` status to `⏸️`
    - Change target UUID status to `⏹️`
    - Preserve all other rows unchanged

4. **Load New Active Plan**
    - Read `./.ai/artifacts/{uuid}/plan.md` for context
    - Read `./.ai/artifacts/{uuid}/tasks.md` for task list
    - Display summary of newly activated plan

5. **Confirm**
    - Show: "Switched to plan {uuid}: {summary} in {project-name}"
    - Show pending tasks count from tasks.md
