#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <GitHub-username> [repo-name]"
  echo "Example: $0 zjloveit unit-converter-privacy"
  echo ""
  echo "Create an empty GitHub repo first (no README), then run this script."
  exit 1
fi

GITHUB_USER="$1"
REPO_NAME="${2:-unit-converter-privacy}"
REMOTE="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
PAGES_URL="https://${GITHUB_USER}.github.io/${REPO_NAME}/"
SUPPORT_URL="https://${GITHUB_USER}.github.io/${REPO_NAME}/support.html"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  git init
  git branch -M main
fi

git add docs/ scripts/publish-github-pages.sh

if git diff --cached --quiet; then
  echo "No doc changes to commit."
else
  git commit -m "Publish privacy policy and support pages for GitHub Pages"
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "Pushing to existing origin…"
  git push -u origin main
else
  git remote add origin "$REMOTE"
  echo ""
  echo "Will push to: $REMOTE"
  echo "If the repo does not exist yet, create it at:"
  echo "  https://github.com/new?name=${REPO_NAME}"
  echo ""
  read "?Press Enter to push…"
  git push -u origin main
fi

echo ""
echo "=========================================="
echo "Enable GitHub Pages:"
echo "  https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
echo "  Source: Deploy from branch → main → /docs"
echo ""
echo "Privacy Policy URL:"
echo "  ${PAGES_URL}"
echo ""
echo "Support URL:"
echo "  ${SUPPORT_URL}"
echo "=========================================="
