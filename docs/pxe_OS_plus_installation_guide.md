# PXE + Kickstart OS Installation Guide

## 1. Overview
This guide assumes your PXE environment is already set up:
* TFTP server serving `vmlinuz` and `initrd.img`
* DHCP server configured for PXE boot
* PXE menu pointing to Kickstart files
* Kickstart files accessible via HTTP

This guide adds the steps to host CentOS packages and update Kickstart files so the VMs can fully auto-install CentOS.

---

## 2. Requirements
* PXE host with Apache/Nginx running
* CentOS-9 ISO on the PXE host (only needed once)
* Access to `/var/www/html/kickstarts/` for hosting ISO contents
* Current Kickstart files in `kickstart/`

---

## 3. Mount the ISO on PXE Host
1. Create a mount point and mount the IOS:
```
sudo mkdir -p /mnt/centos9
sudo mount -o loop /path/to/CentOS-Stream-9-latest-x86_64-dvd1.iso /mnt/centos9
```
* `-o loop` → treats the ISO file as a virtual disk so it can be mounted like a normal filesystem.	
* This allows you to access the contents of the ISO without burning it to a CD or using a physical device.
* Keep this mount active while performing PXE installations.
* No need to copy files; the installer will pull packages directly from the mounted ISO

2. Verify access(optional)
`ls /mnt/centos9`
You should see directories like `Packages`, `images`, `EFI`, etc.


---
## 4. Update Kickstart Files
Add the `url` directive after `install` in each Kickstart file so the installer knows where to pull packages:
Check the top of the file
```
install
url --url=file:///mnt/centos9/
text
```
Repeat this update for all 5 Kickstart files (`vm1-web-ks.cfg` → `vm5-security-ks.cfg`).

---

## 5. Firewall & SELinux
Ensure HTTP is accessible for PXE-hosted packages:
```
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload
```

---

## 6. Test PXE Installation
1. Start a blank VM.
2. Boot from PXE.
3. Select the appropriate role from the PXE menu.
4. The VM should:
   - Boot kernel + initrd
   - Load Kickstart
   - Pull packages from HTTP
   - Install CentOS automatically with specified configuration

---

## 7. Verification
Confirm the hostname matches the Kickstart file.
Check installed packages (`nginx`, `httpd`, etc.).
Verify post-install scripts executed (e.g., `/etc/motd`, `/etc/sudoers.d/toluwa`).

---

This guide assumes PXE + Kickstart setup is complete. After completing these steps, the lab VMs will fully auto-install CentOS using network-hosted packages, no ISO attached to each VM.


