# ============================================================================
# Cline Rules Installer — Windows (PowerShell)
# Idempotent: safe to run multiple times. Only replaces targeted files.
# ============================================================================

param(
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

# Resolve script directory (where this repo is cloned)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Target paths
$RulesDir     = Join-Path $env:USERPROFILE "Documents\Cline\Rules"
$WorkflowsDir = Join-Path $env:USERPROFILE "Documents\Cline\Workflows"
$SkillsDir    = Join-Path $env:USERPROFILE ".agents\skills\plan-creator"

# Source paths
$SrcRules     = Join-Path $ScriptDir "Cline\Rules"
$SrcWorkflows = Join-Path $ScriptDir "Cline\Workflows"
$SrcSkill     = Join-Path $ScriptDir "Cline\Skills\plan-creator"

# --- Version and Shell Detection ---
$PSVersion = $PSVersionTable.PSVersion
$IsCore = $PSVersion.Major -ge 6
$ShellType = if ($IsCore) { "PowerShell Core (v$PSVersion)" } else { "Windows PowerShell (v$PSVersion)" }
$FeatureSupport = if ($IsCore) { "Full (supports && and ||)" } else { "Standard (uses conditional checks)" }

# --- Header ---
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   Cline Rules v2.0.2 — Installer             ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "    Detected Shell:  $ShellType" -ForegroundColor DarkGray
Write-Host "    Chaining Style:  $FeatureSupport" -ForegroundColor DarkGray
Write-Host ""

# --- Uninstall mode ---
if ($Uninstall) {
    Write-Host "  Uninstalling Cline Rules..." -ForegroundColor Yellow
    $dirsToRemove = @($RulesDir, $WorkflowsDir, $SkillsDir)
    foreach ($dir in $dirsToRemove) {
        if (Test-Path $dir) {
            Remove-Item -Recurse -Force -Path $dir
            Write-Host "  ✓ Removed: $dir" -ForegroundColor Green
        } else {
            Write-Host "  — Not found: $dir" -ForegroundColor DarkGray
        }
    }
    Write-Host ""
    Write-Host "  Uninstall complete." -ForegroundColor Green
    exit 0
}

# --- Validate source ---
if (-not (Test-Path $SrcRules)) {
    Write-Host "  ✗ Source directory not found: $SrcRules" -ForegroundColor Red
    Write-Host "    Make sure you're running this script from the repository root." -ForegroundColor Yellow
    exit 1
}

# --- Helper: install .md files from source to target ---
function Install-Files {
    param(
        [string]$SourceDir,
        [string]$DestDir,
        [string]$Label,
        [string]$Filter = "*.md"
    )

    # Create directory if missing
    if (-not (Test-Path $DestDir)) {
        New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
        Write-Host "    Created: $DestDir" -ForegroundColor Green
    }

    # Copy files (overwrite existing)
    $files = Get-ChildItem -Path $SourceDir -Filter $Filter -File -ErrorAction SilentlyContinue
    $count = 0
    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination $DestDir -Force
        $count++
    }

    Write-Host "    ✓ ${Label}: ${count} file(s) → $DestDir" -ForegroundColor Green
}

# --- 1. Rules ---
Write-Host "  [1/3] Installing Rules..." -ForegroundColor Cyan
Install-Files -SourceDir $SrcRules -DestDir $RulesDir -Label "Rules"

# --- 2. Workflows ---
Write-Host "  [2/3] Installing Workflows..." -ForegroundColor Cyan
Install-Files -SourceDir $SrcWorkflows -DestDir $WorkflowsDir -Label "Workflows"

# --- 3. Skill + Templates ---
Write-Host "  [3/3] Installing Skill + Templates..." -ForegroundColor Cyan

# Skill directory
if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
    Write-Host "    Created: $SkillsDir" -ForegroundColor Green
}

# SKILL.md
$skillFile = Join-Path $SrcSkill "SKILL.md"
if (Test-Path $skillFile) {
    Copy-Item -Path $skillFile -Destination $SkillsDir -Force
    Write-Host "    ✓ SKILL.md → $SkillsDir" -ForegroundColor Green
} else {
    Write-Host "    ✗ SKILL.md not found in source" -ForegroundColor Red
}

# Templates
$templatesSrc  = Join-Path $SrcSkill "templates"
$templatesDest = Join-Path $SkillsDir "templates"

if (Test-Path $templatesSrc) {
    if (-not (Test-Path $templatesDest)) {
        New-Item -ItemType Directory -Force -Path $templatesDest | Out-Null
        Write-Host "    Created: $templatesDest" -ForegroundColor Green
    }

    $tplFiles = Get-ChildItem -Path $templatesSrc -Filter "*.md" -File -ErrorAction SilentlyContinue
    $tplCount = 0
    foreach ($file in $tplFiles) {
        Copy-Item -Path $file.FullName -Destination $templatesDest -Force
        $tplCount++
    }
    Write-Host "    ✓ Templates: ${tplCount} file(s) → $templatesDest" -ForegroundColor Green
} else {
    Write-Host "    ⚠ Templates directory not found in source — skipping" -ForegroundColor Yellow
}

# --- Summary ---
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   Installation complete! (v2.0.2)            ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "    Rules:     $RulesDir"
Write-Host "    Workflows: $WorkflowsDir"
Write-Host "    Skill:     $SkillsDir"
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Cyan
Write-Host "    1. Open your IDE (VS Code, JetBrains, etc.)"
Write-Host "    2. Click the Rules icon in Cline to verify 8 rule files (00-07) are ON"
Write-Host "    3. Type 'follow rules' to start a session"
Write-Host ""
