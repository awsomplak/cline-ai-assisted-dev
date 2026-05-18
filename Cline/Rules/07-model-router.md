<!-- → authority: 00-meta.md -->
# Model Router Rule

## Purpose
Optimize token usage and success rates by matching the complexity of a task to the capability of the currently active LLM. This rule defines how to handle tasks when running small (1.5B–3B), medium (14B–32B), or large (Claude/GPT) models.

## Task Complexity Classification

Before executing any task, classify its complexity:

| Level | Criteria | Recommended Model |
|-------|---------|-------------------|
| 🟢 **Simple** | Single file, < 50 lines changed, follows template, no new architecture | Local Small (e.g., qwen2.5-coder:3b) |
| 🟡 **Medium** | 2-5 files, requires understanding dependencies, testing needed | Local Medium (e.g., qwen2.5-coder:14b) |
| 🔴 **Complex** | Architectural decisions, 5+ files, new patterns, debugging subtle issues | Cloud Large (Claude Sonnet, GPT-4o) |

## Auto-Classification Heuristics

The current task is **🟢 Simple** if ALL of these are true:
- Task description matches a known template keyword.
- Only 1 file needs modification.
- The change is additive (not restructuring).
- No new dependencies or patterns are introduced.

The current task is **🔴 Complex** if ANY of these are true:
- User says "design", "architect", "why does", "debug".
- Task requires reading 5+ files.
- Task involves creating new modules/services.
- Plan creation (always use the strongest available model).

## Escalation Protocol

If you encounter any of the following triggers during a task, STOP and explicitly warn the user that the task complexity may exceed your current capabilities, and suggest escalation:
- Repeated test failures or compilation errors on the same task.
- Output that doesn't match the expected format (e.g., generating malformed JSON).
- Inability to resolve a circular dependency.
- Context window filling up prematurely.

**Escalation Message Format:**
> "⚠️ I am having trouble resolving this complex task with my current capabilities. This task may benefit from a more capable model. Switch to a higher-tier model?"

## Universal Model Awareness

- **Active Model Identification**: Do not attempt to guess your own parameter size or context limits (this causes direct hallucinations). Instead, check the system metadata/prompt for model identifiers (e.g., Claude, GPT, Gemini, Qwen). If no model identifier is present in metadata, do not claim to know your parameters and assume Standard Mode.
- **Universal Warning**: When tasked with a 🔴 Complex task, ALWAYS explicitly warn the user: *"This is a complex architectural task. Please ensure you are using an appropriate high-tier model."*
- **Large Files**: Avoid reading files larger than 500 lines entirely unless strictly necessary. Rely on `grep_search` and Quick Index mapping instead.
- **Compact Rules Bootstrapping Solution**: To resolve the paradox where small models (1.5B–3B) are too weak to parse these rules to enter "Compact Mode", a pre-compacted rule profile (`.clinerules.compact` containing only bare trigger commands) should be copied directly to `.clinerules` during installation on simple local setups. If the full rules are loaded, the model should immediately fall back to a **Minimal Action Profile** (zero prose, pure commands, zero conversational chat, absolute minimal tool usage) if high tool latencies or repeated timeouts are observed.
- **Native Tool Priority (REPL Hallucination Prevention)**: To prevent processing delays and execution overhead:
  - You **MUST** always prioritize using high-fidelity native system tools (`view_file`, `replace_file_content`, `grep_search`, `write_to_file`) over running raw terminal command scripts (such as `cat`, `sed`, `grep`, `echo`, `powershell`) to inspect, edit, or locate files.
  - Raw shell command execution is strictly restricted only to tasks where no native IDE/system tool exists (e.g. running build scripts, starting servers, running tests).
