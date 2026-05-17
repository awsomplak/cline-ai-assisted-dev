# Cline Rules - AI-Assisted Development System by AWLab-ID

A comprehensive rules, workflows, and skills system for Cline that provides structured plan management, persistent project memory, and phase-by-phase implementation control without extra tools or plugins.

## Overview

This system transforms Cline into a project-aware development assistant that:
- Remembers your project architecture across sessions via a Memory Bank
- Plans work in structured, UUID-tracked artifacts before writing code
- Executes implementations one phase at a time with explicit user confirmation
- Saves tokens through lazy loading, registry-based discovery, and minimal file operations

## Directory Structure

### Repository Layout

```markdown
cline-ai-assisted-dev/
├── .agents/
│   └── skills/
│       └── plan-creator/
│           └── SKILL.md
├── Cline/
│   ├── Rules/
│   │   ├── 01-memory-bank.md
│   │   ├── 02-plan-artifacts.md
│   │   ├── 03-token-strategies.md
│   │   ├── 04-commands.md
│   │   └── 05-environment.md
│   └── Workflows/
│       ├── plan-status.md
│       ├── switch-plan.md
│       └── update-memory.md
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### Installed Paths (per-machine)

**Global Rules:**

```markdown
~/Documents/Cline/Rules/
├── 01-memory-bank.md
├── 02-plan-artifacts.md
├── 03-token-strategies.md
├── 04-commands.md
└── 05-environment.md
```

**Global Workflows:**

```markdown
~/Documents/Cline/Workflows/
├── plan-status.md
├── switch-plan.md
└── update-memory.md
```

**Global Skills:**

```markdown
~/.agents/skills/plan-creator/
└── SKILL.md
```

### Per-Project Generated Structure

```markdown
{project-root}/.ai/
├── memory-bank/
│   ├── brief.md
│   ├── context.md
│   ├── patterns.md
│   └── progress.md
└── artifacts/
    ├── registry.md
    └── {uuid}/
        ├── plan.md
        ├── tasks.md
        └── notes.md
```

## Installation

### 1. Set Up Global Skill, Rules & Workflows

**macOS/Linux**:
```bash
# Skill
mkdir -p ~/.agents/skills/plan-creator
cp .agents/skills/plan-creator/SKILL.md ~/.agents/skills/plan-creator/

# Rules
mkdir -p ~/Documents/Cline/Rules
cp Cline/Rules/*.md ~/Documents/Cline/Rules/

# Workflows
mkdir -p ~/Documents/Cline/Workflows
cp Cline/Workflows/*.md ~/Documents/Cline/Workflows/
```

**Windows**:
```powershell
# Skill
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills\plan-creator"
Copy-Item -Path ".agents\skills\plan-creator\SKILL.md" -Destination "$env:USERPROFILE\.agents\skills\plan-creator\"

# Rules
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\Cline\Rules"
Copy-Item -Path "Cline\Rules\*.md" -Destination "$env:USERPROFILE\Documents\Cline\Rules\"

# Workflows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\Cline\Workflows"
Copy-Item -Path "Cline\Workflows\*.md" -Destination "$env:USERPROFILE\Documents\Cline\Workflows\"
```

### 3. Verify in Cline

- Open Cline in IDE (VS Code, JetBrains, etc.)
- Click the **Rules** icon (near the chat input) to confirm all 5 rule files (01–05) appear and are toggled **ON**
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

This will:
1. Create `.ai/` directory structure if missing
2. Scan your project and auto-populate memory-bank files
3. Generate a UUID-tracked plan with phase-organized tasks
4. Open all generated files in your editor
5. Stop - no code is executed

> **Note:** There is no separate `/create-plan` workflow file. The plan creation is handled entirely by the skill (`plan-creator`), following the rules in `02-plan-artifacts.md`.

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
2. Mark tasks `[x]` in real-time
3. Stop when the phase is done
4. Ask for confirmation before proceeding to the next phase
5. Update `progress.md` after each phase

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
| `follow rules`        | Load active plan’s `tasks.md`; on-demand memory loading |
| `create plan`         | Activate `plan-creator` skill to generate a new plan    |
| `/plan-status`        | Show registry with active plan highlighted              |
| `/switch-plan {uuid}` | Activate a different plan                               |
| `/update-memory`      | Sync memory bank with project state                     |

## Task Format

Tasks are organized by phases (see `02-plan-artifacts.md` for full specification):

```markdown
# Tasks

## Phase 1: Set up authentication

- [ ] Create User model
- [ ] Add login endpoint
- [ ] Write auth tests

## Phase 2: Build dashboard

- [ ] Create dashboard controller
- [ ] Add charts component
- [ ] Write dashboard tests
```

## Token Saving Strategies

- **Lazy loading:** Memory files loaded on-demand, not at startup
- **Registry parsing:** Table-based discovery instead of directory scanning
- **Short filenames:** `brief.md` over `projectBrief.md`
- **Compact formats:** Markdown tables over verbose lists
- **No optional files unless needed:** `notes.md` created only when constraints/risks exist.
- **Context monitoring:** Suggests fresh session at \~70% capacity
- **Single source of truth:** Phase execution rules defined once in `02-plan-artifacts.md`, referenced elsewhere.

## Requirements

- Cline extension (VS Code or Jetbrains)
- Compatible AI model with tool-calling support (Claude 3.5 Sonnet recommended, or local models like qwen2.5-coder:14b via Ollama)

## License

MIT - Use, modify, and share freely.
