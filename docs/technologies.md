# Technologies Used in HomeLabs001

This document outlines the tools used in the HomeLabs001 project, a homelab simulating a company IT infrastructure with multiple CentOS VMs managed via Ansible. The setup includes a web server hosting a WordPress site, a database storing its data, a monitoring server for health checks, a backup server for data protection, and a security server for hardening. Each tool is chosen for simplicity, compatibility with CentOS, and relevance to sysadmin/DevOps roles.

| VM Role | IP Address | Tools | Purpose |
|---------|------------|-------|---------|
| **Common** (All VMs) | 192.168.221.129–133 | **chrony** | Synchronizes system time across all VMs to ensure consistent logs and database operations. |
| | | **firewalld** | CentOS default firewall to secure network traffic on all VMs. |
| | | **epel-release** | Adds the EPEL repository for additional packages like fail2ban. |
| | | **prometheus-node-exporter** | Collects system metrics (CPU, memory, disk) from all VMs for monitoring. |
| | | **fail2ban** | Blocks brute-force attacks on SSH and web services across all VMs. |
| **Web** | 192.168.221.129 | **httpd** | Apache web server to host the WordPress site, serving web pages to users. |
| | | **php** | Processes dynamic content for WordPress, enabling user logins and posts. |
| | | **php-mysqlnd** | PHP extension to connect WordPress to the MariaDB database. |
| | | **git** | Clones the WordPress repository for easy deployment without manual downloads. |
| **Database** | 192.168.221.130 | **mariadb-server** | MariaDB database to store WordPress data (user accounts, posts, etc.). |
| | | **mariadb** | Client tools to manage the WordPress database. |
| **Monitoring** | 192.168.221.131 | **cockpit** | Web-based dashboard to monitor CPU, memory, and services on all VMs. |
| **Backup** | 192.168.221.132 | **rsync** | Syncs WordPress files and database dumps to a backup directory. |
| | | **cronie** | Schedules automated nightly backups of web and database data. |
| **Security** | 192.168.221.133 | **clamav** | Antivirus to scan WordPress uploads for malware, ensuring security. |

## Notes
- **WordPress Integration**: The web server (192.168.221.129) hosts WordPress, which connects to the database server (192.168.221.130) for data storage. Users can sign in and create posts, simulating a company website.
- **Monitoring**: Cockpit on the monitoring server (192.168.221.131) provides a dashboard to check VM health. Node Exporter on all VMs collects metrics for potential future Prometheus integration.
- **Backup**: The backup server (192.168.221.132) uses rsync to copy web files and database dumps nightly, ensuring data protection.
- **Security**: Fail2ban on all VMs and ClamAV on the security server (192.168.221.133) protect against attacks and scan for malware.
- **Ansible Automation**: All tools are installed and configured via Ansible roles in `ansible/roles/`, applied through `sites.yml`.

This setup is lightweight for a single laptop running VMware and showcases sysadmin skills for job applications. See `ansible_setup.md` for setup details and `README.MD` for project overview.
