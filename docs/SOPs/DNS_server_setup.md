# DNS Server Setup Guide
This setup uses one **Master VM** with other VMS
so we point IP addresses to the other vms
ideally have a web server to test this on
or you can do http://<localhost-ip-address:9090

this above just changes is what linux shows and you can use this to confirm, incase you aint got non web server

**Purpose:** Resolve custom hostnames for lab VMs (e.g., `web.lab.internal`) on your network.

**Scope:** his SOP covers installation, configuration, zone setup, firewall, and client VM testing.

**Prerequsites:**
- Master VM IP: 192.168.153.000
- Other VMs: Web (192.168.153.001), DB (192.168.123.002), etc.
- Root or sudo privileges on Master VM
- BIND (named) installed

## Step 1: Install BIND
```
sudo dnf install -y bind bind-utils
```
- `bind` = DNS server
- `bind-utils` = tools like dig and nslookup

## Step 2: Configure the Named Service
1. Set BIND to start on boot and enable it now:
```
sudo systemctl enable --now named
```
2. Check if named is running:
```
sudo systemctl status named
```

## Step 3: Configure DNS Options
Edit `/etc/named.conf` :
```
sudo vi /etc/named.conf
```

Set the options block like this:
```
options {
    listen-on port 53 { 192.168.153.000; 127.0.0.1; };
    listen-on-v6 port 53 { ::1; };
    directory "/var/named";
    allow-query { any; };
    recursion yes;
    dnssec-validation yes;
    managed-keys-directory "/var/named/dynamic";
};
```

## Step 4: Create Forward Zone
1. Add this to `named.conf` at the end:
```
zone "lab.internal" IN {
    type master;
    file "lab.internal.zone";
};
```

2. Create the zone file `/var/named/lab.internal.zone`:
```
sudo vi /var/named/lab.internal.zone
```
Content:
```
$TTL 86400
@   IN  SOA master.lab.internal. root.lab.internal. (
        2026021001 ; serial
        3600       ; refresh
        1800       ; retry
        604800     ; expire
        86400 )    ; minimum

@       IN  NS      master.lab.internal.

master  IN  A       192.168.153.000
web     IN  A       192.168.153.001
db      IN  A       192.168.153.002
monitor IN  A       192.168.153.003
backup  IN  A       192.168.153.004
security IN A       192.168.153.005
```

## Step 5: Create Reverse Zone (Optional)
Add to `named.conf`
```
zone "153.168.192.in-addr.arpa" IN {
    type master;
    file "lab.internal.rev";
};
```
Create `/var/named/lab.internal.rev`:
```
sudo vi /var/named/lab.internal.rev
```
Content:
```
$TTL 86400
@   IN  SOA master.lab.internal. root.lab.internal. (
        2026021001 ; serial
        3600       ; refresh
        1800       ; retry
        604800     ; expire
        86400 )    ; minimum

@       IN  NS      master.lab.internal.

128     IN  PTR     master.lab.internal.
129     IN  PTR     web.lab.internal.
130     IN  PTR     db.lab.internal.
131     IN  PTR     monitor.lab.internal.
132     IN  PTR     backup.lab.internal.
133     IN  PTR     security.lab.internal.
```

## Step 6: Set Permissions
```
sudo chown root:named /var/named/lab.internal.zone /var/named/lab.internal.rev
sudo chmod 640 /var/named/lab.internal.*
```

## Step 7: Check Config
```
sudo named-checkconf
sudo named-checkzone lab.internal /var/named/lab.internal.zone
sudo named-checkzone 153.168.192.in-addr.arpa /var/named/lab.internal.rev
```
Fix any errors before proceeding.

## Step 8: Restart Named
```
sudo systemctl restart named
sudo systemctl status named
```

## Step 9: Configure Clients to Use DNS
On each VM (or your host PC), set DNS to Master VM IP:
- Linux VM:
```
sudo nmcli con mod ens33 ipv4.dns 192.168.153.000
sudo nmcli con up ens33
```

- Windows Host:
Control Panel → Network → Wi-Fi/Ethernet → Properties → IPv4 → Use DNS server: `192.168.153.000`

## Step 10: Test DNS
```
dig web.lab.internal @192.168.153.000
dig db.lab.internal @192.168.153.000
ping web.lab.internal
ping db.lab.internal
```
- Should return correct IPs
- Reverse lookup also works:
```
dig -x 192.168.153.001 @192.168.153.000
```








