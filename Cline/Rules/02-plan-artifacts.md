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

## Plan Mode Bootstrap (Mandatory)

Before ANY plan-related operation (e.g., `create plan`, `start phase {N}`, `follow rules` with an active plan), you **MUST** verify the directory structure exists:
- `./.ai/`
- `./.ai/memory-bank/`
- `./.ai/artifacts/`
- `./.ai/artifacts/registry.md`
If any of these are missing, create them silently before proceeding. This ensures global rules are strictly followed from the first interaction.

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
Use `→ depends:` to mark tasks that require other tasks to be completed first.

### Task Status Markers

The following markers are used in tasks.md:
- `[ ]` - Pending
- `[x]` - Completed and verified
- `[x✓]` - Completed with test pass
- `[x!]` - Completed but with warnings
- `[!]` - Failed — requires user intervention
- `[—]` - Permanently Skipped — conditional task that does not apply OR user-instructed skip (terminal, never re-evaluate)
- `[⏳]` - Deferred — dependencies not met (will be re-evaluated at phase end)

### Dependency Execution Rule

**Execution rule:** Before starting a task with `→ depends:`, verify all listed dependencies are marked `[x]` or `[—]` (skipped). If not, skip to the next eligible task within the same phase. If a task is skipped due to unmet dependencies, mark it `[⏳]` (deferred) not `[—]`. You MUST loop back and re-evaluate **ONLY tasks marked `[⏳]`** before concluding the phase to ensure out-of-order tasks are completed once their dependencies are met. **NEVER re-evaluate `[—]` (permanently skipped) tasks.**

**Dependency Cascade Fallback:** If you loop through all remaining tasks and NONE of them are eligible due to unmet dependencies, STOP and notify the user of a "Dependency Cascade Failure".

### Conditional Tasks
Use `? if:` for tasks that only apply under certain conditions.

**Evaluation rule:** Check the condition against memory bank files or project state. If false, mark the task `[—]` (permanently skipped) and move on. **Never re-evaluate `[—]` tasks.**

## Phase Execution Rules (SINGLE SOURCE OF TRUTH)

When implementing a plan, strictly follow these rules:

### Next Phase Resolution Protocol
When the user says "start next phase" (without specifying a number):
1. Read `tasks.md` (the single source of truth).
2. Find the first `## Phase N` where ANY task is still `[ ]` or `[⏳]`.
3. Use that phase number as the target.

### Execution Steps

1. Execute ONE phase at a time
    - Identify the first phase with incomplete tasks (`[ ]` or `[⏳]`)
    - **Phase Verification Gate**: Before executing any phase command (e.g., `start phase {N}`):
      - Read `tasks.md`.
      - If Phase {N-1} contains any remaining `[ ]` or `[!]` tasks, you MUST immediately halt and alert the user: *"🛑 Cannot start Phase {N}. Phase {N-1} still has incomplete or failed tasks. Resolve these first or instruct me to skip them `[—]`."*
    - Implement ONLY that phase's tasks
    - Do not read or prepare tasks from future phases
2. Mark completion in real-time
    - Change `[ ]` or `[⏳]` to `[x]` in tasks.md as each task finishes
    - **Batching**: You may complete multiple small, related tasks in one go and update `tasks.md` in a single save before moving to the next major task or finishing the phase.
3. ⛔ ABSOLUTE STOP after phase completion
    - When all tasks in current phase are `[x]`, you MUST STOP.
    - You MUST NOT read, prepare, or execute ANY task from the next phase. You MUST NOT continue implementation.
    - Your ONLY permitted actions are: (1) update memory bank, (2) display completion message, (3) ask for confirmation.
    - **Mandatory Sentinel**: Your phase completion output MUST include this exact line: `🛑 PHASE GATE: Awaiting user confirmation.`
4. Update memory bank as a BLOCKING GATE
    - **MANDATORY**: You MUST update `./.ai/memory-bank/progress.md` BEFORE displaying the phase-complete message.
    - Add entry: `[YYYY-MM-DD HH:MM] Phase {N} completed: {phase goal}. {brief summary of changes}`
    - The phase is NOT considered complete until `progress.md` is written.
5. Require explicit confirmation
    - Display: "✅ Phase {N}: {phase goal} completed. Tasks: {completed}/{total}."
    - If there are remaining phases, ask: "Phase {N} complete. Proceed with Phase {N+1}: {next phase goal}?"
    - **NEVER interpret silence as confirmation.** NEVER auto-proceed.
    - Wait for user to explicitly say "yes", "proceed", "continue", or similar.
    - If this is the final phase, do NOT ask to proceed. Instead, state that the implementation is complete and move to final verification.
6. Handle task failures
     - If a task fails (file write error, test failure, build break), mark it `[!]` in tasks.md
     - STOP immediately — do not continue to the next task
     - Display: "❌ Task {N} failed: {brief reason}. How would you like to proceed?"
     - Wait for user instruction (retry, skip, abort phase)
7. On final phase completion
    - **BEFORE updating registry, verify** that ALL tasks across ALL phases in `tasks.md` are marked `[x]`, `[x✓]`, `[x!]`, or `[—]` (skipped)
    - If any `[ ]`, `[⏳]`, or `[!]` task remains, STOP and flag: "Cannot mark plan complete — Phase {N}, Task {M} is still open. Resolve it first."
    - If any `[x!]` tasks exist, display: "⚠️ Plan has {count} task(s) with warnings:" followed by a brief list. Ask: "Mark plan complete despite warnings?" Wait for user confirmation.
    - **Trigger the `/retrospective` workflow** automatically (see `Cline/Workflows/retrospective.md`) to extract reusable patterns before closing the plan.

## Bug Report Protocol

When the user reports a bug or error regarding the project:
- If the plan is IN-PROGRESS (⏹️): Add bug-fix task(s) to the current active phase
- If the plan is COMPLETED (✅): Reactivate the plan and add a new phase for fixes

### Walkthrough Protocol (Token Optimization)

- Never write long walkthroughs in the chat window
- Write detailed `walkthrough.md` to `./.ai/artifacts/{uuid}/walkthrough.md`
- Output only a 1-2 sentence compact message in chat pointing to the file

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
- All tasks must be at least `[x]` (or `[—]` if permanently skipped)
- If any test-relevant task is only `[x]` (not `[x✓]`) and a test framework exists, warn: "Phase {N} complete but {count} tasks unverified by tests. Run tests?"

## Plan Activation

Use the `/switch-plan` workflow to change the active plan.

## Registry Integrity

The registry (`registry.md`) is the single source of truth for plan discovery. The `/switch-plan` workflow, `plan-creator` skill, and Phase Execution Rules may modify `registry.md` BUT ONLY:
- Upon explicit user confirmation of plan switches
- Upon final completion of a phase (all non-skipped tasks verified)
- NEVER during speculative or intermediate state changes

## Constraints

- Only ONE active plan per project at a time
- The `plan-creator` skill automatically pauses the current active plan when creating a new one
- Plans are documentation only - no implementation during creation
- Keep `registry.md` accurate at all times
- Each project's artifacts are completely independent
- Execute implementation phase-by-phase with user confirmation between each