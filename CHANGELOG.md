# Changelog

## [2.0.3] - 2026-05-19

### Added
- **High-Speed Cloud Model Routing** (`07-model-router.md`) — Introduced dedicated awareness and optimization guidelines for high-speed cloud models (e.g. Gemini 3 Pro/Flash, GPT-4o-mini, Claude 3.5 Haiku, DeepSeek v4 Pro/Flash, and etc.), authorizing them to handle complex scopes eagerly while strictly maintaining native tool priority for maximum performance.
- **Archived Plans Visibility** (`plan-status.md`) — Added support to parse and display the total count of completed plans located in the archive table, preventing user confusion about deleted plans.

### Fixed
- **Registry Archive Overwriting** (`02-plan-artifacts.md`) — Updated the archiving protocol to overwrite existing plan records in the archive instead of filtering them as duplicates, preserving the latest completion summaries and timestamps for re-opened plans.
- **Dependency Deadlock Protections** (`02-plan-artifacts.md`) — Mandated that `→ depends: {exact task name}` must exactly match the name of another task in the same plan, preventing the agent from stalling on conceptual or unwritten dependencies.
- **Dual-Active Plan Paradox Resolved** (`02-plan-artifacts.md`) — Enforced that the active plan must be paused (`⏸️`) before reactivating a completed plan (`✅`) to `⏹️` due to a bug report, maintaining the single-active-plan constraint.
- **Archive Plan Restoration** (`switch-plan.md`) — Added a rule to restore archived plans back into the active registry (`registry.md`) and remove them from the archive (`registry_archive.md`) when switched back to active.
- **Unified Cache Thresholds** (`01-memory-bank.md`, `04-commands.md`, `05-environment.md`, `update-memory.md`) — Synchronized the environment check stale threshold to exactly 30 days across all rules, reference tables, and workflows (upgraded from 14 days).
- **Git Scanner Vulnerability Protection** (`06-project-scanner.md`) — Added silent command fallbacks when running Git operations, preventing shell crashes or infinite recovery loops in non-git repositories or fresh folders.
- **Scaffolding Registry Write Exception** (`02-plan-artifacts.md`) — Whitelisted `./.ai/artifacts/registry.md` as an exception in the Target Path Lock, permitting the plan-creator skill to register plans while maintaining robust path-traversal security.
- **Recovery Scaffolding Confirmations** (`SKILL.md`) — Expanded the plan-creator's strict trigger keywords to recognize standard recovery affirmations like `"yes"`, `"scaffold"`, and `"yes, scaffold"`, allowing seamless scaffolding initialization during recovery.

## [2.0.2] - 2026-05-19

### Fixed
- **Oversimplification Bugs Resolved** (`02-plan-artifacts.md`) — Reinstated critical instructional sub-bullets, execution steps, and markdown templates that were accidentally stripped, restoring the AI's ability to properly execute phases and format registry files.
- **Infinite Loop Skip Trap** (`02-plan-artifacts.md`) — Introduced the `[⏳]` (Deferred) marker to differentiate tasks skipped due to unmet dependencies from those permanently skipped (`[—]`), preventing infinite re-evaluation loops.
- **Dependency Cascade Fallback** (`02-plan-artifacts.md`) — Added a safety net to halt execution if a circular or future-phase dependency is encountered, preventing infinite looping at the end of a phase.
- **Dynamic Loading Budget Safety** (`01-memory-bank.md`) — Added a budget constraint note forcing the AI to prioritize files and defer loading when pre-load heuristics exceed the turn file budget limits.
- **Native Tool Priority Exception** (`07-model-router.md`) — Explicitly whitelisted PowerShell `New-TimeSpan` and Unix `date +%s` math under the native tool priority rule, resolving the paradox where the AI refused to run required file age checks.

## [2.0.1] - 2026-05-18

