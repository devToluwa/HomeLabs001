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
a. Install Zabbix repository
   Disable Zabbix packages provided by EPEL, if you have it installed. Edit file `/etc/yum.repos.d/epel.repo` and add the following statement.
```
[epel]
...
excludepkgs=zabbix*
```

Proceed with installing zabbix repository.
