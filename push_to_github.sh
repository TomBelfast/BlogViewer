#!/bin/bash
# Script to push BlogBowl to GitHub repository

GITHUB_USER="TomBelfast"
REPO_NAME="BlogViewer"

echo "Repository: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "Choose authentication method:"
echo "1. Personal Access Token (in URL)"
echo "2. SSH"
echo "3. Manual (will prompt for credentials)"
read -p "Enter choice (1-3): " choice

case $choice in
  1)
    read -sp "Enter your GitHub Personal Access Token: " TOKEN
    echo ""
    git remote set-url origin "https://$TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"
    git push -u origin main
    ;;
  2)
    git remote set-url origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"
    git push -u origin main
    ;;
  3)
    git push -u origin main
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

echo ""
echo "✅ Done! Check your repository at: https://github.com/$GITHUB_USER/$REPO_NAME"
