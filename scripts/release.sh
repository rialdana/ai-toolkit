#!/usr/bin/env bash
# frozen_string_literal: true
#
# Manual per-skill build release (local use only).
# CI handles releases automatically on merge to main.
# Use this script when you need to release outside the normal PR flow.
#
# Usage: ./scripts/release.sh <skill-name> [build]
# Example: ./scripts/release.sh core-coding-standards
# Example: ./scripts/release.sh core-coding-standards 12

set -euo pipefail

SKILL_NAME="${1:-}"
SET_BUILD="${2:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

error() {
  echo -e "${RED}✗ Error: $1${NC}" >&2
  exit 1
}

success() {
  echo -e "${GREEN}✓ $1${NC}"
}

info() {
  echo -e "${YELLOW}→ $1${NC}"
}

if [[ -z "$SKILL_NAME" ]]; then
  error "Usage: $0 <skill-name> [build]\nExample: $0 core-coding-standards"
fi

SKILL_PATH="skills/${SKILL_NAME}/SKILL.md"
if [[ ! -f "$SKILL_PATH" ]]; then
  error "Skill not found: ${SKILL_NAME} (expected ${SKILL_PATH})"
fi

if [[ -n "$SET_BUILD" && ! "$SET_BUILD" =~ ^[1-9][0-9]*$ ]]; then
  error "Build must be a positive integer (e.g., 1, 2, 3)"
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  error "Working directory has uncommitted changes. Commit or stash them first."
fi

# Check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  info "Warning: Not on main branch (current: $CURRENT_BRANCH)"
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

info "Releasing build for $SKILL_NAME..."

# Step 1: Validate skills and marketplace entry
info "Running skills audit..."
if ! ruby scripts/skills_audit.rb; then
  error "Skills audit failed. Fix issues before releasing."
fi
success "Skills audit passed"

info "Validating marketplace.json entry..."
SKILL_NAME="$SKILL_NAME" ruby -e "
require 'json'
skill = ENV.fetch('SKILL_NAME')
marketplace = JSON.parse(File.read('marketplace.json'))
entry = marketplace['skills']&.find { |s| s['name'] == skill }
abort \"Skill #{skill} missing from marketplace.json\" unless entry
"
success "Found $SKILL_NAME in marketplace.json"

# Step 2: Bump build
info "Updating build id in $SKILL_PATH..."
NEW_BUILD=$(SKILL_PATH="$SKILL_PATH" SET_BUILD="$SET_BUILD" ruby -e "
require 'yaml'

path = ENV.fetch('SKILL_PATH')
set_build = ENV['SET_BUILD']
content = File.read(path)

unless content =~ /\\A---\\n(.*?)\\n---\\n/m
  abort \"Missing frontmatter in #{path}\"
end

frontmatter = \$1
body = \$'
data = YAML.safe_load(frontmatter, permitted_classes: [Symbol]) || {}
data['metadata'] ||= {}

current = data.dig('metadata', 'version')
unless current && current.to_s.match?(/\\A\\d+\\z/)
  abort \"Current build id missing or invalid in #{path}\"
end

new_build = set_build ? Integer(set_build) : current.to_i + 1
data['metadata']['version'] = new_build
new_frontmatter = YAML.dump(data).sub(/\\A---\\n/, '')
File.write(path, \"---\\n#{new_frontmatter}---\\n#{body}\")
puts new_build
")
success "Updated $SKILL_NAME build to $NEW_BUILD"

info "Updating marketplace.json..."
SKILL_NAME="$SKILL_NAME" NEW_BUILD="$NEW_BUILD" ruby -e "
require 'json'

skill = ENV.fetch('SKILL_NAME')
build = Integer(ENV.fetch('NEW_BUILD'))
marketplace = JSON.parse(File.read('marketplace.json'))
entry = marketplace['skills']&.find { |s| s['name'] == skill }
abort \"Skill #{skill} missing from marketplace.json (should not happen)\" unless entry
entry['version'] = build
File.write('marketplace.json', JSON.pretty_generate(marketplace) + \"\\n\")
"
success "Updated marketplace.json for $SKILL_NAME"

# Step 4: Check tag doesn't already exist
TAG="skill-${SKILL_NAME}-b${NEW_BUILD}"
if git rev-parse "$TAG" >/dev/null 2>&1; then
  error "Tag $TAG already exists"
fi

# Step 5: Commit build bump
info "Committing build bump..."
git add "$SKILL_PATH" marketplace.json
git commit -m "chore(${SKILL_NAME}): bump build to ${NEW_BUILD}"
success "Created commit"

# Step 6: Create annotated tag
info "Creating annotated tag $TAG..."
git tag -a "$TAG" -m "Release ${SKILL_NAME} build ${NEW_BUILD}"
success "Created tag $TAG"

# Step 7: Ask about pushing
echo
info "Build release prepared locally:"
echo "  Skill: $SKILL_NAME"
echo "  Build: $NEW_BUILD"
echo "  Tag: $TAG"
echo "  Commit: $(git rev-parse --short HEAD)"
echo
read -p "Push to remote? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Push commit and tag
  info "Pushing to remote..."
  git push origin "$CURRENT_BRANCH"
  git push origin "$TAG"
  success "Pushed commit and tag"
else
  info "Release prepared but not pushed. To push manually:"
  echo "  git push origin $CURRENT_BRANCH"
  echo "  git push origin $TAG"
fi
