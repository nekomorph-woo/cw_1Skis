#!/bin/bash
# bump-version.sh - Code Flow Skill version auto-update script
#
# Purpose: Auto-update version number and CHANGELOG when code-flow skill has significant changes
# Usage: ./bump-version.sh [minor|patch] "Change description"
#
# Examples:
#   ./bump-version.sh minor "Add unified trigger keyword management system"
#   ./bump-version.sh patch "Fix documentation reference errors"

set -e

# Parse arguments
VERSION_TYPE="${1:-patch}"
CHANGE_CONTENT="${2:-Code optimization}"
SKILL_MD=".claude/skills/code-flow/SKILL.md"
CHANGELOG_MD=".claude/skills/code-flow/CHANGELOG.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if in project root
if [ ! -f "$SKILL_MD" ]; then
    log_error "File not found: $SKILL_MD. Please run this script from project root."
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep "^version:" "$SKILL_MD" | awk '{print $2}')
if [ -z "$CURRENT_VERSION" ]; then
    log_error "Cannot read current version from $SKILL_MD"
    exit 1
fi

log_info "Current version: $CURRENT_VERSION"

# Parse version number
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Calculate new version
case "$VERSION_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        log_error "Invalid version type: $VERSION_TYPE"
        echo "Usage: $0 [major|minor|patch] \"Change description\""
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
log_info "New version: $NEW_VERSION"

# Get current date
TODAY=$(date +"%Y-%m-%d")

# Update version number in SKILL.md
log_info "Updating version in $SKILL_MD..."
sed -i "s/^version: $CURRENT_VERSION/version: $NEW_VERSION/" "$SKILL_MD"
sed -i "s/当前版本 $CURRENT_VERSION/当前版本 $NEW_VERSION/" "$SKILL_MD"
sed -i "s/\*\*Current Version:\*\* $CURRENT_VERSION/\*\*Current Version:\*\* $NEW_VERSION/" "$SKILL_MD"

log_info "Version updated: $CURRENT_VERSION → $NEW_VERSION"

# Append change record to CHANGELOG.md
log_info "Updating $CHANGELOG_MD..."

# Insert new record at top of table
NEW_ROW="| $NEW_VERSION | $TODAY | Refactored | $CHANGE_CONTENT |"

# Create temp file
TEMP_FILE=$(mktemp)

# Read CHANGELOG.md and insert new record after table header
awk -v new_row="$NEW_ROW" '
/^## 版本变更记录$/ {
    print
    print ""
    print "| 版本 | 日期 | 变更类型 | 变更内容 |"
    print "|------|------|---------|---------|"
    print new_row
    getline # skip old header
    getline # skip old separator
    next
}
{ print }
' "$CHANGELOG_MD" > "$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$CHANGELOG_MD"

log_info "Change record appended to CHANGELOG.md"

# Output summary
echo ""
log_info "Version update complete!"
echo "  Version: $CURRENT_VERSION → $NEW_VERSION"
echo "  Change: $CHANGE_CONTENT"
echo ""
log_warn "Next steps:"
echo "  1. Review changes in $SKILL_MD and $CHANGELOG_MD"
echo "  2. git add .claude/skills/code-flow/SKILL.md .claude/skills/code-flow/CHANGELOG.md"
echo "  3. git commit -m \"docs: Release version $NEW_VERSION\""
echo ""
