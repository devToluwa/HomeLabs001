# Samba Setup

## Step 1 Install Samba & Tools
```
yum install samba samba-client samba-common policycoreutils-python-utils -y
```
---

samba: Main Server package ( includes smbd & nmbd ) 
samba-client: let’s you connect to other SMB shares from linux
samba-common: common files needed for both server and client
policycoreutils-python-utils: gives us the semange tools for SELinux context changes

---

## Step 2 Create a shared folder and samba user
```
sudo mkdir -p /srv/samba/shared
sudo useradd -M -s /sbin/nologin smbuser1
sudo smbpasswd -a smbuser1
```
-M: no home directory | 
-s /sbin/nologin: no shell access | 
smbpasswd -a: adds to samba password DB

---

## Step 3 Create a shared folder and samba user and set permissions
We make the samba user own the folder
```
sudo chown -R smbuser1:smbuser1 /srv/samba/shared
sudo chown -R 0775 /srv/samba/shared
```

---

## Step 4 Configure SELinux
We tell  SELinux this folder is safe for samba writes
```
sudo semanage fcontext -a -t samba_share_t "/srv/samba/shared(/.*)?"
restorecon -Rv /srv/samba/shared
setsebool -P samba_export_all_rw on
```
semange - Manages SElinux file context descriptions

[-t samba_share_t] applies the SElinx type [samba_share_t] which samba needs to read and write files
“/srv/samba/shared(/.*)?” the path pattern

/srv/samba/shared - the directory itself
–a add a new file
(/.*) -  any file or folder inside it, recursively
restorecon -  changes SELinux boolean value ( on / off settings for security policies )
–P makes the changes persistent across reboots
[Samba_export_all_rw] a boolean value that allows samba to read/write to all exported shares with proper SELinux labels

---

## In Summary
Label the directory for samba -> semange fcontext
Apply the label -> restorecon...
Label the directory for samba -> setsebool...

Without these steps above, SELinux would block samba access even if normal linux permissions looks correct

---

## Step 5 Update Samba config
In  /etc/samba/smb.conf we add:
```
[shared]
        path = /srv/samba/shared
        browseable = yes
        writable = yes
        guest ok = no
        read only = no
        forceuser = smbuser1
        create mask = 0664
        directory mask = 0775
        valid users = smbuser1

```

---

## Step 6 restart the services
```
sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload
``

---

## Step 7 restart the services
```
sudo systemctl restart smb nmb
sudo systemctl enable smb nmb
```

---

## Step 8 Access your shared folder on windows
Put this in your windows file explorer or press Windows+R and put this in
\\<server-ip-address>
for example, look at the below
\\192.168.14.153

