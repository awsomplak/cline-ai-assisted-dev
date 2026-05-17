# Project Scanner Rule

## Purpose
Provide a deterministic, framework-aware scanning protocol so that project analysis produces consistent, useful memory bank content regardless of which AI model is used. This rule defines **what** to scan; the `plan-creator` skill defines **when** to scan.

## Fingerprint Protocol

### Step 1: Detect Project Type
Scan the project root for these files **in order**. Stop at first match per category:

| Category | Detection Files | Result |
|----------|----------------|--------|
| Language | `package.json` | Node.js / JavaScript / TypeScript |
| Language | `composer.json` | PHP |
| Language | `pubspec.yaml` | Dart |
| Language | `Cargo.toml` | Rust |
| Language | `go.mod` | Go |
| Language | `requirements.txt`, `pyproject.toml`, `setup.py` | Python |
| Language | `Gemfile` | Ruby |
| Language | `pom.xml`, `build.gradle` | Java / Kotlin |
| Language | `*.csproj`, `*.sln` | C# / .NET |
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
| Monorepo | `pnpm-workspace.yaml` | pnpm Workspaces |
| Monorepo | `lerna.json` | Lerna |
| Monorepo | `nx.json` | Nx |
| Monorepo | `turbo.json` | Turborepo |
| Test | `jest.config.*` | Jest |
| Test | `vitest.config.*` | Vitest |
| Test | `phpunit.xml` | PHPUnit |
| Test | `pytest.ini`, `conftest.py` | Pytest |
| Test | `*.test.dart`, `test/` with pubspec | Flutter Test |
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

### Step 3: Write Findings
Write scan results to `./.ai/memory-bank/patterns.md` using this format:

```markdown
## Architecture
- Project type: {language} / {framework}
- Architecture pattern: {MVC / Clean / Feature-based / Monorepo / etc.}
- Key directories: {list 5-8 most important paths}
- Entry point: {main file or command}

## Dependencies
- {top 5 non-standard dependencies with one-line purpose}

## Testing
- Framework: {name}
- Test location: {path}
- Run command: {command}
```

## Constraints
- Never scan `node_modules/`, `vendor/`, `build/`, `dist/`, `.git/`, or other dependency/output directories
- Limit scan depth to 3 levels from project root for initial discovery
- If project type cannot be determined, mark as "Unknown" and ask the user
- Do not execute any commands during scanning — read files only
