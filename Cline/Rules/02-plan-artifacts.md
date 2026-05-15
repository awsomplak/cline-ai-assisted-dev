# Plan Artifacts Rules

## CRITICAL: Project-Scoped Operations
All artifact paths are relative to the CURRENT PROJECT ROOT. Before any operation:
1. Determine the project root from the current workspace folder
2. All `./.ai/` paths refer to `{project-root}/.ai/`
3. Never use a global or shared `.ai/` directory—each project has its own
4. If multiple workspaces are open, confirm which project the user intends

## Auto-Setup (No Confirmation)
If `./.ai/artifacts/` directory does not exist, create it silently along with:
- `./.ai/artifacts/registry.md` with header `# Plan Registry` and empty table

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

## Phase Execution Rules
When implementing a plan:
- One phase at a time - Never work on multiple phases simultaneously.
- Stop after each phase - When all tasks in current phase are `[x]`, stop and report.
- User confirmation required - Ask user before starting next phase: "Phase {N} complete. Proceed with Phase {N+1}: {goal}?".
- Update tasks.md - Mark `[x]` as tasks complete within the current phase.
- Update progress.md - Log phase completion with timestamp.
- Never auto-proceed - Always wait for explicit user confirmation between phases.

When all task phase is done or marked with `[x]`:
- update `./.ai/artifacts/registry.md` with current UUID to `✅`. 

## Plan Activation
When switching plans:
- Read `./.ai/artifacts/registry.md` from current project root
- Parse table to find UUIDs (no directory scanning)
- Change previous active to ⏸️
- Change target UUID to ⏹️
- Load plan files from `./.ai/artifacts/{active-uuid}/`

## Auto-Open Generated Files (No Confirmation)
After creating plan files, automatically open them in the editor without asking for confirmation:
- `./.ai/artifacts/{uuid}/plan.md`
- `./.ai/artifacts/{uuid}/tasks.md`

Never ask "Should I open these files?" - just open them.

## Constraints
- Only ONE active plan per project at a time
- Complete or pause current plan before creating new one
- Plans are documentation only - no implementation during creation
- Keep registry.md accurate at all times
- Each project's artifacts are completely independent
- Execute implementation phase-by-phase with user confirmation between each
