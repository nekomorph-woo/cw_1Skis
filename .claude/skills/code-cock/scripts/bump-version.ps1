# Code Cock Version Bump Script (PowerShell)
# Usage: .\bump-version.ps1 [minor|patch] "description"

param(
    [Parameter(Position=0)]
    [ValidateSet("minor", "patch", "major")]
    [string]$VersionType = "patch",

    [Parameter(Position=1)]
    [string]$Description = "Update version"
)

# Error action preference
$ErrorActionPreference = "Stop"

# Paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillFile = Join-Path $ScriptRoot "..\SKILL.md" -Resolve
$ChangelogFile = Join-Path $ScriptRoot "..\CHANGELOG.md" -Resolve

# Check if files exist
if (-not (Test-Path $SkillFile)) {
    Write-Error "Error: SKILL.md not found at $SkillFile"
    exit 1
}

if (-not (Test-Path $ChangelogFile)) {
    Write-Error "Error: CHANGELOG.md not found at $ChangelogFile"
    exit 1
}

# Get current version
$SkillContent = Get-Content $SkillFile -Raw
if ($SkillContent -match 'version: ([\d.]+)') {
    $CurrentVersion = $matches[1]
} else {
    Write-Error "Error: Could not find version in SKILL.md"
    exit 1
}

Write-Host "Current version: $CurrentVersion"

# Parse version
$VersionParts = $CurrentVersion.Split('.')
$Major = [int]$VersionParts[0]
$Minor = [int]$VersionParts[1]
$Patch = [int]$VersionParts[2]

# Increment version
switch ($VersionType) {
    "minor" {
        $Minor += 1
        $Patch = 0
        $TypeText = "Refactored"
    }
    "patch" {
        $Patch += 1
        $TypeText = "Fixed"
    }
    "major" {
        $Major += 1
        $Minor = 0
        $Patch = 0
        $TypeText = "Added"
    }
}

$NewVersion = "$Major.$Minor.$Patch"
Write-Host "New version: $NewVersion"

# Get current date
$Today = Get-Date -Format "yyyy-MM-dd"

# Update SKILL.md
$SkillContent = $SkillContent -replace "version: [\d.]+", "version: $NewVersion"
$SkillContent | Set-Content $SkillFile -NoNewline

# Update CHANGELOG.md
$ChangelogContent = Get-Content $ChangelogFile -Raw
$NewEntry = "| $NewVersion | $Today | $TypeText | $Description |"

# Insert new entry after the version history table header
$Pattern = '(## Version History.*?\n(\|.*?\n)*?\|---.*?\n)'
$Replacement = "`$1`n$NewEntry"

$ChangelogContent = $ChangelogContent -replace $Pattern, $Replacement
$ChangelogContent | Set-Content $ChangelogFile -NoNewline

Write-Host "✓ Version updated to $NewVersion"
Write-Host "✓ SKILL.md updated"
Write-Host "✓ CHANGELOG.md updated"
Write-Host ""
Write-Host "Commit the changes with:"
Write-Host "  git add '$SkillFile' '$ChangelogFile'"
Write-Host "  git commit -m 'docs: Release version $NewVersion'"
