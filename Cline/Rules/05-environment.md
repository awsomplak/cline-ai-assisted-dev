# Environment Detection Rule

## CRITICAL: Pre-Execution Verification

**Before ANY `execute_command` call, Cline MUST verify the environment is known.** This is non-negotiable and takes precedence over all other rules.

1. Check if environment is cached (session memory or in `./.ai/memory-bank/environment.md`)
2. If unknown, perform detection immediately:
   - Run detection procedure (see Detection & Storage below)
   - Write to `./.ai/memory-bank/environment.md`
   - Cache the result for the session
3. Only after environment is confirmed, generate the command using the correct shell syntax
4. If a command fails with `command not found` or `is not recognized`, treat it as potential shell mismatch:
   - Re-detect the environment
   - Ask the user if their shell has changed
   - Update `environment.md` accordingly

> **SINGLE SOURCE OF TRUTH:** This file is the definitive authority on environment detection and command generation.

## Purpose
Ensure all shell/terminal commands suggested or executed by Cline are compatible with the user's actual operating system and shell (e.g., PowerShell for Windows, Bash for Linux/macOS).

## Detection & Storage

1. **On every session start (when `follow rules` is invoked)**, check if `./.ai/memory-bank/environment.md` exists and is up-to-date:
   - If missing or older than 7 days, perform detection.
   - If present and recent, use the stored values without asking.

2. **Detection procedure (silent, no user confirmation)**:
   - Determine the operating system: Windows, macOS, or Linux.
   - Determine the active shell: For Windows, typically PowerShell (`pwsh` or `powershell`), Command Prompt (`cmd`), or Git Bash. For macOS/Linux, typically Bash or Zsh.
   - If the IDE is VS Code, you can infer the shell from the `terminal.integrated.defaultProfile` setting or by checking the running terminal name.
   - If you cannot detect the shell automatically, ask the user exactly once: *"I see you're on {OS}. Are you using PowerShell or Git Bash?"* Store the answer.

3. **Write to `./.ai/memory-bank/environment.md`** in the current project's memory bank (only if it doesn't exist or needs updating):
   ```markdown
   # Development Environment
   - Operating System: {detected_os}
   - Shell: {detected_shell}
   - Terminal: VS Code integrated terminal
   - Last detected: {current_timestamp}
   ```

4. **After detection, explicitly note to yourself (the AI) the environment** so you never issue an incompatible command.

## Command Generation Rules

- **Always** generate commands using the syntax of the stored shell.
- **Never** mix shell syntaxes. If the environment is PowerShell, do not suggest `ls`; use `Get-ChildItem`. If it's Bash, do not use `dir`.
- If a command would fail because of the environment (e.g., using Linux paths like `/home/user` on Windows), adapt it automatically (e.g., use `$env:USERPROFILE` on PowerShell).
- When in doubt, re-check `./.ai/memory-bank/environment.md` before running or suggesting any command.

### Shell Command Translation Table

Use this table to translate common operations between shells:

| Operation | PowerShell | Bash / Zsh |
|-----------|-----------|------------|
| List directory | `Get-ChildItem` or `dir` | `ls` |
| Change directory | `Set-Location` or `cd` | `cd` |
| Print working directory | `Get-Location` or `pwd` | `pwd` |
| Copy file | `Copy-Item src dest` | `cp src dest` |
| Move file | `Move-Item src dest` | `mv src dest` |
| Remove file | `Remove-Item file` | `rm file` |
| Remove directory (recursive) | `Remove-Item -Recurse -Force dir` | `rm -rf dir` |
| Create directory | `New-Item -ItemType Directory -Force -Path path` | `mkdir -p path` |
| Create empty file | `New-Item -ItemType File -Force -Path file` | `touch file` |
| Read file | `Get-Content file` | `cat file` |
| Write to file | `Set-Content -Path file -Value "text"` | `echo "text" > file` |
| Append to file | `Add-Content -Path file -Value "text"` | `echo "text" >> file` |
| Search in files | `Select-String -Path "*.js" -Pattern "pattern"` | `grep "pattern" *.js` |
| Environment variable | `$env:VARNAME` | `$VARNAME` |
| User home directory | `$env:USERPROFILE` | `$HOME` or `~` |
| Current user | `$env:USERNAME` | `$USER` |
| Sleep / wait | `Start-Sleep -Seconds N` | `sleep N` |
| Compare files | `Compare-Object (Get-Content a) (Get-Content b)` | `diff a b` |
| Find files | `Get-ChildItem -Recurse -Filter "*.js"` | `find . -name "*.js"` |
| Pipe to filter | `Where-Object {$_.Name -like "*test*"}` | `grep` pipes |
| Measure time | `Measure-Command { script }` | `time script` |
| Terminate process | `Stop-Process -Name name` | `kill PID` |
| Run executable with spaces in path | `& "C:\Program Files\app\app.exe"` | `"/path/to/app"` |

### Anti-Patterns by Shell

**On PowerShell, NEVER use:**
- `ls` (unless aliased, ambiguous on some systems)
- `cat` (works as alias but not universal)
- `mkdir -p` (PowerShell interprets `-p` differently)
- `rm -rf` (PowerShell uses different flags)
- `cp`, `mv` without proper flag matching
- `/home/user` or `~/` paths without translation
- `touch` (not a native PowerShell command)
- `grep` (not a native PowerShell command)
- `\` for line continuation in scripts (use backtick `` ` ``)

**On Bash/Zsh, NEVER use:**
- `dir` (though often aliased on some systems)
- `Get-ChildItem` (PowerShell cmdlet)
- `New-Item` (PowerShell cmdlet)
- `$env:` prefix for variables
- `Copy-Item` (PowerShell cmdlet)

## Mid-Session Shell Change Detection

- If a command fails with `command not found` or `is not recognized`:
  - Immediately recognize a potential shell mismatch
  - Ask the user: *"I got a '{error}'. Has your shell/environment changed?"*
  - If confirmed, re-run detection and update `environment.md`
  - Retry the command with corrected syntax

## Update Trigger

- If the user manually overrides a command with a different shell syntax, ask if their environment has changed and update `environment.md` accordingly.
- If a command fails with `command not found` or `is not recognized` error, immediately recognize the shell mismatch, ask the user to confirm the correct shell, and update `environment.md`.