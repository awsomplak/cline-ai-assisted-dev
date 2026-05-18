# Cline Rules, Workflows, and Skills - AI-Assisted Development System by AWLab-ID

A comprehensive rules, workflows, and skills system for Cline that provides structured plan management, persistent project memory, and phase-by-phase implementation control without extra tools or plugins.

## Overview

This system transforms Cline into a project-aware development assistant that:
- Remembers your project architecture across sessions via a Memory Bank
- Plans work in structured, 8-char UUID-tracked artifacts before writing code
- Executes implementations one phase at a time with explicit user confirmation
- Saves tokens through lazy loading, registry-based discovery, and minimal file operations

## Directory Structure

### Repository Layout

```markdown
cline-ai-assisted-dev/
├── Cline/
│   ├── Rules/
│   │   ├── 00-meta.md
│   │   ├── 01-memory-bank.md
│   │   ├── 02-plan-artifacts.md
│   │   ├── 03-token-strategies.md
│   │   ├── 04-commands.md
│   │   ├── 05-environment.md
│   │   ├── 06-project-scanner.md
│   │   └── 07-model-router.md
│   ├── Skills/
│   │   └── plan-creator/
│   │       ├── SKILL.md
│   │       └── templates/
│   │           ├── feature-crud.md
│   │           ├── auth-flow.md
│   │           ├── migration.md
│   │           ├── refactor.md
│   │           ├── bugfix.md
│   │           └── integration.md
│   ├── Workflows/
│   │   ├── plan-status.md
│   │   ├── retrospective.md
│   │   ├── switch-plan.md
│   │   └── update-memory.md
│   └── portability/
│       ├── cursor-adapter.md
│       ├── windsurf-adapter.md
│       └── copilot-adapter.md
├── CHANGELOG.md
├── LICENSE
├── README.md
├── install.sh
└── install.ps1
```

### Installed Paths (per-machine)

**Global Rules:**

```markdown
~/Documents/Cline/Rules/
├── 00-meta.md
├── 01-memory-bank.md
├── 02-plan-artifacts.md
├── 03-token-strategies.md
├── 04-commands.md
├── 05-environment.md
├── 06-project-scanner.md
└── 07-model-router.md
```

**Global Workflows:**

```markdown
~/Documents/Cline/Workflows/
├── plan-status.md
├── retrospective.md
├── switch-plan.md
└── update-memory.md
```

**Global Skills:**

```markdown
~/.agents/skills/plan-creator/
├── SKILL.md
└── templates/
    ├── feature-crud.md
    ├── auth-flow.md
    ├── migration.md
    ├── refactor.md
    ├── bugfix.md
    └── integration.md
```

### Per-Project Generated Structure

```markdown
{project-root}/.ai/
├── memory-bank/
│   ├── environment.md
│   ├── brief.md
│   ├── context.md
│   ├── decisions.md
│   ├── patterns.md
│   └── progress.md
└── artifacts/
    ├── registry.md
    └── {8-char-uuid}/
        ├── plan.md
        ├── tasks.md
        └── notes.md
```

## Installation

### Quick Install (Recommended)

Use the included install scripts — they handle directory creation, file copying, and safe re-runs (existing files are replaced, directories preserved).

**macOS/Linux**:
```bash
chmod +x install.sh
./install.sh
```

**Windows** (PowerShell):
```powershell
.\install.ps1
```

To uninstall:
```bash
# macOS/Linux
./install.sh --uninstall
```
```powershell
# Windows
.\install.ps1 -Uninstall
```

### Manual Install

<details>
<summary>Click to expand manual commands</summary>

**macOS/Linux**:
```bash
# Skill + Templates
mkdir -p ~/.agents/skills/plan-creator
cp Cline/Skills/plan-creator/SKILL.md ~/.agents/skills/plan-creator/
cp -r Cline/Skills/plan-creator/templates ~/.agents/skills/plan-creator/

# Rules
mkdir -p ~/Documents/Cline/Rules
cp Cline/Rules/*.md ~/Documents/Cline/Rules/

# Workflows
mkdir -p ~/Documents/Cline/Workflows
cp Cline/Workflows/*.md ~/Documents/Cline/Workflows/
```