### Added
- **System Authority Framework** (`00-meta.md`) — establishes a strict hierarchy for resolving conflicts between rules and workflows. All rules now declare their authority.
- **Model Router** (`07-model-router.md`) — auto-classifies tasks as Simple (🟢), Medium (🟡), or Complex (🔴), enabling dynamic escalation for local LLM routing and token awareness.
- **Model-Adaptive Loading Modes** (`01-memory-bank.md`) — dynamic toggling between Compact (≤16K), Standard (16K-128K), and Full (≥128K) modes to prevent context window explosion on smaller models.
- **Quick Index & Relationship Detection** (`06-project-scanner.md`) — scanner now pre-maps core concepts and relationships by reading only the first 20 lines of imports, completely avoiding bulk `view_file` context explosions.
- **Cross-Session Learning Workflow** (`retrospective.md`) — triggered after a plan successfully completes, extracting reusable architectures and auto-updating plan templates with YAML metadata (`success_count`).
- **Case-Insensitive Lowercase UUIDs** (`02-plan-artifacts.md`, `SKILL.md`) — all plan UUIDs are now strictly generated as lowercase alphanumeric (`[a-z0-9]{8}`). This prevents case-insensitive filesystem collisions on Windows/macOS and simplifies developer CLI interaction.
- **Strict Linear Phase checklists** (`02-plan-artifacts.md`) — streamlined task checklists to enforce sequential execution inside phases. This removes complex non-linear topological sorting overhead and resolves potential "Dependency Cascade Failures" in complex plans.
- **Native IDE Tool Priority Protocol** (`07-model-router.md`) — mandates that agents prioritize native IDE/system tools (`view_file`, `replace_file_content`, `grep_search`, `write_to_file`) over raw terminal command scripts (`cat`, `sed`, `grep`, `echo`), accelerating file manipulation and avoiding terminal permission blocks.

### Changed
- **Task Status Update Bloat Fixed** (`02-plan-artifacts.md`) — explicitly allows batching of small, related task updates instead of saving `tasks.md` after every single checkbox, saving massive tokens.
- **Command Validation Silenced** (`05-environment.md`) — forces the command verification protocol to be executed silently in the AI's thought process rather than over-narrating in the chat window.
- **Dangling Token Thresholds Cleaned Up** (`04-commands.md`) — removed outdated context budget point threshold references from `summarize session`.
- **Install Scripts Upgraded** (`install.ps1`, `install.sh`) — updated headers to v2.0.1 and bumped verification check counts to 8 rules (`00-07`).
- **Plan Templates Documentation Added** (`README.md`) — resolved a documentation gap by adding a detailed **Plan Templates** section, describing all six pre-built skeletons and how keyword-matching operates in the `plan-creator` skill.

### Fixed
- **Hallucination Vectors Closed** — explicitly added fallback prompts to `brief.md` and `context.md` in `01-memory-bank.md` to prevent hallucinating content when projects lack a README.
- **Workflow Turn-Yielding Enforced** (`SKILL.md`, `retrospective.md`) — added rigid `STOP AND WAIT` directives after plan creation and retrospective requests, eliminating hallucinated user responses.
- **Circular Dependency Deadlock** (`02-plan-artifacts.md`) — added an explicit fallback for when tasks skip endlessly due to unmet `→ depends:` chains, and allowed skipped conditional tasks `[—]` to count as satisfied prerequisites.
- **Out-of-Order Dependency Loops Resolved** (`02-plan-artifacts.md`) — mandated that agents loop back and re-evaluate skipped tasks within a phase once their dependencies are met, preventing premature phase exits.
- **Task Failure Skip Trap Avoided** (`02-plan-artifacts.md`) — instructed agents to change failed tasks `[!]` to `[—]` if skipped, preventing blockers during final verification.
- **Template Path Ambiguity** (`SKILL.md`) — hardcoded the fallback global/local path structure for resolving templates to prevent agent looping.
- **Lazy-Load Table Protection** (`update-memory.md`) — added strict warning to read `decisions.md` before appending to protect markdown table formatting from corruption.
- **Bash Empty-Operand Age Check Crash** (`01-memory-bank.md`) — resolved the macOS/Linux age check syntax error when `environment.md` is missing on fresh workspaces (added robust fallback `|| echo 0` and file-existence check).
- **PowerShell File-Not-Found Exception** (`01-memory-bank.md`) — wrapped the Windows environment check in `Test-Path` to prevent terminating shell errors on uninitialized clean projects.
- **Git Branch Desynchronization Trap** (`.gitignore`) — adjusted `.gitignore` to allow committing planning documents, decisions, and patterns. This enables team collaboration and branch-synchronized memory states, eliminating architectural hallucinations on branch changes while maintaining machine-specific local privacy (`environment.md` and temporary command streams are still ignored).
- **Retrospective Turn-Yield Memory Loss** (`retrospective.md`) — fixed a state-machine loophole where blank AI agents lose their state after yielding the turn for feedback. Introduced a transition status `🔄` (Review/Retrospective) in the plan registry to persist the review state across turns.

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
