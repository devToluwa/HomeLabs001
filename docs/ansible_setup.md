# 🧭 Linux Company Server Simulation — Ansible Setup Guide
## Overview
This guide documents the full process of setting up a **master VM** to control multiple **company service nodes** using **Ansible automation.**
Each VM simulates a company service:
| Node Type         | Purpose                                        |
| ----------------- | ---------------------------------------------- |
| **Web**           | Hosts applications or websites                 |
| **Database (DB)** | Provides backend data storage                  |
| **Monitoring**    | Collects metrics, logs, and observability data |
| **Backup**        | Handles data protection and recovery           |
| **Security**      | Runs security tools and enforces policies      |

# 1️⃣ Environment Setup
We begin with:
- **1 Master VM** — the control node (Ansible controller)
- **5 Service VMs** — the managed nodes (targets)
All VMs run a Linux distribution (CentOS/RHEL-based).

Each node should:
- Be connected to the same **internal/private network** (e.g., via VMware NAT or Host-Only)
- Have a unique static IP address
- Be accessible by hostname or IP from the master node

Example Network Layout
|**Role**       | **Hostname**       | **IP Address**      |
| ---------- | -------------- | --------------- |
| Master     | master.local   | 192.168.221.128 |
| Web        | web.local      | 192.168.221.129 |
| DB         | db.local       | 192.168.221.130 |
| Monitoring | monitor.local  | 192.168.221.131 |
| Backup     | backup.local   | 192.168.221.132 |
| Security   | security.local | 192.168.221.133 |

# 2️⃣ Preparing the Master Node
## 1. Update and install required packages
```
sudo dnf update -y
sudo dnf install -y epel-release ansible sshpass
```

## 2. Confirm Ansible installation
```
ansible --version
```

## 3. Ensure SSH client is available
```
ssh -V
```

# 3️⃣ Configure the Managed Nodes
Each managed node (Web, DB, etc.) must:

- Allow SSH access (preferably via password during setup)
- Permit the root or specific user to log in remotely

## ✅ Enable root SSH login
On each node:

```
sudo vi /etc/ssh/sshd_config
```

Ensure these lines are set:

```
PermitRootLogin yes
PasswordAuthentication yes
```

Then restart SSH:

```
sudo systemctl restart sshd
```

# 4️⃣ Establish Passwordless SSH
To allow Ansible to connect without typing passwords each time, configure SSH keys from the master node.

## Step 1: Generate SSH key (if not already present)
```
ssh-keygen -t rsa -b 4096
```
Press Enter through prompts to accept defaults.

## Step 2: Copy SSH key to target node
For example, to connect to the Web node:
```
ssh-copy-id root@192.168.221.129
```
Enter the password when prompted.
Repeat for each node (DB, Monitoring, Backup, Security).

💡 Tip: You can automate this for multiple servers using the helper script we created.

## 5️⃣ Test Manual SSH Connectivity
Verify that you can SSH into each node without a password:
```
ssh root@192.168.221.129
```
If this logs you in directly, the key-based authentication is working.

## 6️⃣ Set Up the Ansible Inventory
Create an Ansible folder structure: 
```
mkdir -p ~/ansible/{inventories,playbooks,roles,files}
```
Then create an inventory file:
```
vi ~/ansible/inventories/hosts.ini
```
For Example:
```
[web]
192.168.221.129

[database]
192.168.221.130

[monitoring]
192.168.221.131

[backup]
192.168.221.132

[security]
192.168.221.133
```

# 7️⃣ Test Ansible Connectivity
Run:
```
ansible all -i ~/ansible/inventories/hosts.ini -m ping
```
Expected result:
```
192.168.221.129 | SUCCESS => {
    "ping": "pong"
}
...
```
If any nodes are unreachable, check:
- SSH key setup
- `/etc/ssh/sshd_config` settings
- Firewall (disable temporarily for testing: `sudo systemctl stop firewalld`)

# 8️⃣ (Optional) Automate SSH Setup with a Script
To make adding multiple servers easier, I wrote a script that:
- Prompts for number of servers
- Collects IPs
- Ensures SSH keys exist
- Copies keys to each server
- Tests connectivity via Ansible
You can reuse that script whenever adding new nodes.

# 9️⃣ Ready for Automation!

At this stage:
✅ Master can SSH into all nodes
✅ Ansible can reach all servers
✅ Inventory and folder structure are configured

Example test playbook:
```
- name: Verify connectivity
  hosts: all
  gather_facts: no
  tasks:
    - name: Ping
      ansible.builtin.ping:
```
Run it via: `ansible-playbook ~/ansible/playbooks/ping.yml`

