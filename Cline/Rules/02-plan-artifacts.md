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

## UUID Format

Plan UUIDs must be **8-character randomized alphanumeric** identifiers:
- **Length**: 8 characters
- **Character set**: `[a-zA-Z0-9]` (lowercase letters, uppercase letters, digits)
- **Collision space**: 62⁸ ≈ 218 trillion possible values
- **Format**: `[a-zA-Z0-9]{8}` — no dashes, no special characters
- **Generation**: Random (not sequential) to avoid predictability
- **Case**: Case-sensitive; `aB3xK7mP` and `ab3xk7mp` are distinct values

## Registry Format

```markdown
# Plan Registry

| UUID | Status | Date | Summary |
|------|--------|------|---------|
| aB3xK7mP | ⏹️ | 2026-05-14 10:30 | User authentication flow |
| dE5fG8hJ | ⏸️ | 2026-05-13 15:00 | Database schema redesign |
| gH1iJ4kL | ✅ | 2026-05-12 09:00 | Initial project setup |
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

## Extended Task Format

Optional annotations for smarter task execution:

### Dependencies
Use `→ depends:` to mark tasks that require other tasks to be completed first:
```markdown
- [ ] Task 1: Create User model
- [ ] Task 2: Create auth middleware
  → depends: Task 1
- [ ] Task 3: Add login endpoint
  → depends: Task 1, Task 2
```
**Execution rule:** Before starting a task with `→ depends:`, verify all listed dependencies are `[x]`. If not, skip to the next eligible task within the same phase.

### Conditional Tasks
Use `? if:` for tasks that only apply under certain conditions:
```markdown
- [ ] Task 4: Add PostgreSQL-specific indexes
  ? if: patterns.md shows PostgreSQL
- [ ] Task 5: Add SQLite fallback
  ? if: patterns.md shows SQLite
```
**Evaluation rule:** Check the condition against memory bank files or project state. If false, mark the task `[—]` (skipped) and move on.

### Task Status Markers

| Marker | Meaning |
|--------|----------|
| `[ ]` | Pending |
| `[x]` | Completed and verified |
| `[x✓]` | Completed with test pass |
| `[x!]` | Completed but with warnings |
| `[!]` | Failed — requires user intervention |
| `[—]` | Skipped — conditional task that does not apply |

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
6. Handle task failures
     - If a task fails (file write error, test failure, build break), mark it `[!]` in tasks.md
     - STOP immediately — do not continue to the next task
     - Display: "❌ Task {N} failed: {brief reason}. How would you like to proceed?"
     - Wait for user instruction (retry, skip, abort phase)
7. On final phase completion
    - **BEFORE updating registry, verify** that ALL tasks across ALL phases in `tasks.md` are marked `[x]`, `[x✓]`, `[x!]`, or `[—]` (skipped)
    - If any `[ ]` or `[!]` task remains, STOP and flag: "Cannot mark plan complete — Phase {N}, Task {M} is still open. Resolve it first."
    - If any `[x!]` tasks exist, display: "⚠️ Plan has {count} task(s) with warnings:" followed by a brief list. Ask: "Mark plan complete despite warnings?" Wait for user confirmation.
    - Only after confirming all tasks are resolved (and warnings acknowledged), update `registry.md`: change plan status to ✅

## Verification Protocol

Before marking any task `[x]`, verify the work:

### Auto-Verify Checklist
1. **File operations**: Did the file write succeed? (confirm file exists and has expected content)
2. **Code changes**: Does the code parse without syntax errors?
3. **Test-bearing projects**: If a test framework is detected in `patterns.md`, run relevant tests after code changes
4. **Build-bearing projects**: If a build tool is detected, run the build to check for compilation errors

### Verification Levels
Use the appropriate marker based on verification depth:

- `[x]` — Completed and verified (file exists, code parses)
- `[x✓]` — Completed with test pass (tests ran and passed)
- `[x!]` — Completed but with warnings (non-blocking issues noted inline)
- `[!]` — Failed (STOP, ask user — see Phase Execution Rule #6)

### Phase Gate
Before declaring a phase complete:
- All tasks must be at least `[x]` (or `[—]` if skipped)
- If any test-relevant task is only `[x]` (not `[x✓]`) and a test framework exists, warn: "Phase {N} complete but {count} tasks unverified by tests. Run tests?"

## Plan Activation (Handled by /switch-plan Workflow)

Use the `/switch-plan` workflow to change the active plan. Do not manually edit the registry outside that workflow.

## Registry Integrity

The registry (`registry.md`) is the single source of truth for plan discovery. To maintain integrity:

- **Automated changes expected.** The `/switch-plan` workflow, `plan-creator` skill, and Phase Execution Rules all modify registry.md as part of their normal operation. These rule-driven changes are correct and expected.
- **Manual ad-hoc edits discouraged.** Do not hand-edit registry.md outside of a workflow or rule-defined operation. If you need to correct the registry, use `/update-memory` to reconcile.
- **External modifications** (e.g., git merges) can cause the registry to desync with `./.ai/artifacts/{uuid}/` directories. If you detect a mismatch, use `/update-memory` to flag and reconcile.
- **Orphan detection:** If a plan's files are deleted externally but its registry entry remains, mark the entry as ✅ or ⏸️. Never delete registry entries — the history is valuable context.

## Constraints

- Only ONE active plan per project at a time
- The `plan-creator` skill automatically pauses the current active plan when creating a new one
- Plans are documentation only - no implementation during creation
- Keep `registry.md` accurate at all times
- Each project's artifacts are completely independent
- Execute implementation phase-by-phase with user confirmation between each
