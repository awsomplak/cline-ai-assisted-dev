# Changelog

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