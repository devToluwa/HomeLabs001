#!/bin/bash
# --------------------------------------------
# Fully Automated SSH Key Setup for Ansible Control
# --------------------------------------------

echo "🔐 Automated SSH Key Setup for Remote Servers"
echo "--------------------------------------------"

# Step 1: Ask for number of servers
read -p "Enter number of servers to add: " NUM_SERVERS

# Step 2: Ask for SSH username and password (used once)
read -p "Enter SSH username (default: root): " SSH_USER
SSH_USER=${SSH_USER:-root}

read -s -p "Enter SSH password for $SSH_USER: " SSH_PASS
echo ""

# Step 3: Collect IPs
SERVERS=()
for (( i=1; i<=NUM_SERVERS; i++ ))
do
    read -p "Enter IP or hostname of server $i: " SERVER
    SERVERS+=("$SERVER")
done

# Step 4: Generate SSH key automatically if not found
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "🔧 Generating new SSH key (no passphrase)..."
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa <<< y >/dev/null 2>&1
else
    echo "✅ SSH key already exists — skipping generation."
fi

# Step 5: Copy key to all servers automatically
for SERVER in "${SERVERS[@]}"
do
    echo "📤 Copying SSH key to $SERVER ..."
    sshpass -p "$SSH_PASS" ssh-copy-id -o StrictHostKeyChecking=no "$SSH_USER@$SERVER" >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "   ✅ Key copied successfully to $SERVER"
    else
        echo "   ❌ Failed to copy key to $SERVER"
    fi
done

# Step 6: Optionally test connectivity
echo ""
echo "🔍 Testing Ansible connectivity..."
for SERVER in "${SERVERS[@]}"
do
    ssh -o BatchMode=yes -o ConnectTimeout=3 "$SSH_USER@$SERVER" "echo '   ✅ $SERVER reachable'" 2>/dev/null || echo "   ❌ $SERVER unreachable"
done

echo ""
echo "🎉 All done! You can now test with:"
echo "   ansible all -m ping"

