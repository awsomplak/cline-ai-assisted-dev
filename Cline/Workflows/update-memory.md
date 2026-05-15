# Update Memory Workflow

## Steps

0. **Verify Project Scope**
    - Confirm the current project root
    - Only update memory files within this project's `./.ai/memory-bank/`
    - Never touch memory files from other projects

1. **Ensure Memory Bank Exists**
   - If `./.ai/memory-bank/` doesn't exist, silent create it first.
   - If `./.ai/memory-bank/` is empty or files are missing, run project scan to generate them
   - Do NOT leave memory-bank empty

2. **Assess Changes**
    - Review conversation history for significant changes since last update
    - Identify which memory bank files need updating

3. **Update Relevant Files**
    - `brief.md`: New or changed requirements
    - `context.md`: New understanding of problems or users
    - `patterns.md`: Architecture decisions or pattern changes
    - `progress.md`: Completed work, blockers, next steps

4. **Append Strategy**
    - Add new information to existing files
    - Never overwrite or delete existing content
    - Use timestamps for progress entries: `[YYYY-MM-DD HH:MM] Description`

5. **Minimum Update**
    - If no significant changes occurred, only update `progress.md` with:
      `[{timestamp}] Session summary: {brief note about what was done}`
    - Don't update other files if nothing changed

6. **Confirm**
    - List which files were updated
    - Show brief summary of changes made
    - Mention project name in confirmation
