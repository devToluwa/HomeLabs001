# Maria DB Setup Guide / Tips

## 1. Update Package list
Before installing most things, its always good practice to update your stuff
```
sudo dnf update -y
```

## 2. Install MariaDB Server:
Install MariaDB server and client packages
For Debian/Ubuntu:Bash
```
sudo apt install mariadb-server mariadb-client galera-4
```

For RedHat/CentOS/Fedora:Bash
```
sudo dnf install mariadb mariadb-server
```

## 3. Secure the installation
NOTE: start the service first
```
sudo systemctl start mariadb
```
After installation, run the security script to set a root password, remove anonymous users, and disable remote root login
```
sudo mariadb-secure-installation
```

## 4. Start and verify the service
- Check status
```
sudo systemctl status mariadb
```

- Start service (if not running): bash
```
sudo systemctl start mariadb
```

- Enable service (this is to ensure the service starts on reboot): bash
```
suod systemctl enable mariadb
```

- Verify installation by connecting as root: bash
```
mariadb -u root -p
```
Enter root password you set during secure installation
