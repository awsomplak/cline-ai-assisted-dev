---
name: plan-creator
description: >
  Creates a new structured implementation plan. ONLY activate when the user
  explicitly requests a new plan with phrases like "create a new plan",
  "generate plan for", "make a detailed plan to...", "break down tasks for...",
  "create plan fo", "plan fo", "make plan fo", or uses the command "create plan".
  Do NOT activate for questions about existing plans, status inquiries, or memory updates.
  Operates on the active project workspace only.
---

# plan-creator

This skill handles the creation of structured implementation plans and automatic memory bank population. It generates plan documentation, initializes memory-bank files with real project data from codebase scanning, and maintains the plan registry. **Plans are documentation only - no code execution or implementation occurs during plan creation.**

## Usage

Activate this skill when the user explicitly requests a **new** plan using the triggers in the frontmatter. This skill always operates on the **current active project workspace**. If multiple projects are open, confirm which one the user intends.

## Steps

1. **Determine Project Root** — Identify current workspace root (per `02-plan-artifacts.md` Project-Scoped Operations). If multiple workspaces, confirm with user.

2. **Detect Environment FIRST**
    - Run environment detection per **`05-environment.md`** (the single source of truth)
    - Generate `./.ai/memory-bank/environment.md` with detected OS/shell
    - Ensures all subsequent commands use the correct shell syntax (PowerShell vs Bash)

3. **Ensure Structure Exists** — Silent create `./.ai/`, `./.ai/memory-bank/`, `./.ai/artifacts/` and `registry.md` if missing (per `01-memory-bank.md` Auto-Setup and `02-plan-artifacts.md` Auto-Setup).

4. **Scan Project & Populate Memory Bank (CRITICAL)**
    - If any of `brief.md`, `context.md`, `patterns.md`, `progress.md`, `decisions.md` are missing/empty in `./.ai/memory-bank/`:
      - Run the **Fingerprint Protocol** defined in **`06-project-scanner.md`** to detect project type, framework, and architecture
      - Use scan results to populate `patterns.md` (architecture, dependencies, testing)
      - Populate `brief.md`, `context.md`, `progress.md` from README and project analysis per **`01-memory-bank.md`** (Core Files section)
      - If architectural decisions are found during scan (e.g., framework choice, state management), populate `decisions.md` with initial entries
    - Skip files that already have content; `environment.md` was already set in Step 2

5. **Read Registry**
    - Parse `./.ai/artifacts/registry.md` to find existing plans and UUIDs
    - Do **not** scan the `./.ai/artifacts/` directory (use registry.md only — see `03-token-strategies.md`)
    - If registry exists but table structure is malformed (missing headers or separator row), rebuild the table header and warn: "⚠️ Registry table was malformed. Headers restored. Verify plan entries."

6. **Generate Plan Identity**
    - Generate an 8-character randomized alphanumeric UUID per the format defined in `02-plan-artifacts.md` (UUID Format section):
      - Length: 8 characters
      - Character set: `[a-zA-Z0-9]` (62 possible characters per position)
      - Generation: Random (not sequential)
    - Ask user for a concise one-line summary of the plan
    - **CRITICAL: STOP HERE AND WAIT FOR THE USER's RESPONSE.** Do NOT proceed to Step 7 until the user has provided the summary.
    - **EXCEPTION**: If the user has already provided a plan summary, a clear feature goal, or specific details in their triggering prompt (e.g. 'create a plan for user login' or 'plan for refactoring models'), or if a summary has been verbally discussed in chat, **bypass the stop-and-wait check entirely**. Synthesize the summary directly from the user's prompt and proceed immediately to Step 7.

7. **Create Plan Files**
    - After the user provides the summary, create directory `./.ai/artifacts/{uuid}/`
    - **Template matching:** Check if the user's request matches a template in the global directory `~/.agents/skills/plan-creator/templates/` (or fallback to local `Cline/Skills/plan-creator/templates/`):

      | Template | Trigger Keywords |
      |----------|------------------|
      | `feature-crud.md` | CRUD, create read update delete, resource management |
      | `auth-flow.md` | authentication, login, signup, auth |
      | `migration.md` | migrate, upgrade, version bump, refactor schema |
      | `refactor.md` | refactor, clean up, reorganize, optimize |
      | `bugfix.md` | fix, debug, broken, failing, error |
      | `integration.md` | integrate, connect, API integration, third-party |

    - If multiple templates match trigger keywords, prioritize the one whose YAML frontmatter `project_types` and `frameworks` match the current `patterns.md`.
    - If a template matches: read the skeleton from the hardcoded path, then **customize** phases and tasks based on project context from `patterns.md`
    - If no template matches: generate plan from scratch (original behavior)
    - Write `plan.md` with Overview, Approach, and Expected Outcomes sections
    - Write `tasks.md` with phases and ordered checklist per `02-plan-artifacts.md` (Tasks Format and Extended Task Format). Use `→ depends:` and `? if:` markers where appropriate.
    - Write `notes.md` only if technical constraints, risks, or key decisions exist

8. **Update Registry**
    - Change all existing `⏹️` statuses to `⏸️` in `./.ai/artifacts/registry.md`
    - Add new row: `| {uuid} | ⏹️ | {current_timestamp} | {summary} |`

9. **Auto-Open Files (No Confirmation)**
   - Open in editor without asking:
      - `./.ai/artifacts/{uuid}/plan.md`
      - `./.ai/artifacts/{uuid}/tasks.md`

10. **Confirm and Stop**
    - Display: "Plan '{summary}' created with UUID {uuid}. Memory bank populated from project analysis. Files opened in editor."
    - Remind user the plan is ready for implementation
    - **CRITICAL**: Do NOT execute any implementation, code changes, or task execution

## Implementation Instructions

When the user asks to implement this plan, **strictly follow the Phase Execution Rules in `02-plan-artifacts.md`**. Do not use any other phase‑execution instructions.
