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

- **High-Speed Cloud Models (e.g. Gemini 3 Pro/Flash, GPT-4o-mini, Claude 3.5 Haiku, DeepSeek v4 Pro/Flash, and etc.)**: If active, you are fully authorized to handle 🔴 Complex tasks and large context scopes eagerly, but you MUST strictly maintain Native Tool Priority to guarantee execution speed.

### API Response Strictness (Anti-Parse Error Protocol)

To prevent `Invalid API Response` (empty or unparsable response) errors:
1. **Valid Tool Formats**: Always output tool calls strictly matching the provided schema. Do not hallucinate non-existent tools or parameters.
2. **No Markdown Wrapping**: Do not wrap JSON or XML tool calls inside markdown code blocks (````json ... ````) unless explicitly requested by the environment. Output raw tool schemas.
3. **Never Empty**: Never return a completely empty response. Always include a brief thought process before executing a tool.
4. **Valid JSON**: Ensure string escapes and JSON structures are flawlessly formatted.

### Native Tool Priority (REPL Hallucination Prevention)

You MUST prioritize native system tools (`view_file`, `replace_file_content`, `grep_search`, `write_to_file`) over raw terminal commands (`cat`, `sed`, `grep`, `echo`, `powershell`).

Raw shell execution is restricted to tasks where no native tool exists (e.g., running build scripts, tests).

**EXCEPTION - Permitted Shell Commands:**

The following operations are explicitly permitted and do NOT violate the Native Tool Priority rule:
- Any command explicitly whitelisted by other rule files with the `[PERMITTED]` marker
- Native shell test runs (e.g., `npm test`, `pytest`) and project build commands (e.g., `npm run dev`, `npm run build`)
- Git commands used during active version auditing or scans (e.g., `git status --porcelain`)