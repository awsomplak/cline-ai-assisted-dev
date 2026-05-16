---
name: plan-creator
description: >
  Creates a new structured implementation plan. ONLY activate when the user
  explicitly requests a new plan with phrases like "create a new plan",
  "generate plan for", "make a detailed plan to...", "break down tasks for...",
  or uses the command "create plan". Do NOT activate for questions about existing
  plans, status inquiries, or memory updates. Operates on the active project workspace only.
---

# plan-creator

This skill handles the creation of structured implementation plans and automatic memory bank population. It generates plan documentation, initializes memory-bank files with real project data from codebase scanning, and maintains the plan registry. **Plans are documentation only - no code execution or implementation occurs during plan creation.**

## Usage

Activate this skill when the user explicitly requests a **new** plan using the triggers in the frontmatter. This skill always operates on the **current active project workspace**. If multiple projects are open, confirm which one the user intends.

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
    - `tasks.md` with phases and ordered checklist formatted as specified in `02-plan-artifacts.md` (Tasks Format)
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

## Implementation Instructions

When the user asks to implement this plan, **strictly follow the Phase Execution Rules in `02-plan-artifacts.md`**. Do not use any other phase‑execution instructions.
