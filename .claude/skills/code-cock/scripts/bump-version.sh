#!/bin/bash

# Code Cock Version Bump Script (Bash)
# Usage: ./bump-version.sh [minor|patch] "description"

set -e

# Default to patch if no type specified
VERSION_TYPE=${1:-patch}
DESCRIPTION=${2:-"Update version"}

# Paths
SKILL_FILE="$(dirname "$0")/../SKILL.md"
CHANGELOG_FILE="$(dirname "$0")/../CHANGELOG.md"

# Check if files exist
if [ ! -f "$SKILL_FILE" ]; then
    echo "Error: SKILL.md not found at $SKILL_FILE"
    exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "Error: CHANGELOG.md not found at $CHANGELOG_FILE"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep "^version:" "$SKILL_FILE" | sed 's/version: //')
echo "Current version: $CURRENT_VERSION"

# Parse version
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Increment version
case $VERSION_TYPE in
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        TYPE_TEXT="Refactored"
        ;;
    patch)
        PATCH=$((PATCH + 1))
        TYPE_TEXT="Fixed"
        ;;
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        TYPE_TEXT="Added"
        ;;
    *)
        echo "Error: Invalid version type. Use 'minor', 'patch', or 'major'"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# Get current date
TODAY=$(date +%Y-%m-%d)

# Update SKILL.md
sed -i "s/^version: .*/version: $NEW_VERSION/" "$SKILL_FILE"

# Update CHANGELOG.md
# Insert new version entry after the version history table header
NEW_ENTRY="| $NEW_VERSION | $TODAY | $TYPE_TEXT | $DESCRIPTION |"

# Create temporary file
awk -v new_entry="$NEW_ENTRY" '
/^## Version History/ { in_header=1 }
in_header && /^\|---/ && !header_added {
    print ""
    print new_entry
    header_added=1
    next
}
{ print }
' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp" && mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"

echo "✓ Version updated to $NEW_VERSION"
echo "✓ SKILL.md updated"
echo "✓ CHANGELOG.md updated"
echo ""
echo "Commit the changes with:"
echo "  git add '$SKILL_FILE' '$CHANGELOG_FILE'"
echo "  git commit -m 'docs: Release version $NEW_VERSION'"
