
# Zabbix Setup Guide

visit https://www.zabbix.com/download for a more simpler process but im gonna write it here anyways

## Step 1: Choose your platform
from the website I choose:
- Zabbix Version: 7.4
- OS Distribution: CentOS
- OS Version: 10 (amd64, arm64)
- Zabbix Component: Server, Frontend, Agent
- Databse: MySQL
- Web Server: Apache

## Step 2: Install and configure Zabbix on your platform
**a. Install Zabbix repository**\
   Disable Zabbix packages provided by EPEL\
   if you have it installed. Edit file `/etc/yum.repos.d/epel.repo` and add the following statement.
```
[epel]
...
excludepkgs=zabbix*
```

Proceed with installing zabbix repository.
```
rpm -Uvh https://repo.zabbix.com/zabbix/7.4/release/centos/9/noarch/zabbix-release-latest-7.4.el9.noarch.rpm
dnf clean all
```

**b. Install zabbix server, frontend, agent**
```
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent
```

**c. Create initial database**\
Make sure you have a db installed, prferably MariaDB or Postgress, as per your installation
I'm using mariadb
```
mysql -u root -p
password
mariadb> CREATE DATABASE zabbix_database CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
mariadb> CREATE USER zabbix_user@localhost identified by 'pick_a_password';
mariadb> GRANT ALL PRIVILEGES ON zabbix_database.* TO zabbix_user@localhost;
mariadb> SET GLOBAL log_bin_trust_function_creators = 1;
mariadb> quit
```
On zabbix server host import the initial schema and data.
```
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz \
| mysql --default-character-set=utf8mb4 -u zabbix_user -p zabbix_database
```
Disable log_bin_trust_function_creators option after importing database schema
```
mysql -u root -p
password
mariadb> SET GLOBAL log_bin_trust_function_creators = 0;
mariadb> quit
```

**d. Configure the database for zabbix server**\
edit the file `/etc/zabbix/zabbix_server.conf`
```
vi /etc/zabbix/zabbix_server.conf
DBPassword=whatever_password_you_want
```

**e. add services to firewall**
```
firewall-cmd --add-service={http,https,zabbix-server,zabbix-agent} --permanent
```

**f. Web UI might not be reachable**\
so we make zabbix point to the apache document root
```
ln -s /usr/share/zabbix /var/www/html/zabbix
systemctl restart httpd
```

**g. SELinux will block access lol**\
so we make it not do that
```
setsebool -P httpd_can_network_connect on
```

**h. Start zabbix server and agent process**\
Start zabbix server and agent process and make them start at boot
```
systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm
```

**i. Open zabbix UI web page**\
the default URL for zabbix UI when using apache web server is\
Format: `http://<host-machine-ip-address>/zabbix`\
Example: `http:/192.168.1.23/zabbix`

**NOTE**: to login in the UI the defualt credentials are\
username: Admin\
password: zabbix
