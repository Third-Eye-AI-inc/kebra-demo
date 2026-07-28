#!/bin/bash
# Publish / update the Kebra HVAC demo on GitHub Pages.
# Run:  bash ~/kebra-demo/deploy/publish.sh
set -euo pipefail
cd "$(dirname "$0")"

REPO="Third-Eye-AI-inc/kebra-demo"
URL="https://third-eye-ai-inc.github.io/kebra-demo/"

# refresh the page from the latest build
cp ../Kebra-Demo.html index.html

if [ ! -d .git ]; then
  git init -b main
fi
git add -A
git -c user.name=lucathirdeye -c user.email=luca@third-eye.live \
  commit -m "HVAC demo update" 2>/dev/null || echo "· nothing new to commit"

# create the GitHub repo + first push, or just push updates
if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$REPO" --public --source . --push \
    --description "Kebra — HVAC product walkthrough"
  gh api -X POST "repos/$REPO/pages" \
    -f "source[branch]=main" -f "source[path]=/" >/dev/null \
    && echo "· GitHub Pages enabled" || echo "· Pages may already be enabled"
else
  git push
fi

echo ""
echo "✅  Live in ~1 minute:  $URL"
