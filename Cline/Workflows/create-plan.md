# Create Plan Workflow

## Steps

0. **Determine Project Root**
    - Identify the current workspace/project root directory
    - All subsequent paths are relative to this root
    - If multiple workspaces are open, ask user which project this plan is for
    - If no project is open, ask user to open one first

1. **Ensure Directory Structure (No Confirmation)**
    - Check if `./.ai/` exists in project root
    - If not, create silently without asking: `./.ai/`, `./.ai/memory-bank/`, `./.ai/artifacts/`
    - If `./.ai/artifacts/registry.md` doesn't exist, create it with:
      ```markdown
      # Plan Registry
      
      | UUID | Status | Date | Summary |
      |------|--------|------|---------|
      ```

2. **Scan Project & Generate Memory Bank (Auto-Populate)**
   - Check if `./.ai/memory-bank/` files exist. If ANY are missing or empty:
     - Scan the project: Read key files like `README.md`, `composer.json`, `package.json`, main config files, directory structure
     - Generate `brief.md`: Extract project overview, core requirements, goals from scanning
     - Generate `context.md`: Infer problem space, user needs, key decisions from codebase
     - Generate `patterns.md`: Document detected architecture, tech stack, conventions, key libraries
     - Generate `progress.md`: Initialize with current status, note this initial analysis
   - If memory-bank files already exist with content, skip generation

3. **Read Registry**
   - Parse `./.ai/artifacts/registry.md`
   - Extract existing UUIDs and their statuses
   - Identify current active plan (if any)

4. **Generate New Plan**
   - Generate a new unique UUID
   - Ask user for a one-line summary of the plan
   - Create directory `./.ai/artifacts/{uuid}/`

5. **Create Plan Files**
   - `plan.md` with:
     - Overview (brief description)
     - Approach (how to implement)
     - Expected Outcomes (what success looks like)
   - `tasks.md` with:
     - Organized by phases based on logical implementation order
     - Ordered list of implementation tasks 
     - Each task starts with `[ ]` checkbox
     - Format:
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
   - `notes.md` (only if technical constraints or risks exist) with:
     - Constraints 
     - Risks 
     - Decisions

6. **Update Registry**
   - Change all existing ⏹️ statuses to ⏸️ 
   - Add new row to registry table:
     | {uuid} | ⏹️ | {current_timestamp} | {summary} |

7. **Auto-Open Files (No Confirmation)**
   - Open in editor without asking:
     - `./.ai/artifacts/{uuid}/plan.md` 
     - `./.ai/artifacts/{uuid}/tasks.md`

8. **Confirm and Stop**
   - Display: "Plan '{summary}' created in {project-name} with UUID {uuid}. Memory bank populated from project analysis. Plan and memory files opened in editor."
   - DO NOT execute any implementation.

## Phase Execution Rules (For Implementation)

When user asks to implement the plan, follow these rules:

1. **Execute ONE phase at a time**
   - Read `./.ai/artifacts/{uuid}/tasks.md`
   - Identify the first phase with incomplete tasks (tasks with `[ ]`)
   - Implement ONLY that phase's tasks

2. **Mark tasks as done**
   - Change `[ ]` to `[x]` in tasks.md as each task is completed 
   - Save `tasks.md` after each task completion

3. **Stop after phase completion**
   - When all tasks in the current phase are `[x]`, STOP immediately
   - Display summary: "Phase {N}: {phase goal} completed. Tasks done: {completed}/{total}. Ready for Phase {N+1}."

4. **Require user confirmation for next phase**
   - Ask: "Phase {N} is complete. Would you like me to proceed with Phase {N+1}: {next phase goal}?"
   - Wait for explicit confirmation before starting next phase 
   - Never auto-proceed to next phase

5. **Update progress.md after each phase**
   - Add entry: [YYYY-MM-DD HH:MM] Phase {N} completed: {summary of what was done}
