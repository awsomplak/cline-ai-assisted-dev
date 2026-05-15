---
name: plan-creator
description: Creates structured implementation plans in the current project's .ai/artifacts/ directory AND auto-populates the .ai/memory-bank/ with project analysis. Use when user says "create a plan", "plan out", "make a plan for", "design an approach", "break down tasks", or requests to structure work into an implementation plan. Operates on the active project workspace only.
---

# plan-creator

This skill handles the creation of structured implementation plans and automatic memory bank population. It generates plan documentation, initializes memory-bank files with real project data from codebase scanning, and maintains the plan registry. **Plans are documentation only - no code execution or implementation occurs during plan creation.**

## Usage

Activate this skill when the user:
- Says "create a plan for..."
- Says "plan out..."
- Says "break down the tasks for..."
- Says "design an approach for..."
- Requests to structure work into an implementation plan

This skill always operates on the **current active project workspace**. If multiple projects are open, confirm which one the user intends.

## Steps

1. **Determine Project Root**
    - Identify the current workspace/project root directory
    - All paths are relative to this root
    - If multiple workspaces, confirm with user

2. **Ensure Structure Exists**
    - If `./.ai/` doesn't exist, silent create: `./.ai/`, `./.ai/memory-bank/`, `./.ai/artifacts/`
    - If `./.ai/artifacts/registry.md` doesn't exist, create with header and empty table

3. **Scan Project & Populate Memory Bank (CRITICAL)**
   - If `./.ai/memory-bank/` files are missing or empty:
      - Scan key project files: README.md, config files (composer.json, package.json, etc.), main source directories
      - Generate `brief.md` with project overview, requirements, goals from scan data
      - Generate `context.md` with problem space, user needs, key decisions inferred from codebase
      - Generate `patterns.md` with detected architecture, tech stack, conventions, key libraries
      - Generate `progress.md` with initialized status and this analysis noted
   - If files already have content, skip population

4. **Read Registry**
    - Parse `./.ai/artifacts/registry.md` to understand existing plans
    - Extract UUIDs and statuses from the markdown table
    - Do NOT scan the `./.ai/artifacts/` directory

5. **Generate Plan Identity**
    - Create a unique UUID for the new plan
    - Ask user for a concise one-line summary of the plan
    - Create directory `./.ai/artifacts/{uuid}/`

6. **Create Plan Files**
    - `plan.md` with Overview, Approach, and Expected Outcomes sections
    - `tasks.md` with phases and ordered checklist formatted below:
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
      Phases should represent logical groupings of work that can be completed together. Each phase should be independently testable.
    - `notes.md` only if technical constraints, risks, or key decisions exist

7. **Update Registry**
    - Change all existing `⏹️` statuses to `⏸️` in `./.ai/artifacts/registry.md`
    - Add new row: `| {uuid} | ⏹️ | {current_timestamp} | {summary} |`

8. **Auto-Open Files (No Confirmation)**
   - Open in editor without asking:
      - `./.ai/artifacts/{uuid}/plan.md`
      - `./.ai/artifacts/{uuid}/tasks.md`

9. **Confirm and Stop**
    - Display: "Plan '{summary}' created with UUID {uuid}. Memory bank populated from project analysis. Files opened in editor."
    - Remind user the plan is ready for implementation
    - **CRITICAL**: Do NOT execute any implementation, code changes, or task execution

## Phase Execution Rules (For Implementation)
When user asks to implement the plan:
1. **Execute ONE phase at a time**
   - Identify the first phase with incomplete tasks (`[ ]`)
   - Implement ONLY that phase's tasks
   - Do not read or prepare tasks from future phases

2. **Mark completion in real-time**
   - Change `[ ]` to `[x]` in `tasks.md` as each task finishes
   - Save `tasks.md` after each task

3. **Stop after phase completion**
   - When all tasks in current phase are `[x]`, STOP
   - Display: "✅ Phase {N}: {phase goal} completed. Tasks: {completed}/{total}."

4. **Require explicit confirmation**
   - Ask: "Ready to proceed with Phase {N+1}: {next phase goal}?"
   - Wait for user to say "yes", "proceed", "continue", or similar 
   - If user says "no" or "wait", stop and let them review

5. **Update memory bank**
   - After each phase: add entry to `./.ai/memory-bank/progress.md`
   - Format: `[YYYY-MM-DD HH:MM] Phase {N} completed: {phase goal}. {brief summary of changes}`
