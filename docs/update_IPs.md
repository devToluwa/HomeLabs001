# Update Service and Config references IP Addresses

Wherever your old IPs were hard coded, you must update them

Typically your PXE/KICKSTART + server automation setup


| Service / Tool | File / Path | What to Update |
|--------------------|----------------------------|-----------------------------|
| DHCP | `/etc/dhcp/dhcpd.conf` | `next-server` and `filename` entries (if pointing to old PXE ip)
| PXE/TFTP | `/var/lib/tftpboot/pxelinux.cfg/default` or `configs/pxe_default` | change the `append intrd` if it contains old IP or NFS path |
| Kickstart | `/var/www/html/kickstarts/*.ks` | change `url --url=http://<old_ip>/path` to `http://new_ip/path` |
| HTTP | `/etc/httpd/conf/httpd.conf` or virtual host files | Update `ServerName`, `ServerAlias`, or `Listen` directives if they reference old IPs |
| Ansible Inventory | `ansible/inventory/hosts.ini` | Update the IPs of hosts and servers |


