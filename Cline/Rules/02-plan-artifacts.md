<!-- → authority: 00-meta.md -->
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

## Uninitialized Recovery Protocol
 
If a command like `follow rules` or `start phase {N}` is executed but no active plan is registered (⏹️) in `./.ai/artifacts/registry.md`:
1. **Do not proceed** to code execution or task implementation.
2. **Scan chat history** to check if the user has already discussed or verbally agreed upon a plan in the current session.
3. If a verbal plan has been agreed upon, prompt the user: *"No active plan files exist on disk. Would you like me to scaffold our verbal agreement into rules-compliant plan artifacts?"*
4. If no plan has been discussed, prompt: *"No active plan found. Please run the `create plan` command or switch to a plan using `/switch-plan {uuid}` first."*
5. Skip further checks and stop execution until the user responds.

### Scaffolding Path Sanitization (Security Constraint)
When translating verbal plans to disk files during scaffolding:
- **Target Path Lock**: You **MUST** strictly validate that all *target file paths for write operations* lie entirely within the `./.ai/artifacts/{uuid}/` directory to prevent path-traversal exploits. Strip all relative directory operators (`../`, `..\`) and absolute path prefixes from the target filenames before writing.
- **Content Exemption**: This path sanitization applies strictly to the *destination write paths* on the host filesystem. It **MUST NOT** strip, alter, or sanitize relative links (e.g., `../../memory-bank/patterns.md`) written *inside* the markdown document text itself, which are required for relative previewing.

## Registry Protocol

**CRITICAL**: Never scan `./.ai/artifacts/` directory to discover plans. Always parse `./.ai/artifacts/registry.md` as the single source of truth.

### Registry Archiving Protocol (Token & Memory Preservation)
To prevent context bloat and token waste in long-running projects, the registry table must remain compact (maximum of 10 rows):
1. **Archive Target**: `./.ai/artifacts/registry_archive.md` (stores older completed plan logs).
2. **Compact Table Constraints**: `./.ai/artifacts/registry.md` strictly contains only the active plan (`⏹️`), any paused plans (`⏸️`), and the **last 3 completed plans** (`✅`).
3. **Archiving Trigger**: When a plan is marked completed (`✅`) in `registry.md`, if the total completed plan rows in the table exceed 3, the oldest completed plan rows must be silently cut from `registry.md` and appended to `registry_archive.md` (creating it if missing, with the header `# Plan Registry Archive` followed by the markdown table column headers: `\n\n| UUID | Status | Date | Summary |\n|------|--------|------|---------|`).
4. **Fail-Safe Archive Discovery Fallback**: If a plan UUID or list cannot be resolved in `./.ai/artifacts/registry.md` (e.g. during a plan switch or historical audit), you **MUST** silently read and parse `./.ai/artifacts/registry_archive.md` before declaring the plan missing or triggering the Uninitialized Recovery Protocol.
5. **Archive Uniqueness & Duplicate Filtering**: When writing or appending rows to `./.ai/artifacts/registry_archive.md`, you **MUST** strictly verify that the target plan UUID does not already exist in the archive. Duplicate entries must be silently filtered out to prevent data corruption.

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
**Execution rule:** Before starting a task with `→ depends:`, verify all listed dependencies are marked `[x]` or `[—]` (skipped). If not, skip to the next eligible task within the same phase. You MUST loop back and re-evaluate skipped tasks before concluding the phase to ensure out-of-order tasks are completed once their dependencies are met.
**Dependency Cascade Fallback:** If you loop through all remaining tasks and NONE of them are eligible due to unmet dependencies, STOP and notify the user of a "Dependency Cascade Failure".

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
    - **Phase Verification Gate**: Before executing any phase command (e.g., `start phase {N}`):
      - Read `tasks.md`.
      - If Phase {N-1} contains any remaining `[ ]` or `[!]` tasks, you MUST immediately halt and alert the user: *"🛑 Cannot start Phase {N}. Phase {N-1} still has incomplete or failed tasks. Resolve these first or instruct me to skip them `[—]`."*
    - Implement ONLY that phase's tasks
    - Do not read or prepare tasks from future phases
2. Mark completion in real-time
    - Change `[ ]` to `[x]` in tasks.md as each task finishes
    - **Batching**: You may complete multiple small, related tasks in one go and update `tasks.md` in a single save before moving to the next major task or finishing the phase.
3. Stop after phase completion
    - When all tasks in current phase are `[x]`, STOP
    - Display: "✅ Phase {N}: {phase goal} completed. Tasks: {completed}/{total}."
4. Require explicit confirmation
    - If there are remaining phases, ask: "Phase {N} complete. Proceed with Phase {N+1}: {next phase goal}?"
    - If this is the final phase, do NOT ask to proceed. Instead, state that the implementation is complete and move to final verification.
    - Wait for user to say "yes", "proceed", "continue", or similar (if not final phase).
    - If user says "no" or "wait", stop and let them review
5. Update memory bank after each phase
    - Add entry to `./.ai/memory-bank/progress.md`: `[YYYY-MM-DD HH:MM] Phase {N} completed: {phase goal}. {brief summary of changes}`
6. Handle task failures
     - If a task fails (file write error, test failure, build break), mark it `[!]` in tasks.md
     - STOP immediately — do not continue to the next task
     - Display: "❌ Task {N} failed: {brief reason}. How would you like to proceed?"
     - Wait for user instruction (retry, skip, abort phase)
     - **If the user instructs you to skip the task**, you MUST change its marker from `[!]` to `[—]` (skipped) in tasks.md so the plan can eventually be completed.
7. On final phase completion
    - **BEFORE updating registry, verify** that ALL tasks across ALL phases in `tasks.md` are marked `[x]`, `[x✓]`, `[x!]`, or `[—]` (skipped)
    - If any `[ ]` or `[!]` task remains, STOP and flag: "Cannot mark plan complete — Phase {N}, Task {M} is still open. Resolve it first."
    - If any `[x!]` tasks exist, display: "⚠️ Plan has {count} task(s) with warnings:" followed by a brief list. Ask: "Mark plan complete despite warnings?" Wait for user confirmation.
    - **Trigger the `/retrospective` workflow** automatically (see `Cline/Workflows/retrospective.md`) to extract reusable patterns before closing the plan.
    - Only after confirming all tasks are resolved (and warnings acknowledged) and retrospective is complete, update `registry.md`: change plan status to ✅
8. Walkthrough Protocol (Token Optimization)
    - **Never** write long walkthroughs or change lists in the chat window. Doing so wastes context and tokens.
    - **Write to Disk**: Always write a detailed `walkthrough.md` directly into the current active plan's directory: `./.ai/artifacts/{uuid}/walkthrough.md`.
    - **Compact Response**: Output only a 1-2 sentence compact message in the chat pointing to the written file: *"I have saved a detailed walkthrough of all accomplishments to `./.ai/artifacts/{uuid}/walkthrough.md`."*
    - **Markdown File Path Formatting**: When generating file links in any markdown document (e.g. plans, tasks, walkthroughs):
      - **Never** URL-encode paths (do not use `%20` for spaces).
      - **Relative Path Priority**: To guarantee perfect cross-platform portability across IDEs, browsers, external previewers, and CI environments, you **MUST** prioritize relative paths (e.g. `[patterns.md](../../memory-bank/patterns.md)`) over absolute paths whenever referencing files within the active project.
      - **Relative Path Depth Formula Guide (Off-by-One Depth Prevention)**:
        - Files inside project root referenced from `tasks.md` or `plan.md` (which reside inside `./.ai/artifacts/{uuid}/`): `../../../filename` (e.g. `../../../package.json`)
        - Files inside project `src/` folder from `tasks.md` or `plan.md`: `../../../src/filename`
        - Files inside memory bank from `tasks.md` or `plan.md`: `../../memory-bank/filename` (e.g. `../../memory-bank/patterns.md`)
      - **Fallback schemes**: Absolute schemes (e.g. `file:///d:/Project/IDE/Cline AI Rules by AWLab-ID/...` with unencoded spaces) should be reserved strictly as a secondary fallback or when absolute referencing is explicitly required.

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
