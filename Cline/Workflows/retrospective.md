---
name: /retrospective
description: >
  Extracts reusable patterns and knowledge from a successfully completed plan.
  Triggered automatically at the end of Phase Execution (Rule #7 in 02-plan-artifacts.md)
  or manually by the user via `/retrospective`.
---

# Retrospective Workflow

This workflow implements a cross-session learning loop, allowing the agent to capture successful patterns, update conventions, and improve templates for future plans.

## Trigger
Runs automatically when all tasks in all phases of the active plan are marked complete, immediately *before* changing the plan status to ✅ in `registry.md`.

## Execution Steps

### Step 1: Request User Feedback & Turn-Yield
1. **Registry Transition**: Update `./.ai/artifacts/registry.md` to change this plan's status from `⏹️` to `🔄` (Retrospective/Reviewing).
2. Ask the user:
> "What patterns or solutions from this plan worked well and should be saved for future plans? (Say 'skip' or 'nothing' to proceed without saving)"

**CRITICAL: IMMEDIATELY YIELD THE TURN.** You MUST stop writing, output the prompt above, and terminate your current message response immediately. Do NOT run other commands, write files, or update the registry in this turn. You are strictly forbidden from proceeding to Step 2 until the user has submitted their response.

### Step 2: Handle Skip
If the user says "skip", "nothing", "no", or similar:
- Jump directly to Step 4 (Record Completion).

### Step 3: Extract & Save Patterns
If the user provides feedback or identifies reusable patterns:
1. **Update Architecture**: Add any newly discovered conventions, tech stack changes, or key relationships to `./.ai/memory-bank/patterns.md`.
2. **Template Extraction (Optional)**: If the user's feedback suggests this was a highly reusable plan structure, create or update a template in `~/.agents/skills/plan-creator/templates/` (or `Cline/Skills/plan-creator/templates/`). Include YAML frontmatter:
   ```yaml
   ---
   project_types: [web, mobile, backend]
   frameworks: [detected_framework]
   last_used: YYYY-MM-DD
   success_count: 1
   ---
   ```
3. **Increment Success**: If the plan was originally created from an existing template, increment that template's `success_count` in its YAML frontmatter.

### Step 4: Record Completion
Log the completion in `./.ai/memory-bank/progress.md`:
- Append: `[YYYY-MM-DD HH:MM] Retrospective: {brief 1-sentence summary of what was learned or 'No new patterns saved'}`

### Step 5: Finalize Plan
- Open `./.ai/artifacts/registry.md` and explicitly change this plan's status to ✅.
