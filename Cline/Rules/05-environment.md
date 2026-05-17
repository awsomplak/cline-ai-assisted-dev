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

## Command Validation Protocol (MANDATORY)

**Before every `execute_command` call:**

1. **Read stored shell** from `./.ai/memory-bank/environment.md`.
2. **Scan the command** against the **Anti-Patterns by Shell** section below. If any anti-pattern matches, STOP and translate using the **Translation Table** before executing.
3. **If uncertain**, look up the operation in the Translation Table.
4. **Only after validation passes**, execute the command.

> **FAILURE MODE:** If you skip validation and the command fails, treat it as a bug in your own process. Re-validate, translate, and retry.

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
| Copy item | `Copy-Item src dest` | `cp src dest` |
| Move item | `Move-Item src dest` | `mv src dest` |
| Remove file | `Remove-Item file` | `rm file` |
| Remove directory (recursive) | `Remove-Item -Recurse -Force dir` | `rm -rf dir` |
| Create directory | `New-Item -ItemType Directory -Force -Path path` | `mkdir -p path` |
| Create empty file | `New-Item -ItemType File -Force -Path file` | `touch file` |
| Read file | `Get-Content file` | `cat file` |
| Write to file | `Set-Content -Path file -Value "text"` | `echo "text" > file` |
| Append to file | `Add-Content -Path file -Value "text"` | `echo "text" >> file` |
| Search in files (regex) | `Select-String -Path "*.js" -Pattern "regex"` | `grep "regex" *.js` |
| Environment variable (read) | `$env:VARNAME` | `$VARNAME` |
| User home directory | `$env:USERPROFILE` | `$HOME` or `~` |
| Current user | `$env:USERNAME` | `$USER` |
| Sleep / wait | `Start-Sleep -Seconds N` | `sleep N` |
| Compare files | `Compare-Object (Get-Content a) (Get-Content b)` | `diff a b` |
| Find files recursively | `Get-ChildItem -Recurse -Filter "*.js"` | `find . -name "*.js"` |
| Time measurement | `Measure-Command { script }` | `time script` |
| Terminate process by name | `Stop-Process -Name name` | `kill PID` |
| Run executable with spaces | `& "C:\Program Files\app\app.exe"` | `"/path/to/app"` |
| Command chaining (success) | `command1; if ($?) { command2 }` | `command1 && command2` |
| Command chaining (failure fallback) | `if ($LASTEXITCODE -ne 0) { fallback }` | `command1 || fallback` |
| Redirect stderr to stdout | `command 2>&1` or `command *>&1` | `command 2>&1` |
| Check if file exists | `Test-Path path` | `test -f path` or `[ -f path ]` |
| Check exit code | `$LASTEXITCODE` | `$?` or `${PIPESTATUS[@]}` |

### Anti-Patterns by Shell

**On PowerShell, NEVER use:**
- `ls` (unless aliased, ambiguous on some systems — prefer `Get-ChildItem` or `dir`)
- `cat` (works as alias but not universal — prefer `Get-Content`)
- `mkdir -p` (PowerShell interprets `-p` differently — use `New-Item -ItemType Directory -Force -Path`)
- `rm -rf` (PowerShell uses different flags — use `Remove-Item -Recurse -Force`)
- `cp`, `mv` without proper flag matching — use `Copy-Item`, `Move-Item`
- `/home/user` or `~/` paths without translation — use `$env:USERPROFILE`
- `$HOME` without translation — use `$env:USERPROFILE`
- `touch` (not a native PowerShell command — use `New-Item -ItemType File`)
- `grep` (not a native PowerShell command — use `Select-String`)
- `\` for line continuation (use backtick `` ` `` instead)
- `&&` for command chaining (use `if ($?) { ... }` instead)
- `||` for fallback (use `if ($LASTEXITCODE -ne 0) { ... }` instead)
- `command > /dev/null 2>&1` (use `command *>$null` or `command 2>$null`)
- `Format-Table`, `Format-List` (Cline can't capture their output — use `Select-Object` instead)

**On Bash/Zsh, NEVER use:**
- `dir` (though often aliased on some systems — use `ls`)
- `Get-ChildItem` (PowerShell cmdlet — use `ls`)
- `New-Item` (PowerShell cmdlet — use `touch` or `mkdir`)
- `Set-Content` (PowerShell cmdlet — use `echo "text" > file`)
- `Get-Content` (PowerShell cmdlet — use `cat`)
- `$env:` prefix for variables (use `$VARNAME` directly)
- `Copy-Item` (PowerShell cmdlet — use `cp`)
- `Remove-Item` (PowerShell cmdlet — use `rm`)
- `Select-String` (PowerShell cmdlet — use `grep`)

## Shell Mismatch Recovery

- If a command fails with `command not found` or `is not recognized`:
  1. Recognize a potential shell mismatch immediately
  2. Ask the user: *"I got '{error}'. Has your shell/environment changed?"*
  3. If confirmed, re-run detection and update `environment.md`
  4. Retry the command with corrected syntax
- If the user manually overrides a command with different shell syntax, ask if their environment has changed and update `environment.md` accordingly.

## Output Capture Workaround (PowerShell)

Cline's terminal integration sometimes fails to capture output from complex PowerShell pipelines (the command executes but returns blank). This typically happens with chained cmdlets like `Select-String | Where-Object | Format-Table`.

**Prevention rules (apply to ALL PowerShell commands):**

1. **Never use `Format-Table` or `Format-List`** in commands — these write formatting objects that Cline can't capture. Use `Select-Object` instead:
   - ❌ `Get-ChildItem | Format-Table Name, Length`
   - ✅ `Get-ChildItem | Select-Object Name, Length`

2. **Pipe long chains to `Out-String`** to force text output:
   - ❌ `Select-String -Pattern "foo" | Where-Object { $_.Line -match "bar" }`
   - ✅ `Select-String -Pattern "foo" | Where-Object { $_.Line -match "bar" } | Out-String`

3. **If output is still blank**, fall back to file-based capture:
   ```powershell
   # Write to temp file, then read it
   your-command | Out-File -FilePath ".ai/temp-output.txt" -Encoding utf8
   Get-Content ".ai/temp-output.txt"
   Remove-Item ".ai/temp-output.txt"
   ```

4. **Keep pipelines short** — prefer 2-3 stages max. Break complex queries into multiple simpler commands.