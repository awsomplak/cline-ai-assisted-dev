<!-- → authority: 00-meta.md -->
# Model Router Rule

## Purpose
Optimize token usage and success rates by matching the complexity of a task to the capability of the currently active LLM.

## Task Complexity Classification

| Level | Criteria | Recommended Model |
|-------|---------|-------------------|
| 🟢 Simple | Single file, < 50 lines changed, follows template | Local Small |
| 🟡 Medium | 2-5 files, understanding dependencies, testing needed | Local Medium |
| 🔴 Complex | Architectural decisions, 5+ files, new patterns | Cloud Large |

## Auto-Classification Heuristics

The current task is 🟢 Simple if ALL conditions are met.

The current task is 🔴 Complex if ANY conditions are met.

## Escalation Protocol

If you encounter repeated failures, output format errors, circular dependencies, or context issues, STOP and warn the user.

## Universal Model Awareness

- Do not guess your parameter size - check system metadata
- Warn users on Complex tasks
- Avoid reading files larger than 500 lines

### Native Tool Priority (REPL Hallucination Prevention)

You MUST prioritize native system tools (`view_file`, `replace_file_content`, `grep_search`, `write_to_file`) over raw terminal commands (`cat`, `sed`, `grep`, `echo`, `powershell`).

Raw shell execution is restricted to tasks where no native tool exists (e.g., running build scripts, tests).

**EXCEPTION - Permitted Shell Commands:**

The following operations are explicitly permitted and do NOT violate the Native Tool Priority rule:
- Date difference calculations using PowerShell `New-TimeSpan` or Unix `date +%s` as specified in `01-memory-bank.md` (environment age checks)
- File age comparison scripts as specified in `06-project-scanner.md`
- Any command explicitly whitelisted by other rule files with the `[PERMITTED]` marker

These exceptions exist because no native IDE tool provides equivalent date-math or cross-platform file timestamp comparison functionality.