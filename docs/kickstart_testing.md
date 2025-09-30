# Kickstart Deployment Testing

## 1. Overview
This document records the steps taken to ensure the Kickstart files for our VMs are available and accessible for automated deployment.

---

## 2. Kickstart Files
Located at: `kickstart/`

| File | Purpose |
|------|---------|
| vm1-web-ks.cfg | Web server |
| vm2-db-ks.cfg | Database server |
| vm3-monitoring-ks.cfg | Monitoring server |
| vm4-backup-ks.cfg | Backup server |
| vm5-security-ks.cfg | Security server |

---

## 3. Copy Kickstart Files
Copy the kickstart files to the Apache web directory:

```
sudo cp kickstart/* /var/www/html/kickstarts/
```

---

## 4. Start and Enable Apache
Make sure Apache is running and will start on boot:
```
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
```

---

## 5. Configure Firewall
Allow HTTP traffic through the firewall:
```
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload
```

---

## 6. Test Access Locally
Test that the kickstart files are accessible locally on the masternode VM:
```
curl http://localhost/kickstarts/vm1-web-ks.cfg
curl http://localhost/kickstarts/vm2-db-ks.cfg
curl http://localhost/kickstarts/vm3-monitoring-ks.cfg
curl http://localhost/kickstarts/vm4-backup-ks.cfg
curl http://localhost/kickstarts/vm5-security-ks.cfg
```

---

## 7. Test Access from Network
Test that the kickstart files are accessible from other machines. Replace 192.168.14.161 with your masternode VM IP:
```
curl http://192.168.14.161/kickstarts/vm1-web-ks.cfg
curl http://192.168.14.161/kickstarts/vm2-db-ks.cfg
curl http://192.168.14.161/kickstarts/vm3-monitoring-ks.cfg
curl http://192.168.14.161/kickstarts/vm4-backup-ks.cfg
curl http://192.168.14.161/kickstarts/vm5-security-ks.cfg
```

---

## 8. Observations
All kickstart files must be accessible via curl.

Firewall rules must allow HTTP for external access.

Local access works via localhost.

Any 404 errors indicate the path on Apache does not match the file location.

Testing via curl ensures the files can be used for automated VM deployment.
