# Cline Rules - AI-Assisted Development System by AWLab-ID

A comprehensive rules, workflows, and skills system for Cline that provides structured plan management, persistent project memory, and phase-by-phase implementation control without extra tools or plugins.

## Overview

This system transforms Cline into a project-aware development assistant that:
- Remembers your project architecture across sessions via a Memory Bank
- Plans work in structured, UUID-tracked artifacts before writing code
- Executes implementations one phase at a time with explicit user confirmation
- Saves tokens through lazy loading, registry-based discovery, and minimal file operations

## Directory Structure

### Global Rules (per-machine)

```markdown
~/Documents/Cline/Rules/
├── README.md
├── 01-memory-bank.md
├── 02-plan-artifacts.md
├── 03-token-strategies.md
├── 04-commands.md
└── workflows/
├── create-plan.md
├── switch-plan.md
├── plan-status.md
└── update-memory.md
```

### Global Skills (per-machine)

```markdown
~/.agents/skills/plan-creator/
└── SKILL.md
```

### Per-Project Generated Structure

```markdown
{project-root}/.ai/
├── memory-bank/
│ ├── brief.md
│ ├── context.md
│ ├── patterns.md
│ └── progress.md
└── artifacts/
├── registry.md
└── {uuid}/
├── plan.md
├── tasks.md
└── notes.md
```

## Installation

### 1. Set Up Global Rules

**macOS/Linux**:
```bash
mkdir -p ~/Documents/Cline/Rules/workflows
cp 01-memory-bank.md ~/Documents/Cline/Rules/
cp 02-plan-artifacts.md ~/Documents/Cline/Rules/
cp 03-token-strategies.md ~/Documents/Cline/Rules/
cp 04-commands.md ~/Documents/Cline/Rules/
cp workflows/*.md ~/Documents/Cline/Rules/workflows/
```

**Windows**:
```powershell
mkdir -p $env:USERPROFILE\Documents\Cline\Rules\workflows
Copy-Item 01-memory-bank.md -Destination $env:USERPROFILE\Documents\Cline\Rules\
Copy-Item 02-plan-artifacts.md -Destination $env:USERPROFILE\Documents\Cline\Rules\
Copy-Item 03-token-strategies.md -Destination $env:USERPROFILE\Documents\Cline\Rules\
Copy-Item 04-commands.md -Destination $env:USERPROFILE\Documents\Cline\Rules\
Copy-Item workflows\*.md -Destination $env:USERPROFILE\Documents\Cline\Rules\workflows\
```

### 2. Set Up Global Skill

```bash
mkdir -p ~/.agents/skills/plan-creator
cp SKILL.md ~/.agents/skills/plan-creator/
```

### 3. Verify in Cline

- Open Cline in IDE (VS Code, Jetbrains, etc)
- Click the Rules icon (near chat input) to confirm all 4 rule files appear and are toggled ON
- Skills load automatically when a matching task is detected

## Usage

### Starting a Session

```text
follow rules
```

This loads the active plan from the current project's registry and relevant memory bank files.

### Creating a Plan

```text
create a plan for {your feature}
```

Or use the workflow directly:

```text
/create-plan
```

This will:
1. Create `.ai/` directory structure if missing
2. Scan your project and auto-populate memory-bank files
3. Generate a UUID-tracked plan with phase-organized tasks
4. Open all generated files in your editor
5. Stop - no code is executed

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

The system will:
1. Execute only the current phase's tasks
2. Mark tasks `[x]` as they complete
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

## Commands Reference

`follow rules` - Load active plan and memory bank
`/create-plan` - Generate new plan artifacts
`/plan-status` - Show registry with active plan
`/switch-plan` {uuid} - Activate a different plan
`/update-memory` - Sync memory bank with project state

## Task Format

Tasks are organized by phases:

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

- Lazy loading: Memory files loaded on-demand, not at startup
- Registry parsing: Table-based discovery instead of directory scanning
- Short filenames: `brief.md` over `projectBrief.md`
- Compact formats: Markdown tables over verbose lists
- Context monitoring: Suggests fresh session at \~70% capacity

## Requirements

- Cline extension (VS Code or Jetbrains)
- Compatible AI model with tool-calling support (Claude 3.5 Sonnet recommended, or local models like qwen2.5-coder:14b via Ollama)

## License

MIT - Use, modify, and share freely.
