# bump-version.ps1 - Code Flow Skill version auto-update script (PowerShell)
#
# Purpose: Auto-update version number and CHANGELOG when code-flow skill has significant changes
# Usage: .\bump-version.ps1 [minor|patch] "Change description"
#
# Examples:
#   .\bump-version.ps1 minor "Add unified trigger keyword management system"
#   .\bump-version.ps1 patch "Fix documentation reference errors"

param(
    [Parameter(Position=0)]
    [ValidateSet("major", "minor", "patch")]
    [string]$VersionType = "patch",

    [Parameter(Position=1)]
    [string]$ChangeContent = "Code optimization"
)

# File paths
$SkillMd = ".claude/skills/code-flow/SKILL.md"
$ChangelogMd = ".claude/skills/code-flow/CHANGELOG.md"

# Logging functions
function Log-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Log-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Log-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if files exist
if (-not (Test-Path $SkillMd)) {
    Log-Error "File not found: $SkillMd. Please run this script from project root."
    exit 1
}

# Get current version
$Content = Get-Content $SkillMd -Raw
if ($Content -match 'version: ([\d.]+)') {
    $CurrentVersion = $Matches[1]
} else {
    Log-Error "Cannot read current version from $SkillMd"
    exit 1
}

Log-Info "Current version: $CurrentVersion"

# Parse version number
$Parts = $CurrentVersion.Split('.')
$Major = [int]$Parts[0]
$Minor = [int]$Parts[1]
$Patch = [int]$Parts[2]

# Calculate new version
switch ($VersionType) {
    "major" {
        $Major += 1
        $Minor = 0
        $Patch = 0
    }
    "minor" {
        $Minor += 1
        $Patch = 0
    }
    "patch" {
        $Patch += 1
    }
}

$NewVersion = "$Major.$Minor.$Patch"
Log-Info "New version: $NewVersion"

# Get current date
$Today = Get-Date -Format "yyyy-MM-dd"

# Update version in SKILL.md
Log-Info "Updating version in $SkillMd..."
$Content = $Content -replace "version: $CurrentVersion", "version: $NewVersion"
$Content = $Content -replace "当前版本 $CurrentVersion", "当前版本 $NewVersion"
$Content = $Content -replace "\*\*Current Version:\*\* $CurrentVersion", "**Current Version:** $NewVersion"
$Content | Set-Content $SkillMd -Encoding UTF8

Log-Info "Version updated: $Current_VERSION → $NewVersion"

# Append change record to CHANGELOG.md
Log-Info "Updating $ChangelogMd..."

# Read CHANGELOG.md
$ChangelogLines = Get-Content $ChangelogMd -Encoding UTF8

# Build new record
$NewRow = "| $NewVersion | $Today | Refactored | $ChangeContent |"

# Find table position and insert new record
$NewLines = @()
$TableFound = $false
$HeaderInserted = $false

foreach ($Line in $ChangelogLines) {
    if (-not $HeaderInserted -and $Line -match '^## 版本变更记录') {
        $NewLines += $Line
        $NewLines += ""
        $NewLines += "| 版本 | 日期 | 变更类型 | 变更内容 |"
        $NewLines += "|------|------|---------|---------|"
        $NewLines += $NewRow
        $HeaderInserted = $true
        $TableFound = $true
    } elseif ($TableFound -and $Line -match '^\| 版本 \|') {
        # skip old header
        continue
    } elseif ($TableFound -and $Line -match '^\|------') {
        continue
    } else {
        $NewLines += $Line
    }
}

# Write to file
$NewLines | Set-Content $ChangelogMd -Encoding UTF8

Log-Info "Change record appended to CHANGELOG.md"

# Output summary
Write-Host ""
Log-Info "Version update complete!"
Write-Host "  Version: $CurrentVersion → $NewVersion"
Write-Host "  Change: $ChangeContent"
Write-Host ""
Log-Warn "Next steps:"
Write-Host "  1. Review changes in $SkillMd and $ChangelogMd"
Write-Host "  2. git add .claude/skills/code-flow/SKILL.md .claude/skills/code-flow/CHANGELOG.md"
Write-Host "  3. git commit -m \"docs: Release version $NewVersion\""
Write-Host ""
