# Plan Artifacts Rules

## CRITICAL: Project-Scoped Operations

All artifact paths are relative to the CURRENT PROJECT ROOT. Before any operation:
1. Determine the project root from the current workspace folder
2. All `./.ai/` paths refer to `{project-root}/.ai/`
3. Never use a global or shared `.ai/` directory—each project has its own
4. If multiple workspaces are open, confirm which project the user intends

## Auto-Setup (No Confirmation)

If `./.ai/artifacts/` directory does not exist, create it silently along with:
- `./.ai/artifacts/registry.md` with header `# Plan Registry` and an empty table

## Registry Protocol

**CRITICAL**: Never scan `./.ai/artifacts/` directory to discover plans. Always parse `./.ai/artifacts/registry.md` as the single source of truth.

## Registry Format

```markdown
# Plan Registry

| UUID | Status | Date | Summary |
|------|--------|------|---------|
| a1b2c3 | ⏹️ | 2026-05-14 10:30 | User authentication flow |
| d4e5f6 | ⏸️ | 2026-05-13 15:00 | Database schema redesign |
| g7h8i9 | ✅ | 2026-05-12 09:00 | Initial project setup |
```

## Status Values

- ⏹️ - Currently active plan (only ONE at a time)
- ⏸️ - Inactive/paused plan
- ✅ - Completed plan

## Plan Structure

Each plan lives in `./.ai/artifacts/{uuid}/` and contains:
- `plan.md` - Overall approach, reasoning, and expected outcomes
- `tasks.md` - Ordered task list with `[ ]` checkboxes
- `notes.md` - Technical constraints, risks, and key decisions (create only if needed)

## Tasks Format

Tasks must be organized by phases:
```markdown
# Tasks

## Phase 1: {phase goal}
- [ ] Task 1: {description}
    - [ ] Task 1.1: {description}
    - [ ] Task 1.2: {description}
- [ ] Task 2: {description}
    - [ ] Task 2.1: {description}
    - [ ] Task 2.2: {description}

## Phase 2: {phase goal}
- [ ] Task 3: {description}
    - [ ] Task 3.1: {description}
    - [ ] Task 3.2: {description}
- [ ] Task 4: {description}
    - [ ] Task 4.1: {description}
    - [ ] Task 4.2: {description}
```

## Phase Execution Rules (SINGLE SOURCE OF TRUTH)
When implementing a plan, strictly follow these rules:
1. Execute ONE phase at a time
    - Identify the first phase with incomplete tasks (`[ ]`)
    - Implement ONLY that phase's tasks
    - Do not read or prepare tasks from future phases
2. Mark completion in real-time
    - Change `[ ]` to `[x]` in tasks.md as each task finishes
    - Save tasks.md after each task
3. Stop after phase completion
    - When all tasks in current phase are `[x]`, STOP
    - Display: "✅ Phase {N}: {phase goal} completed. Tasks: {completed}/{total}."
4. Require explicit confirmation
    - Ask: "Phase {N} complete. Proceed with Phase {N+1}: {next phase goal}?"
    - Wait for user to say "yes", "proceed", "continue", or similar
    - If user says "no" or "wait", stop and let them review
5. Update memory bank after each phase
    - Add entry to `./.ai/memory-bank/progress.md`: `[YYYY-MM-DD HH:MM] Phase {N} completed: {phase goal}. {brief summary of changes}`
6. On final phase completion
    - When all phases are done, update `registry.md`: change plan status to ✅

## Plan Activation (Handled by /switch-plan Workflow)

Use the `/switch-plan` workflow to change the active plan. Do not manually edit the registry outside that workflow.

## Auto-Open Generated Files (No Confirmation)

After creating plan files, open them in the editor without asking:
- `./.ai/artifacts/{uuid}/plan.md`
- `./.ai/artifacts/{uuid}/tasks.md`

## Constraints

- Only ONE active plan per project at a time
- Complete or pause current plan before creating new one
- Plans are documentation only - no implementation during creation
- Keep `registry.md` accurate at all times
- Each project's artifacts are completely independent
- Execute implementation phase-by-phase with user confirmation between each