**Windows**:
```powershell
# Skill + Templates
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills\plan-creator"
Copy-Item -Path "Cline\Skills\plan-creator\SKILL.md" -Destination "$env:USERPROFILE\.agents\skills\plan-creator\"
Copy-Item -Path "Cline\Skills\plan-creator\templates" -Destination "$env:USERPROFILE\.agents\skills\plan-creator\templates" -Recurse -Force

# Rules
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\Cline\Rules"
Copy-Item -Path "Cline\Rules\*.md" -Destination "$env:USERPROFILE\Documents\Cline\Rules\"

# Workflows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\Cline\Workflows"
Copy-Item -Path "Cline\Workflows\*.md" -Destination "$env:USERPROFILE\Documents\Cline\Workflows\"
```

</details>

### 2. Verify in Cline

- Open Cline in IDE (VS Code, JetBrains, etc.)
- Click the **Rules** icon (near the chat input) to confirm all 8 rule files (00–07) appear and are toggled **ON**
- Workflows are automatically recognized when placed in the correct directory
- The `plan-creator` skill loads automatically when its trigger phrases are detected

## Usage

### Starting a Session

```text
follow rules
```

Loads the active plan from the current project's registry and (only) the active plan’s tasks.md. Memory bank files are loaded on-demand as needed.

### Creating a Plan

Use the natural language command (triggers the plan-creator skill):
```text
create a plan for {your feature}
```

Or simply say create plan. This will:
1. Create `.ai/` directory structure if missing
2. Detect your environment (OS, shell) automatically
3. Scan your project using the **Fingerprint Protocol** (`06-project-scanner.md`) and auto-populate memory-bank files
4. Match your request against **plan templates** (CRUD, auth, migration, refactor, bugfix, integration) for smarter generation
5. Generate a plan with 8-char randomized lowercase alphanumeric UUID and phase-organized tasks
6. Open all generated files in your editor
7. Stop - no code is executed

> **Note:** There is no separate `/create-plan` workflow file. The plan creation is handled entirely by the skill (`plan-creator`), following the rules in `02-plan-artifacts.md`.

### Plan Templates

To streamline plan generation and reduce input token overhead by **30-50%**, the `plan-creator` skill automatically matches your natural language request against six built-in plan templates:

*   📦 **Feature CRUD** (`feature-crud.md`): Used for database models, migrations, RESTful APIs/controllers, UI forms, list pagination, and basic resource management.
*   🔒 **Authentication Flow** (`auth-flow.md`): Used for registration/login controllers, password hashing, session/cookie handling, token-based verification, UI login screens, and secure route middleware.
*   🗄️ **Database Migration** (`migration.md`): Used for schema modifications, table creations, indices, foreign keys, rollback seeds, data integrity checks, and dry-run tests.
*   🛠️ **Code Refactor** (`refactor.md`): Used for addressing technical debt, improving code readability, modularization, applying design patterns, performance optimizations, and regression testing.
*   🐛 **Bug Fix** (`bugfix.md`): Used for diagnostics, reproducing errors, writing failing test assertions, resolving the root cause, and regression testing.
*   🔌 **Third-Party Integration** (`integration.md`): Used for external API integrations, SDK connections, webhook processing, mock service adapters, and secure credential handling.

The skill scans keywords in your prompt (e.g., `"add auth"`, `"fix error"`, `"create admin controller"`) to instantly load and pre-fill the corresponding skeleton structure.

### Checking Plan Status

```text
/plan-status
```

Displays all plans with the active one highlighted, plus task completion stats.

### Switching Plans

```text
/switch-plan {uuid}
```

Activates a different plan and loads its files.

### Implementing a Plan

```text
start phase 1
```

The system follows the Phase Execution Rules (centralized in `02-plan-artifacts.md`):

1. Execute only the current phase's tasks
2. Mark tasks with appropriate markers (`[x]`, `[x✓]`, `[x!]`, `[!]`, `[—]`, `[⏳]`) in real-time
3. Stop when the phase is done
4. Ask for confirmation before proceeding to the next phase
5. Update `progress.md` after each phase
6. Handle failures: mark `[!]`, stop, ask user
7. Verify all tasks resolved before marking plan complete

### Updating Project Memory

```text
/update-memory
```

Syncs memory-bank files with the current project state.

## Key Design Principles

### Registry-First Discovery

Never scan the `.ai/artifacts/` directory. Always parse `registry.md` to find plans. This saves tokens and prevents AI confusion.

### Phase-by-Phase Execution

Implementation is always done one phase at a time. The AI stops after completing a phase and requires explicit user confirmation before continuing.

### Auto-Populated Memory Bank

On first plan creation, the system scans your actual project files to populate `brief.md`, `context.md`, `patterns.md`, and `progress.md` with real data.

