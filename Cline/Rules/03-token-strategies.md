# Token Optimization Strategies

## Core Principles

- Parse text files, don't execute shell commands for discovery
- Load files on-demand, not eagerly at startup
- Keep filenames short, merge content when logical
- Use structured formats that are parseable with minimal tokens
- All paths are relative to current project root

## Specific Rules

### Registry First

- Always read `./.ai/artifacts/registry.md` to find plans
- Never `ls`, `find`, or `tree` the `./.ai/artifacts/` directory
- Parse the markdown table directly for UUID discovery
- **After reading the registry, remember the active UUID; do not re-read the registry unless switching plans or checking status.**

### Lazy Loading

- Memory bank: Load only files relevant to current task, on demand
- **EXCEPTION (always load):** `environment.md` — this 4-line file is always loaded on `follow rules` because it determines correct shell syntax for ALL commands. The token cost is negligible and the safety benefit is critical.
- Artifacts: Load only active plan files, not all plans
- Project source: Scan only directories relevant to the task
- On `follow rules`: Load `environment.md` first, then load the active plan’s `tasks.md`. Do **not** pre-load other memory bank files unless the user’s request clearly needs them.

### Context Management

- Monitor context window usage during tasks
- At ~70% capacity: Summarize current state to `./.ai/memory-bank/progress.md`
- Suggest starting a fresh session with `follow rules` to reload context
- Use `[x]` checkboxes in tasks.md instead of separate status tracking files

### File Optimization

- Short filenames: `brief.md` over `projectBrief.md`
- Combined content: Merge related information into fewer files
- Avoid verbose explanations in generated files
- Use compact table formats for data
- Do **not** create `notes.md` unless there are significant constraints or risks

## Anti-Patterns to Avoid

- ❌ Scanning the `./.ai/artifacts/` directory to find plans (parse `registry.md` instead)
- ❌ Loading all memory bank files when only one is needed
- ❌ Creating separate files for small amounts of related content
- ❌ Reading entire plan files when only the task list is needed
- ❌ Mixing artifacts between different projects
- ❌ Re-reading the registry multiple times in one session when the active plan hasn’t changed
