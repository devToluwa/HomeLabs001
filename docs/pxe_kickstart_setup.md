# PXE Boot + Kickstart Deployment Guide

## 1. Overview

PXE (Preboot Execution Environment) allows VMs or physical machines to boot over the network. By combining PXE with Kickstart files, you can automatically install CentOS/RHEL on multiple VMs with zero manual input.

**Flow:**

VM boots -> PXE server -> TFTP server serves bootloader -> Downloads kernel & initrd
-> Uses Kickstart file -> Installs OS automatically

yaml
Copy code

---

## 2. Requirements

- PXE-enabled network (all VMs on same subnet)  
- DHCP server (to assign IPs and tell PXE server where to boot)  
- TFTP server (to serve bootloader and kernel/initrd)  
- Apache/Nginx server (to serve Kickstart files)  

**Current setup:**

- Masternode IP: `192.168.14.161`  
- Kickstart files hosted at: `http://192.168.14.161/kickstarts/`  
- VMs are on the same subnet: `192.168.14.0/24`  

---

## 3. Install Required Services on Masternode

```bash
sudo dnf install -y dhcp-server tftp-server syslinux httpd
sudo systemctl enable --now dhcpd tftp httpd
4. Configure TFTP
TFTP serves the PXE boot files (pxelinux.0, kernel, initrd).

bash
Copy code
sudo mkdir -p /var/lib/tftpboot/pxelinux.cfg
sudo cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
sudo cp /usr/share/syslinux/menu.c32 /var/lib/tftpboot/
sudo cp /path/to/centos9/vmlinuz /var/lib/tftpboot/
sudo cp /path/to/centos9/initrd.img /var/lib/tftpboot/
5. Configure DHCP for PXE Boot
Edit /etc/dhcp/dhcpd.conf:

dhcp
Copy code
subnet 192.168.14.0 netmask 255.255.255.0 {
  range 192.168.14.200 192.168.14.250;
  option routers 192.168.14.1;
  option domain-name-servers 192.168.14.1;

  next-server 192.168.14.161;  # PXE/TFTP server IP
  filename "pxelinux.0";
}
Restart DHCP:

bash
Copy code
sudo systemctl restart dhcpd
6. Configure PXE Boot Menu
Create /var/lib/tftpboot/pxelinux.cfg/default:

plaintext
Copy code
DEFAULT menu.c32
PROMPT 0
TIMEOUT 50
ONTIMEOUT local

MENU TITLE PXE Boot Menu

LABEL web
  MENU LABEL Install Web Server
  KERNEL vmlinuz
  APPEND initrd=initrd.img inst.ks=http://192.168.14.161/kickstarts/vm1-web-ks.cfg

LABEL db
  MENU LABEL Install DB Server
  KERNEL vmlinuz
  APPEND initrd=initrd.img inst.ks=http://192.168.14.161/kickstarts/vm2-db-ks.cfg

LABEL monitoring
  MENU LABEL Install Monitoring Server
  KERNEL vmlinuz
  APPEND initrd=initrd.img inst.ks=http://192.168.14.161/kickstarts/vm3-monitoring-ks.cfg

LABEL backup
  MENU LABEL Install Backup Server
  KERNEL vmlinuz
  APPEND initrd=initrd.img inst.ks=http://192.168.14.161/kickstarts/vm4-backup-ks.cfg

LABEL security
  MENU LABEL Install Security Server
  KERNEL vmlinuz
  APPEND initrd=initrd.img inst.ks=http://192.168.14.161/kickstarts/vm5-security-ks.cfg
7. Firewall & SELinux
Allow PXE, TFTP, and HTTP through the firewall:

bash
Copy code
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=tftp --permanent
sudo firewall-cmd --reload
8. Testing PXE Boot
Start a blank VM.

Configure its network adapter to boot from PXE.

It should display the PXE menu.

Select the desired role (or default) → VM downloads Kickstart → auto installs OS.

9. Verification
Boot all 5 VMs from PXE.

Verify OS is installed automatically and hostname matches Kickstart.

Optional: run your scripts/testing_kickstarts to confirm HTTP access.

10. Documentation Notes
Store this guide as docs/pxe_kickstart_setup.md.

Include screenshots of PXE menu and successful installs.

Log each VM installation in a text file for future reference.

