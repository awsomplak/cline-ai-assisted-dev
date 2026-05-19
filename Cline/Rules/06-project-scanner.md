<!-- → authority: 00-meta.md -->
# Project Scanner Rule

## Purpose
Provide a deterministic, framework-aware scanning protocol so that project analysis produces consistent, useful memory bank content regardless of which AI model is used. This rule defines **what** to scan; the `plan-creator` skill defines **when** to scan.

## Fingerprint Protocol

### Scan Caching Protocol (Dynamic Zero-I/O Planning)
Before performing a full codebase scan to detect project types and dependencies:
1. **Check Cache**: Verify `./.ai/memory-bank/patterns.md` exists and contains a populated `## Architecture` section.
2. **Dynamic Invalidation**: Do **not** rely on a static 14-day clock (active codebases change daily, leading to stale memory and broken import hallucinations). Instead, invalidate the cache and run a new scan ONLY if:
   - **Git indicates changes**: Running `git status --porcelain` reveals changes in main directories (e.g. `src/`, `lib/`, `app/`). *Fallback: If git command fails or is not a git repository, silently ignore this check.*
   - **Config files modified**: Key configuration files (e.g., `package.json`, `composer.json`, `Cargo.toml`, `go.mod`, `pubspec.yaml`) are newer than `patterns.md`.
     - *PowerShell (Windows)*: `Get-ChildItem package.json, composer.json, Cargo.toml -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt (Get-Item ./.ai/memory-bank/patterns.md).LastWriteTime }`
     - *Bash (Unix)*: `[ package.json -nt ./.ai/memory-bank/patterns.md ] || [ composer.json -nt ./.ai/memory-bank/patterns.md ]`
   - **Safety Expiry**: The `patterns.md` file is older than **24 hours** (run dynamic checks or re-detect).
3. **Bypass Scan**: If none of the invalidation criteria are met, silently bypass Steps 1 and 2, reuse the cached structure/dependencies immediately, saving up to 50% on planning tokens and increasing interaction speed.

### Step 1: Detect Project Type
Scan the project root for these files **in order**. Stop at first match per category:

| Category | Detection Files | Result |
|----------|----------------|--------|
| Monorepo | `pnpm-workspace.yaml` | pnpm Workspaces |
| Monorepo | `lerna.json` | Lerna |
| Monorepo | `nx.json` | Nx |
| Monorepo | `turbo.json` | Turborepo |
| Framework | `next.config.*` | Next.js |
| Framework | `nuxt.config.*` | Nuxt |
| Framework | `angular.json` | Angular |
| Framework | `vite.config.*` | Vite |
| Framework | `artisan` | Laravel |
| Framework | `manage.py` | Django |
| Framework | `astro.config.*` | Astro |
| Mobile | `pubspec.yaml` + `android/` + `ios/` | Flutter |
| Mobile | `react-native.config.js` or `app.json` + `android/` | React Native |
| Mobile | `capacitor.config.ts` | Capacitor |
| Language | `package.json` | Node.js / JavaScript / TypeScript |
| Language | `composer.json` | PHP |
| Language | `pubspec.yaml` | Dart |
| Language | `Cargo.toml` | Rust |
| Language | `go.mod` | Go |
| Language | `requirements.txt`, `pyproject.toml`, `setup.py` | Python |
| Language | `Gemfile` | Ruby |
| Language | `pom.xml`, `build.gradle` | Java / Kotlin |
| Language | `*.csproj`, `*.sln` | C# / .NET |
| Test | `jest.config.*` | Jest |
| Test | `vitest.config.*` | Vitest |
| Test | `phpunit.xml` | PHPUnit |
| Test | `pytest.ini`, `conftest.py` | Pytest |
| Test | `*.test.dart`, `test/` | Flutter Test |
| CI/CD | `.github/workflows/` | GitHub Actions |
| CI/CD | `.gitlab-ci.yml` | GitLab CI |
| CI/CD | `Jenkinsfile` | Jenkins |
| CI/CD | `.circleci/` | CircleCI |

### Step 2: Determine Scan Targets
Based on detected framework, scan **only** these directories (not the entire project):

| Framework | Scan Targets |
|-----------|-------------|
| Laravel | `app/Models/`, `app/Http/Controllers/`, `routes/`, `database/migrations/`, `config/` |
| Django | `*/models.py`, `*/views.py`, `*/urls.py`, `*/serializers.py` |
| Next.js | `app/` or `pages/`, `components/`, `lib/`, `api/` |
| Nuxt | `pages/`, `components/`, `composables/`, `server/` |
| Angular | `src/app/`, `src/environments/` |
| Vite/React | `src/`, `components/`, `hooks/`, `lib/` |
| Flutter | `lib/models/`, `lib/screens/` or `lib/pages/`, `lib/providers/` or `lib/bloc/`, `lib/services/` |
| React Native | `src/`, `screens/`, `components/`, `navigation/` |
| Generic | `src/`, `lib/`, `config/`, `test/` |

**Anti-Explosion Constraint**:
- **Check if the target directory exists before scanning.** If it does not exist, silently ignore it.
- Do NOT perform bulk `view_file` operations on all files in these targets. Reading all files will explode the context window.
- Use `list_dir` to view directory structures.
- Use `view_file` ONLY on the primary entry point (e.g. `package.json`, `index.js`, `routes/web.php`) or when searching for a specific pattern.

**Relationship Detection**:
After identifying the target directories, detect inter-file relationships:
1. Read the top 20 lines (imports/requires/uses) of the entry point (e.g., `package.json`, `index.js`, or `routes.php`). **Max 3 files total.** Do not bulk-read all models or controllers.
2. **Do not** read the full file contents for relationship detection.
3. These relationships will be written to `patterns.md` in Step 3.

### Step 3: Write Findings
Write scan results to `./.ai/memory-bank/patterns.md` using this format:

```markdown
## Architecture
- Project type: {language} / {framework}
- Architecture pattern: {MVC / Clean / Feature-based / Monorepo / etc.}
- Key directories: {list 5-8 most important paths}
- Entry point: {main file or command}
- Last scanned: YYYY-MM-DD

## Dependencies
- {top 5 non-standard dependencies with one-line purpose}

## Testing
- Framework: {name}
- Test location: {path}
- Run command: {command}

## Key Relationships
- {FileA} → depends on → {FileB}
*(Max 15 entries, prioritizing highest-connection core files)*

## Quick Index
- authentication: {e.g., app/Http/Middleware/Auth.php}
- routing: {e.g., routes/web.php}
- state management: {e.g., lib/providers/}
- {other core concept}: {file_path}
*(Max 20 entries of core project concepts mapped to specific file paths)*
```

### Step 4: Quick Index Protocol
Before reading project files to understand a concept, **check the Quick Index in `patterns.md` first**. If the concept is listed, go directly to that specific path instead of scanning directories broadly.

## Constraints
- Never scan `node_modules/`, `vendor/`, `build/`, `dist/`, `.git/`, or other dependency/output directories
- Limit scan depth to 3 levels from project root for initial discovery
- If project type cannot be determined, mark as "Unknown" and ask the user
- Do not execute any commands during scanning — read files only
