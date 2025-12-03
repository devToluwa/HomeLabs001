# FTP Setup Guide

## Step 1
Install vsftpd
`dnf install vsftpd -y`

## Step 2
Enable and start services
```
systemctl enable vsftpd
systemctl start vsftpd
systemctl status vsftpd
```

## Step 3 Configure vsftpd
edit the file below
`vi /etc/vsftpd/vsftpd.conf`

Add these lines or uncomment them in the file
```
anonymous_enalbe=NO
local_enable=YES
write_enable=YES
chroot_local_user
allow_writeable_chroot
```

save then restart
`systemctl restart vsftpd`

## Step 4 Create the FTP Server
```
useradd ftpuser1
passwd ftpuser
```

## Step 5 Make the home directory non-writeable
`chmod a-w /home/ftpuser1`

create an upload folder
```
mkdir /home/ftpuser1/upload
chown ftpuser1:ftpuser1 /home/ftpuser1/upload
```

## Step 6 Open the firewall
```
firewall-cmd --zone=public --add-service=ftp --permanent
firewall-cmd --reload
```

## Step 8 Test your FTP Server
 - type `ftp://<your-server-ip` in windows file manager
 - Use FileZilla/WinSCP
 - User and Password is what you set
