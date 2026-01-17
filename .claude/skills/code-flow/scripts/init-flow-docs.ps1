# init-flow-docs.ps1 - Initialize flow-docs directory structure (PowerShell)
#
# This script creates the standard directory structure for code-flow documentation.
#
# Usage: .\init-flow-docs.ps1 -FeatureName "device-control-feature"
#
# Example: .\init-flow-docs.ps1 -FeatureName "device-control-feature"

param(
    [Parameter(Mandatory=$true)]
    [string]$FeatureName
)

# Check if feature name is provided
if ([string]::IsNullOrWhiteSpace($FeatureName)) {
    Write-Host "❌ Error: Please provide a feature name" -ForegroundColor Red
    Write-Host "Usage: .\init-flow-docs.ps1 -FeatureName '<feature-name>'"
    Write-Host "Example: .\init-flow-docs.ps1 -FeatureName 'device-control-feature'"
    exit 1
}

# Define base directory
$BaseDir = "flow-docs\$FeatureName"

# Check if directory already exists
if (Test-Path $BaseDir) {
    Write-Host "⚠️  Warning: Directory '$BaseDir' already exists." -ForegroundColor Yellow
    $Response = Read-Host "Continue and add missing directories? (Y/N)"
    if ($Response -ne 'Y' -and $Response -ne 'y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Create directory structure
Write-Host "📁 Creating flow-docs directory structure..."
Write-Host "   Base directory: $BaseDir"

# Create all directories
$Directories = @(
    "$BaseDir\01_dev\code_insight",
    "$BaseDir\01_dev\feature_design",
    "$BaseDir\01_dev\impl_plan",
    "$BaseDir\01_dev\code_review",
    "$BaseDir\02_memories",
    "$BaseDir\03_migration\commit-log-summary",
    "$BaseDir\03_migration\migration-plan"
)

foreach ($Dir in $Directories) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

# Create README in base directory
$ReadmePath = "$BaseDir\README.md"
$ReadmeContent = @"
# $FeatureName - Code Flow Documentation

This directory contains all development workflow documentation for $FeatureName.

## Directory Structure

### 01_dev/ - Development Documents
- **code_insight/** - Code exploration documents (use code-insight sub-skill)
- **feature_design/** - Feature design documents (use feature-design sub-skill)
- **impl_plan/** - Implementation plan documents (use writing-plans sub-skill)
- **code_review/** - Code review documents (use code-review sub-skill)

### 02_memories/ - Session Memory
- **active_context.md** - Session context (use save-context sub-skill)

### 03_migration/ - Migration Documents
- **commit-log-summary/** - Commit log summaries (use commit-change-log sub-skill)
- **migration-plan/** - Migration plans (use commit-migration sub-skill)

## Usage

Generate documentation using code-flow sub-commands:

\`\`\`powershell
# Explore existing code
/code-flow code-insight

# Design feature
/code-flow feature-design

# Write implementation plan
/code-flow writing-plans

# Execute plan
/code-flow executing-plans

# Review code
/code-flow code-review

# Save context
/code-flow save-context

# Analyze commits
/code-flow commit-change-log

# Generate migration plan
/code-flow commit-migration

# Commit code
/code-flow git-commit
\`\`\`

---

Created: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Set-Content -Path $ReadmePath -Value $ReadmeContent -Encoding UTF8

Write-Host ""
Write-Host "✅ Directory structure created successfully!"
Write-Host ""
Write-Host "📂 Created directories:"
Write-Host "   $BaseDir\01_dev\code_insight\"
Write-Host "   $BaseDir\01_dev\feature_design\"
Write-Host "   $BaseDir\01_dev\impl_plan\"
Write-Host "   $BaseDir\01_dev\code_review\"
Write-Host "   $BaseDir\02_memories\"
Write-Host "   $BaseDir\03_migration\commit-log-summary\"
Write-Host "   $BaseDir\03_migration\migration-plan\"
Write-Host ""
Write-Host "📄 Created files:"
Write-Host "   $BaseDir\README.md"
Write-Host ""
Write-Host "🚀 Now you can use /code-flow sub-commands to start working!"
