#!/bin/bash

# ──────────────────────────────
# CONFIGURATION – CHANGE ONLY HERE
# ──────────────────────────────
TARGET_USER="toluwa"          # User that owns the repo
REPO_FOLDER="HomeLabs001"     # ←←← YOUR FOLDER NAME GOES HERE
BRANCH="main"                 # Change if you use master or another branch
# ──────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Auto-swwitch to the correct user if needed
if [ "$USER" != "$TARGET_USER" ] && [ "$(id -u)" -ne "$(id -u "$TARGET_USER")" ]; then
    echo -e "${YELLOW}Switching to $TARGET_USER...${NC}"
    exec sudo -u "$TARGET_USER" bash "$0" "$@"
    exit
fi

echo -e "${GREEN}Pushing $REPO_FOLDER to Github as $TARGET_USER${NC}"
echo

# Go the the repository folder
cd ~/"$REPO_FOLDER" || {
    echo -e "${RED}ERROR: ~/$REPO_FOLDER not found!${NC}"
    exit
}

# Ask for commit message
while true; do
    read -p "Commit message: " commit_msg
    [ -n "$commit_msg" ] && break
    echo -e "${YELLOW}Message cannot be empty!${NC}"
done

echo
git add .
git commit -m "$commit_msg" || echo -e "${YELLOW}No changes to commit${NC}"
echo -e "${GREEN}Pushing to origin, branch = $BRANCH...${NC}"
git push origin "$BRANCH"

[ $? -eq 0 ] && echo -e "\n${GREEN}All done! Successfully pushed!${NC}" || echo -e "\n${RED}Push failed${NC}"
