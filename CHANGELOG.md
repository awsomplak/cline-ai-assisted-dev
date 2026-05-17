# Changelog

## [2.0.0] - 2026-05-17

### Added

- **Smart Project Fingerprinting** (`06-project-scanner.md`) — deterministic detection tables for 30+ languages, frameworks, mobile platforms, monorepo tools, test frameworks, and CI/CD systems. Framework-aware scan targets eliminate wasted token budget on irrelevant directories.
- **Context Budget System** — turn-counting proxy (15/25/30 checkpoints) replaces unmeasurable "~70% capacity" heuristic. File-size budgets (30-80 lines per memory file) and Memory Compression Protocol prevent bloat.
- **Plan Templates** — 6 pre-built plan skeletons (`feature-crud`, `auth-flow`, `migration`, `refactor`, `bugfix`, `integration`) with keyword-based auto-matching in the plan-creator skill.
- **Task Dependencies** — `→ depends: Task N` syntax for execution ordering and `? if: condition` syntax for conditional tasks.
- **Decision Log** (`decisions.md`) — architectural decision log with Date/Decision/Alternatives/Rationale table format. 20-row cap with archive. Lazy-loaded.
- **Verification Protocol** — Auto-Verify Checklist, 4 verification levels (`[x]`, `[x✓]`, `[x!]`, `[!]`), and Phase Gate quality checks before phase completion.
- **Multi-Tool Portability** — adapter guides for Cursor, Windsurf, and GitHub Copilot in `Cline/portability/`.
- **Task failure handling** — `[!]` marker with immediate STOP and user prompt (Phase Execution Rule #6).
- **`[—]` skipped marker** — for conditional tasks that don't apply.
- **`start phase {N}` command** — explicit command for phase execution.
- **Install scripts** — `install.sh` (macOS/Linux) and `install.ps1` (Windows) for one-command installation. Idempotent, colored output, `--uninstall` / `-Uninstall` flag for cleanup.
- **Output Capture Workaround** (`05-environment.md`) — prevents blank command output in Cline by banning `Format-Table`/`Format-List`, requiring `Out-String` for long pipelines, and providing file-based fallback capture.

### Changed

- **Registry Integrity** — rewritten to clarify that automated rule/workflow/skill changes are expected; only manual ad-hoc edits discouraged.
- **Command Validation Protocol** (`05-environment.md`) — consolidated from 27 lines to 8 lines by removing duplicate ❌ examples that overlapped with Anti-Patterns section. Net reduction: 154 → 133 lines.
- **Shell Mismatch Recovery** — merged "Mid-Session Shell Change Detection" and "Update Trigger" into single section.
- **SKILL.md** — Steps 1, 3 compressed; Step 4 upgraded with scanner reference; Step 7 upgraded with template matching.
- **switch-plan.md** — lazy-loads `tasks.md` only; `plan.md` on-demand.
- **update-memory.md** — checklist now includes `environment.md` and `decisions.md`.
- **plan-status.md** — shows task marker legend in output (all 5 non-pending markers).
- **Phase Execution Rule #7** — `[x!]` (completed with warnings) now accepted for plan completion with acknowledgment gate: AI displays warnings summary, asks user to confirm.
- **README** — Quick Install section with scripts (recommended); manual commands in `<details>` fallback. Directory tree includes `install.sh`/`install.ps1`. Portability section clarifies guides are reference-only.

### Fixed

- Stale `/create-plan` reference in `plan-status.md` → now `create plan` (skill trigger).
- Duplicated `$?` in Bash exit code row → `$?` and `${PIPESTATUS[@]}`.
- Duplicate "This will:" text in README.md.
- Missing `start phase {N}` in Session Commands table.
- Missing orphan handling when `tasks.md` doesn't exist for active plan.
- Stale cross-reference `Context Management` → `Context Budget` in `04-commands.md`.
- Ambiguous `./templates/` path in SKILL.md → `this skill's templates/ directory`.
- Missing `[x!]` marker in `plan-status.md` legend and README inline marker list.
- README installation section missing template directory copy commands.
- README section numbering jump from `### 1.` to `### 3.` → fixed to sequential.

## [1.0.2] - 2026-05-17

### Added

- **Environment Detection Rule** (`Cline/Rules/05-environment.md`) — definitive authority on OS/shell detection before any command execution. Includes detection procedure, shell command translation table, anti-patterns by shell, and mid-session shell change detection.
- **`plan-creator/SKILL.md` improvements** — stronger activation triggers, clearer phase execution reference, and better task generation examples.
- **`.gitignore`** — excludes `.ai/` and `scripts/` directories from version control.
- **`update-memory.md` enhancements** — better structure for memory bank sync workflow.

### Changed

- **Memory bank rules** (`01-memory-bank.md`) — clarified auto-setup (directories only, no content population), refined lazy loading strategy, stricter security constraints on path traversal and secret copying.
- **Plan artifacts rules** (`02-plan-artifacts.md`) — registry integrity section added, external modification detection, orphan detection protocol.
- **Token strategies** (`03-token-strategies.md`) — stronger lazy-loading rules, context window monitoring thresholds, anti-patterns clarified.
- **Command reference** (`04-commands.md`) — updated to reference the new environment detection rule, clarified session commands.
- **README** — updated to reflect new files and environment detection capabilities.

## [1.0.1] - 2026-05-16

### Optimized

- **Removed `workflows/create-plan.md`** – its content was identical to `plan-creator/SKILL.md`, causing redundancy and potential confusion. Plan creation now exclusively uses the skill.
- **Centralized Phase Execution Rules** – now defined only in `Rules/02-plan-artifacts.md`. The skill and other workflows reference that single source.
- **Clarified `follow rules`** – loads only the active plan’s `tasks.md` at session start; memory bank files are loaded on-demand for maximum token savings.
- **Security constraints** added to `01-memory-bank.md`: path traversal prevention, no secret copying, content treated as data.
- **Stronger skill triggers** in `plan-creator/SKILL.md` to prevent false activations (e.g., from questions about plans).
- **Updated command mappings** in `04-commands.md`: `create plan` now directly activates the skill; removed `/create-plan` workflow entry.
- **Token strategies** refined: registry caching, avoidance of empty `notes.md`, explicit lazy-loading rules.
- **Directory structure** clarified: Rules and Workflows are now separate directories for easier installation and maintenance.
- **Documentation** (README) fully updated to reflect all changes.

## [1.0.0] - 2026-05-15

- Initial release with plan management, memory bank, phase‑by‑phase execution, and token saving strategies.
