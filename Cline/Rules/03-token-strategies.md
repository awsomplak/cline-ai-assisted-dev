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
- **Project Scanner** (`06-project-scanner.md`): Loaded only during `plan-creator` skill execution, not on every session
- On `follow rules`: Load `environment.md` first, then load the active plan’s `tasks.md`. Do **not** pre-load other memory bank files unless the user’s request clearly needs them.

### Context Budget

Replace vague capacity estimates with deterministic turn-counting:

- **Turn 15**: Add to response: "📊 Session at ~50% capacity. Consider `/update-memory` if switching topics."
- **Turn 25**: Add: "⚠️ Session at ~80% capacity. Run `/update-memory` and start a fresh session with `follow rules`."
- **Turn 30**: STOP implementation. Force: "🛑 Context limit reached. Saving state to `progress.md`. Start a new session with `follow rules`."

### File-Size Budgets

Prevent memory bloat by enforcing max sizes:

| File | Max Lines | Action if exceeded |
|------|-----------|--------------------|
| `brief.md` | 30 | Summarize; move details to `notes.md` |
| `context.md` | 40 | Archive old decisions to a dated section |
| `patterns.md` | 50 | Keep only current architecture; archive previous |
| `progress.md` | 60 | Compress completed items older than 7 days into a "Historical Summary" section |
| `decisions.md` | 20 rows | Archive oldest rows when exceeded |
| `tasks.md` | 80 | Consider splitting into sub-plans |

### Memory Compression Protocol

When `progress.md` exceeds 60 lines:
1. Keep the last 5 timestamped entries
2. Summarize older entries into a single `## Historical Summary` section
3. Never delete entries — compress into summaries

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
