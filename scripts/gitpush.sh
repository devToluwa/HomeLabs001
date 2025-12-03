#!/bin/bash
# File: ~/pushlab  (or put in /usr/local/bin/pushlab)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# If not running as toluwa, re-exec the script as toluwa
if [ "$USER" != "toluwa" ] && [ "$(id -u)" -ne "$(id -u toluwa)" ]; then
    echo -e "${YELLOW}Not running as toluwa. Switching to toluwa...${NC}"
    echo "(You'll be asked for your password only if required)"
    exec sudo -u toluwa bash "$0" "$@"
    exit  # This line will never be reached
fi

# Now we are 100% guaranteed to be toluwa
clear
echo -e "${GREEN}Logged in as toluwa — ready to push Homelabs!${NC}"
echo

# Change to the repo
cd ~/HomeLabs001 || {
    echo -e "${RED}Error: ~/Homelabs001 directory not found!${NC}"
    exit 1
}

# Ask for commit message (required)
while true; do
    read -p "What is your commit message? " commit_msg
    [ -n "$commit_msg" ] && break
    echo -e "${YELLOW}Commit message cannot be empty!${NC}"
done

echo
echo "Adding all changes..."
git add .

echo "Committing..."
git commit -m "$commit_msg" || {
    echo -e "${YELLOW}Nothing to commit (or commit failed). Still pushing if possible...${NC}"
}

echo "Pushing to GitHub (origin main)..."
git push origin main

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Successfully pushed to GitHub!${NC}"
else
    echo -e "\n${RED}Push failed — check the errors above${NC}"
fi
