# Update Memory Workflow

## Steps

0. **Project Scope** *(per `02-plan-artifacts.md`)* — Only update memory within current project's `./.ai/memory-bank/`.

1. **Assess Changes**
    - Review conversation history for significant changes since last update
    - Identify which memory bank files need updating

2. **Update Relevant Files**
    - `environment.md`: If shell/OS has changed or `Last detected:` is older than 14 days, re-run detection per `05-environment.md`
    - `brief.md`: New or changed requirements
    - `context.md`: New understanding of problems or users
    - `patterns.md`: Architecture decisions or pattern changes
    - `progress.md`: Completed work, blockers, next steps
    - `decisions.md`: New architectural or technology decisions made during the session (WARNING: this is a lazy-loaded file. You MUST read the file first to understand its table structure before appending, otherwise you will corrupt the markdown format)

3. **Append Strategy**
    - Add new information to existing files
    - Never overwrite or delete existing content
    - Use timestamps for progress entries: `[YYYY-MM-DD HH:MM] Description`

4. **Minimum Update**
    - If no significant changes occurred, only update `progress.md` with:
      `[{timestamp}] Session summary: {brief note about what was done}`
    - Don't update other files if nothing changed

5. **Confirm**
    - List which files were updated
    - Show brief summary of changes made
    - Mention project name in confirmation