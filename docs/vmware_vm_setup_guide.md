## 1. Create a New VM (Empty)
* In VMware Workstation: File → New Virtual Machine → Typical → Next
* OS: Doesn’t matter for now (PXE will install the OS)
* Disk: Create a virtual disk (enough space for your OS, e.g., 20 GB)
* Finish creating the VM without installing an OS.

---

## 2. Configure Network for PXE
* Open VM Settings → Network Adapter
* Set Network connection to Bridged (so it’s on the same subnet as your PXE host)
* Optional: Make sure Connect at power on is checked.

---

## 3. Set VM to Boot from Network (PXE)
* Power on the VM and immediately press F2 (enter BIOS/UEFI setup).
* Go to Boot options.
* Move Network/PXE Boot to the top of the boot order.
* Save and exit BIOS.
* Some VMware versions also allow: VM Settings → Options → Boot Options → Force BIOS setup.

---

## 4. Boot the VM
* Power on the VM.
* You should see a message like:
* Press F12 to boot from network
* Press F12.
* The VM will contact your DHCP/PXE server, get an IP, and show your PXE menu.

---

## 5. Select the PXE Menu Option
* Your PXE menu (from pxelinux.cfg/default) should list: Web, DB, Monitoring, Backup, Security.
* Select the appropriate label or let it default.
* The VM will:
* The VM should:
  * Download vmlinuz and initrd.img from TFTP
  * Load the Kickstart file
  * Begin automated installation of CentOS (from file:// ISO mount in your Option 1 setup).

---

## 6. Let it Finish
* Wait for the installation to complete.
* The VM will reboot automatically (as per Kickstart).
* Check hostname, packages, and post-install scripts to verify it worked.
