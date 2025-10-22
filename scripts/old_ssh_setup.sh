#!/bin/bash
# --------------------------------------------
# Automated SSH key setup for Ansible control
# --------------------------------------------

echo "🔐 SSH Key Setup for Remote Servers"
echo "-----------------------------------"

# Step 1: Ask for the number of servers
read -p "Enter number of servers to add: " NUM_SERVERS

# Step 2: Collect server IPs or hostnames
SERVERS=()
for (( i=1; i<=NUM_SERVERS; i++ ))
do
    read -p "Enter IP or hostname of server $i: " SERVER
    SERVERS+=("$SERVER")
done

# Step 3: Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "🔧 No SSH key found — generating one..."
    ssh-keygen -t rsa -b 4096
else
    echo "✅ SSH key already exists — skipping key generation."
fi

# Step 4: Copy SSH key to each server
for SERVER in "${SERVERS[@]}"
do
    echo "📤 Copying SSH key to $SERVER ..."
    ssh-copy-id "$USER@$SERVER"
done

echo "✅ All done! You can now test connections with:"
echo "   ansible all -m ping"

