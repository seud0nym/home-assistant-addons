#!/bin/bash
# ==============================================================================
# Promote a beta release to stable on the main branch.
#
# This script:
# 1. Validates it is run from the beta branch with a clean working tree
# 2. Validates the current version is a beta version
# 3. Prompts for the stable version number
# 4. Updates version references across all relevant files
# 5. Commits changes and merges beta into main
# 6. Reverts beta-specific settings on main (repository name, dependabot, stage)
# 7. Pushes both branches
# ==============================================================================
set -euo pipefail

cd "$(cd "$(dirname "$0")/.."; pwd)"

readonly ADDON_DIR="sigenergy2mqtt"
readonly CONFIG="${ADDON_DIR}/config.yaml"
readonly DOCKERFILE="${ADDON_DIR}/Dockerfile"
readonly CHANGELOG="${ADDON_DIR}/CHANGELOG.md"
readonly REPO_YAML="repository.yaml"

# --- Validation ---

branch=$(git branch --show-current)
if [[ "$branch" != "beta" ]]; then
  echo "ERROR: This script must be run from the beta branch (currently on '$branch')."
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: Working tree is not clean. Please commit or stash your changes first."
  exit 1
fi

beta_version=$(grep '^version:' "$CONFIG" | cut -d'"' -f2)
if [[ ! "$beta_version" =~ ^[0-9]{4}\.[0-9]+\.[0-9]+b[0-9]+$ ]]; then
  echo "ERROR: Current version '$beta_version' is not a beta version (expected YYYY.M.DbN)."
  exit 1
fi

# --- Version Prompt ---

default_stable_version="${beta_version%%b*}"
read -rp "Stable version [$default_stable_version]: " stable_version
stable_version="${stable_version:-$default_stable_version}"

if [[ "$stable_version" =~ b[0-9]+$ ]]; then
  echo "ERROR: Stable version '$stable_version' looks like a beta version."
  exit 1
fi

echo ""
echo "=== Release Summary ==="
echo "  Beta version:   $beta_version"
echo "  Stable version: $stable_version"
echo "  Branch:         beta → main"
echo "======================="
echo ""

# --- Update version references on beta branch ---

echo "Updating version references..."

# config.yaml: version
sed -i "s/^version: \"${beta_version}\"/version: \"${stable_version}\"/" "$CONFIG"

# config.yaml: url (beta → main)
sed -i 's|/tree/beta/|/tree/main/|' "$CONFIG"

# config.yaml: stage (experimental → stable)
sed -i 's/^stage: experimental$/stage: stable/' "$CONFIG"

# Dockerfile: .whl filename
sed -i "s/sigenergy2mqtt-${beta_version}-/sigenergy2mqtt-${stable_version}-/" "$DOCKERFILE"

# CHANGELOG.md: heading
sed -i "s/^## ${beta_version}$/## ${stable_version}/" "$CHANGELOG"

echo "Committing version changes to beta branch..."
git add "$CONFIG" "$DOCKERFILE" "$CHANGELOG"
git commit -m "Release ${stable_version} (promoted from ${beta_version})"

# --- Merge to main ---

echo "Switching to main and merging beta..."
git checkout main
git merge beta -m "Merge beta release ${stable_version} into main"

# --- Revert beta-specific settings on main ---

echo "Reverting beta-specific settings on main..."

# repository.yaml: remove (Beta) suffix and #beta from URL
sed -i 's/ (Beta)//' "$REPO_YAML"
sed -i 's/#beta//' "$REPO_YAML"

git add "$REPO_YAML"
git commit -m "Revert beta-specific settings for main branch"

# --- Push ---

echo ""
echo "=== Ready to push ==="
echo "  main:  release ${stable_version}"
echo "  beta:  release commit"
echo ""
echo "Pushing main will trigger the Home Assistant add-on builder workflow."
echo ""
read -rp "Push both branches? [Y/n] " confirm
confirm="${confirm:-Y}"

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "Pushing main..."
  git push origin main
  echo "Pushing beta..."
  git push origin beta
  echo ""
  echo "Done! Release ${stable_version} has been published."
else
  echo ""
  echo "Push cancelled. Both branches have been updated locally."
  echo "When ready, run:"
  echo "  git push origin main"
  echo "  git push origin beta"
fi

echo "Switching back to beta branch..."
git checkout beta
