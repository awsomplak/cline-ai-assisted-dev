# Changelog

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