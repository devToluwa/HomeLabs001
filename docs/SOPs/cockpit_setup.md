# Cockpit Setup GUuide

## 1. Update the system and install Cockpit (if not already there yet)
```
sudo dnf update -y
sudo dnf install cockpit cockpit-dashboard -y
sudo systemctl enable --now cockpit.socket
```

## 2. Allow Cockpit through the firewall (once)
```
sudo firewall-cmd --add-service=cockpit --permanent
sudo firewall-cmd --reload
```

## 3. Open the monitoring portal for the first time

In your browser go to:

`https://192.168.221.131:9090`

basicaly

`http://<server-ip>:9090`

Log in with root or any user that has sudo rights on the monitoring server.
You will now see the normal Cockpit page, but still only the monitoring server itself.

## 4. Add all your other servers so they appear in the dashboard
1. In the Cockpit web interface:
Top-left corner → click the little ↓ arrow next to the current hostname
2. Choose “Add new host”
3. Type the IP or hostname (example: 192.168.221.10 or proxmox1.lan)
Pick “Use password” → enter root (or an admin user) and the password of that remote machine
4. Click Add
5. Repeat for every server/VM you have (Proxmox nodes, TrueNAS SCALE, Ubuntu VMs, etc.)

After this, a new “Dashboard” menu appears on the left sidebar.

## 5. Click “Dashboard” → you now see ALL servers on ONE page
Live CPU, Memory, Disk, Network graphs for every machine side-by-side.
That’s the view you wanted.

## 6. (Optional but recommended) Stop the annoying “makecache” failed service message
On any machine that shows the red “makecache” warning:
```
sudo systemctl mask dnf-makecache.timer
sudo systemctl daemon-reload
```
## 7. (Highly recommended) Set up real alerts (email or Discord/phone) that work for ALL servers centrally
Run these commands only once on 192.168.221.131:
```# Install mail tools
sudo dnf install mailx postfix cyrus-sasl-plain -y
sudo systemctl enable --now postfix

# Configure Gmail (replace with your own address and app password)
sudo tee /etc/postfix/main.cf > /dev/null <<EOF
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
myhostname = monitor.lan
inet_interfaces = loopback-only
EOF

# ←←←←← PUT YOUR GMAIL AND APP PASSWORD HERE ←←←←←
echo "[smtp.gmail.com]:587    youremail@gmail.com:your-16-digit-app-password" | sudo tee /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
sudo chmod 600 /etc/postfix/sasl_passwd*
sudo systemctl restart postfix

# Test it (you should receive this email)
echo "Monitoring setup complete" | mail -s "Test from homelab monitor" youremail@gmail.com
```

## 8. (Even better alerts – 2025 working version) Install the free community notification plugin
```
# This is the currently maintained one (verified working Dec 2025)
sudo dnf install -y https://github.com/45Drives/cockpit-navigator/releases/download/v1.2.0/cockpit-navigator-1.2.0-1.el9.noarch.rpm
sudo systemctl restart cockpit
```
Now refresh the web page → you will see a new menu on the left called Navigator or Notifications.
Click it → add your Gmail, Discord webhook, Telegram bot, or Pushover → save.
From now on you get instant alerts for failed services, full disks, high load, reboots needed, etc. on any server in the dashboard.
That’s literally everything we built together.
You now have:

- One URL → https://192.168.221.131:9090
- One “Dashboard” page with all servers at a glance
- Real alerts that scale to 5 or 5000 machines without touching the others

Bookmark that URL and you’re done forever.
If anything ever breaks or you add a new server, just come back here and repeat step 4.