### No Unnecessary Confirmations

Directory creation, file generation, and file opening happen silently. Only asked: plan summary and next phase confirmation.

### Project Isolation

Each project maintains its own `.ai/` directory. Rules are global but operations are scoped to the current workspace root.

### Security by Default

- No file writes outside the project root (path traversal blocked)
- Secrets and API keys are never copied into memory bank files
- All .ai/ content is treated as data, not executable code

## Commands Reference

| **Command**           | **Action**                                              |
| --------------------- | ------------------------------------------------------- |
| `follow rules`        | Load active plan's `tasks.md`; on-demand memory loading |
| `create plan`         | Activate `plan-creator` skill to generate a new plan    |
| `/plan-status`        | Show registry with active plan highlighted              |
| `/switch-plan {uuid}` | Activate a different plan (8-character lowercase alphanumeric)   |
| `/retrospective`      | Extract reusable patterns and knowledge from a completed plan |
| `/update-memory`      | Sync memory bank with project state                     |
| `start phase {N}`     | Execute Phase N of the active plan                      |
| `summarize session`   | Save state to progress.md, prepare for context reset    |

## Task Format

Tasks are organized by phases (see `02-plan-artifacts.md` for full specification):

```markdown
# Tasks

## Phase 1: Set up authentication

- [ ] Create User model
- [ ] Add login endpoint
  → depends: Create User model
- [ ] Write auth tests
  → depends: Add login endpoint

## Phase 2: Build dashboard

- [ ] Create dashboard controller
- [ ] Add charts component
  ? if: patterns.md shows frontend framework
- [ ] Write dashboard tests
```

### Task Status Markers

| Marker | Meaning |
|--------|----------|
| `[ ]` | Pending |
| `[x]` | Completed and verified |
| `[x✓]` | Completed with test pass |
| `[x!]` | Completed but with warnings |
| `[!]` | Failed — requires user intervention |
| `[—]` | Permanently Skipped — conditional task that does not apply OR user-instructed skip |
| `[⏳]` | Deferred — dependencies not met (will be re-evaluated at phase end) |

## Multi-Model Support

The system implements a Model Router (`07-model-router.md`) that categorizes tasks by complexity:
- 🟢 **Simple** (single file, <50 lines) — suitable for local 1.5B–3B models.
- 🟡 **Medium** (2-5 files, dependencies) — suitable for local 14B–32B models.
- 🔴 **Complex** (architecture, 5+ files) — requires frontier models (Claude/GPT).

It includes Model-Adaptive Loading Modes (Compact, Standard, Full) based on context limits, preventing token overflow for smaller models.

## Token Saving Strategies

- **Lazy loading:** Memory files loaded on-demand, not at startup
- **Registry parsing:** Table-based discovery instead of directory scanning
- **Smart scanning:** Framework-aware `06-project-scanner.md` scans only relevant directories
- **Plan templates:** Pre-built skeletons save 30-50% of plan generation tokens
- **Context budget:** Turn-counting proxy (15/25/30 checkpoints) with automatic session management
- **File-size caps:** Memory files have max line limits to prevent bloat
- **Short filenames:** `brief.md` over `projectBrief.md`
- **Compact formats:** Markdown tables over verbose lists
- **No optional files unless needed:** `notes.md` created only when constraints/risks exist
- **Single source of truth:** Phase execution rules defined once in `02-plan-artifacts.md`, referenced elsewhere

## Portability

While designed for Cline, this system can be adapted for other AI coding tools:

| Tool | Adapter Guide |
|------|---------------|
| Cursor | `Cline/portability/cursor-adapter.md` |
| Windsurf | `Cline/portability/windsurf-adapter.md` |
| GitHub Copilot | `Cline/portability/copilot-adapter.md` |

> **Note:** Portability guides are reference documentation only — they stay in this repository and are **not** installed. Read the relevant guide when you want to migrate your rules to another tool.

The `.ai/` directory structure is tool-agnostic and works with any AI assistant that can read/write files.

## Requirements

- Cline extension (VS Code or Jetbrains)
- Compatible AI model with tool-calling support. Recommended pairings:
  - 🟢 Simple Tasks: Local models (e.g., qwen2.5-coder:3b)
  - 🟡 Medium Tasks: Local models (e.g., qwen2.5-coder:14b)
  - 🔴 Complex Tasks/Planning: Frontier models (Claude 3.5 Sonnet, GPT-4o)

## License

MIT - Use, modify, and share freely.
