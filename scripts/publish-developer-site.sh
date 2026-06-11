#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/developer-site"
GITHUB_USER="${1:-zjloveit}"
REPO_NAME="${GITHUB_USER}.github.io"
REMOTE="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
WORKDIR="$(mktemp -d)"

trap 'rm -rf "$WORKDIR"' EXIT

if [[ ! -f "$SITE_DIR/app-ads.txt" ]]; then
  echo "Missing $SITE_DIR/app-ads.txt"
  exit 1
fi

if ! git ls-remote "$REMOTE" >/dev/null 2>&1; then
  echo "Repo not found: $REMOTE"
  echo "Create it first: https://github.com/new?name=${REPO_NAME}"
  exit 1
fi

git clone --depth 1 "$REMOTE" "$WORKDIR/repo"
cd "$WORKDIR/repo"

# AdMob crawls https://USER.github.io/app-ads.txt (site root).
# Files must live at repo root when Pages source is main + / (root).
cp "$SITE_DIR/app-ads.txt" "$SITE_DIR/index.html" .
touch .nojekyll

git add app-ads.txt index.html .nojekyll

if git diff --cached --quiet; then
  echo "Root app-ads.txt already up to date."
else
  git commit -m "Publish app-ads.txt at repo root for AdMob"
  git push origin main
fi

echo ""
echo "GitHub Pages settings:"
echo "  https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
echo "  Source: Deploy from branch → main → / (root)"
echo ""
echo "Verify (AdMob checks this exact URL):"
echo "  https://${GITHUB_USER}.github.io/app-ads.txt"
echo ""
echo "NOT this path (wrong for AdMob):"
echo "  https://${GITHUB_USER}.github.io/docs/app-ads.txt"
