#!/bin/bash
# init-flow-docs.sh - Initialize flow-docs directory structure
#
# This script creates the standard directory structure for code-flow documentation.
#
# Usage: ./init-flow-docs.sh <feature-name>
#
# Example: ./init-flow-docs.sh "device-control-feature"

set -e

FEATURE_NAME="${1:-}"

# Check if feature name is provided
if [ -z "$FEATURE_NAME" ]; then
    echo "❌ Error: Please provide a feature name"
    echo "Usage: $0 <feature-name>"
    echo "Example: $0 \"device-control-feature\""
    exit 1
fi

# Define base directory
BASE_DIR="flow-docs/$FEATURE_NAME"

# Check if directory already exists
if [ -d "$BASE_DIR" ]; then
    echo "⚠️  Warning: Directory '$BASE_DIR' already exists."
    read -p "Continue and add missing directories? (Y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Create directory structure
echo "📁 Creating flow-docs directory structure..."
echo "   Base directory: $BASE_DIR"

# Create all directories
mkdir -p "$BASE_DIR/01_dev/code_insight"
mkdir -p "$BASE_DIR/01_dev/feature_design"
mkdir -p "$BASE_DIR/01_dev/impl_plan"
mkdir -p "$BASE_DIR/01_dev/code_review"
mkdir -p "$BASE_DIR/02_memories/context_${FEATURE_NAME}"
mkdir -p "$BASE_DIR/03_migration/commit-log-summary"
mkdir -p "$BASE_DIR/03_migration/migration-plan"

# Create README in base directory
cat > "$BASE_DIR/README.md" << EOF
# ${FEATURE_NAME} - Code Flow Documentation

This directory contains all development workflow documentation for ${FEATURE_NAME}.

## Directory Structure

### 01_dev/ - Development Documents
- **code_insight/** - Code exploration documents (use code-insight sub-skill)
- **feature_design/** - Feature design documents (use feature-design sub-skill)
- **impl_plan/** - Implementation plan documents (use writing-plans sub-skill)
- **code_review/** - Code review documents (use code-review sub-skill)

### 02_memories/ - Session Memory
- **context_${FEATURE_NAME}/** - Session context (use save-context sub-skill)

### 03_migration/ - Migration Documents
- **commit-log-summary/** - Commit log summaries (use commit-change-log sub-skill)
- **migration-plan/** - Migration plans (use commit-migration sub-skill)

## Usage

Generate documentation using code-flow sub-commands:

\`\`\`bash
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

Created: $(date +"%Y-%m-%d %H:%M:%S")
EOF

echo ""
echo "✅ Directory structure created successfully!"
echo ""
echo "📂 Created directories:"
echo "   $BASE_DIR/01_dev/code_insight/"
echo "   $BASE_DIR/01_dev/feature_design/"
echo "   $BASE_DIR/01_dev/impl_plan/"
echo "   $BASE_DIR/01_dev/code_review/"
echo "   $BASE_DIR/02_memories/context_${FEATURE_NAME}/"
echo "   $BASE_DIR/03_migration/commit-log-summary/"
echo "   $BASE_DIR/03_migration/migration-plan/"
echo ""
echo "📄 Created files:"
echo "   $BASE_DIR/README.md"
echo ""
echo "🚀 Now you can use /code-flow sub-commands to start working!"
