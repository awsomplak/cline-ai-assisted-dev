<!-- → authority: 00-meta.md -->
# Meta: Rule Priority & Conflict Resolution

## Master Priority Order

When rules appear to conflict, resolve using this explicit priority order (1 is highest):

1. **Security Constraints** (Never overridden. No secrets in `.ai/`, no path traversal out of project root)
2. **05-environment.md** (Shell/command correctness and environment detection)
3. **02-plan-artifacts.md** (Phase execution logic, task formats, UUID rules)
4. **01-memory-bank.md** (Memory loading/saving triggers and core file roles)
5. **03-token-strategies.md** (Optimization, compression, context budgets)
6. **06-project-scanner.md** (Scanning behavior, indexing protocols)
7. **04-commands.md** (Reference tables and shortcuts ONLY — never overrides core rules)

## Single Source of Truth Registry

Each concept maps to exactly ONE authoritative file. Other rules may *reference* these concepts but must never *redefine* them.

- **Phase Execution & Tasks** → `02-plan-artifacts.md`
- **Environment & Commands** → `05-environment.md`
- **Project Scanning & Indexing** → `06-project-scanner.md`
- **Memory File Definitions** → `01-memory-bank.md`
- **Token Limits & Budgets** → `03-token-strategies.md`

## Deep Analysis Protocol

When analyzing a complex system, trying to understand unfamiliar code, or feeling "confused", strictly follow this sequence:

1. **WHAT** — What specific question am I trying to answer?
2. **WHERE** — Which 1-3 files contain the answer? (Check `patterns.md` Quick Index first)
3. **READ** — Read ONLY those specific files. Do not scan entire directories broadly.
4. **ANSWER** — Answer the specific question.
5. **NEXT** — What is the next specific question?

**ANTI-PATTERN**: Do not attempt to "understand the whole system" before taking action. Answer one question at a time.

## Rule Conflict Detection Checklist

When creating, editing, or following rules, verify:
- [ ] Are we redefining behavior that belongs in another file?
- [ ] If referencing another concept, are we using `→ see: {authoritative-file}` instead of copying the logic?
- [ ] Does this action violate a higher-priority rule?
