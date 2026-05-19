<!-- → authority: 00-meta.md -->
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
- Artifacts: Load only active plan files, not all plans
- **Project Scanner** (`06-project-scanner.md`): Loaded only during `plan-creator` skill execution, not on every session
- On `follow rules`: Load the active plan’s `tasks.md`. Do **not** pre-load other memory bank files unless the user’s request clearly needs them.
→ see: `01-memory-bank.md` for authoritative Loading Strategy (including environment.md priority).

### Context Budget

Different AI agents have wildly different context window capacities (ranging from 8k to 1M+ tokens). Do **not** attempt to "mentally track" an arbitrary point score across turns. Instead, use natural heuristics and physical checkpoints:

- **Heuristic Tracking**: Monitor your own performance. If you find yourself repeatedly searching the same files, looping over previous decisions, or forgetting instructions from earlier in the session, your context is overwhelmed.
- **Session Checkpoints**: If you detect context decay, explicitly recommend: "⚠️ Session context appears saturated. Run `/update-memory` to save state, then start a fresh session."
- **Hard Limit**: If you are repeatedly failing a complex task, STOP and force a checkpoint: "🛑 Context limit reached. Saving state to `progress.md`. Start a new session."

### Proactive Cognitive Cache Protocol

To prevent context bloat and token waste, you MUST NOT re-read files that have already been loaded or whose content is available in your current chat history unless:
1. The file was modified by a command or user action in the current turn.
2. The user explicitly requests you to re-read or refresh the file contents.
3. You explicitly explain in your thought block why the re-read is required (e.g., severe token shift or context loss).

Otherwise, retrieve file structures and key details from your conversation context/history rather than calling `view_file` again. Never spam the chat with "⚠️ Re-reading {file}" warnings; handle checks silently in your thought process.

### File-Size Budgets

Prevent memory bloat by enforcing max sizes:

| File | Max Lines (Small Proj) | Max Lines (Large Proj) | Action if exceeded |
|------|------------------------|------------------------|--------------------|
| `brief.md` | 30 | 50 | Summarize; move details to `notes.md` |
| `context.md` | 40 | 80 | Archive old decisions to a dated section |
| `patterns.md` | 50 | 120 | Keep only current architecture; archive previous |
| `progress.md` | 60 | 120 | Compress completed items older than 7 days into a "Historical Summary" section |
| `decisions.md` | 20 rows | 40 rows | Archive oldest rows when exceeded |
| `tasks.md` | 80 | 150 | Consider splitting into sub-plans |

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
- **Anti-Explosion Reading Protocol (Strict 5-File Turn Budget)**: To preserve processing performance, prevent API connection interruptions (`Invalid API Response`), and avoid context-bloat, you MUST NOT read more than **5 files** in a single execution turn.
  - **Absolute Parallel Limit**: Never invoke `view_file` on more than 5 files concurrently in the same turn.
  - **Incremental Search Processing**: If a `grep_search` or directory listing returns multiple matches, you **MUST NOT** immediately bulk-read all matched files. Instead:
    1. Scan the search match snippets/lines directly from the search output.
    2. Identify and rank the top **1 to 3 most relevant files**.
    3. Read only those top 1-3 files in the current turn.
    4. Only read additional files in subsequent turns if absolutely necessary after analyzing the initial set.
  - **High-Fidelity Search First**: Prioritize using `grep_search` and `patterns.md`'s `Quick Index` to find specific patterns or lines directly rather than executing broad `view_file` calls.

### Compact Rules & Minimal Action Profile (Small Local Models)
To prevent small local models (1.5B–3B parameters) from suffering context window failures, slow outputs, or tool-timeout loops:
1. **Pre-Compacted Rules Profile**: Rather than feeding full descriptive rulesets to resource-constrained models, load a pre-compacted, stripped-down `.clinerules` containing only command syntax and trigger keywords.
2. **Minimal Action Profile**: If the full rules are loaded, the model should immediately adopt the Minimal Action Profile:
   - **Zero Prose**: Omit conversational chat, introductory pleasantries, and lengthy summaries.
   - **Pure Actionable Commands**: Output thoughts in brief, 1-line bullet points, and go straight to native tool invocations.
   - **Lazy Loading Lockout**: Lock out all non-essential file operations, viewing strictly only active tasks and immediate target files.

## Anti-Patterns to Avoid

- ❌ Scanning the `./.ai/artifacts/` directory to find plans (parse `registry.md` instead)
- ❌ Loading all memory bank files when only one is needed
- ❌ Creating separate files for small amounts of related content
- ❌ Reading entire plan files when only the task list is needed
- ❌ Mixing artifacts between different projects
- ❌ Re-reading the registry multiple times in one session when the active plan hasn’t changed
