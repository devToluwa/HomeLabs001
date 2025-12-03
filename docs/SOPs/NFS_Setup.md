# NFS Server-Client Guide
We will use the below as examples
SERVER: 192.168.123.001
CLIENT: 192.168.123.002

🔵 ON THE SERVER (192.168.123.001)

## Step 1 - Install NFS Packages
`sudo yum install nfs-utils -y`

## Step 2 - Create the folders you want to share
Example shared directory
```
sudo mkdir -p /home/toluwa/nfs_share
sudo chmod 755 /home/toluwa/nfs_share
```

## Step 3 - Configure NFS exports
edit the `/etc/exports` or add it, cause it might not be there
```
sudo vi /etc/exports
/home/toluwa/nfs_share 192.168.123.002(rw,sync,no_root_squash)
```

General Format below
`/path/to/share client.ip/24(options)`

## Step 4 - enable and start NFS services
`systemctl enable --now nfs-server rpcbind`

## Step 5 - export the shared server
`sudo exportfs -arv`

 - `-a` = exports all directories
 - `-r` = re-export
 - `-v` = verbose

## Step 6 - Open Firewall ports
```
sudo firewall-cmd --add-service=nfs --permanenet
sudo firewall-cmd --add-service=mountd --permanent
sudo firewall-cmd --add-service=rpc-bind --permanen`
sudo firewall-cmd --reload
```
🟢 ON THE CLIENT (192.168.123.002)

## Step 1 - Install NFS Packages
`sudo yum install nfs-utils -y`

## Step 2 - Create a mount point
`sudo mkdir -p /mnt/nfs_shared`

## Step 3 - Mount the NFS share
`sudo mount -t nfs 192.168.123.001:/home/toluwa/nfs_share /mnt_shared`

General format below
`sudo mount -t nfs serve.ip/path/to/server/shared_folder /path/to/shared_mount_folder`

## Step 4 (Optional) Make it Persistent after reboot
### NOTE: If you do this the server must be on because we are adding the mount point to the /etc/fstab
if you do this enter the `/etc/fstab` and add the line below

```
vi /etc/fstab
192.168.123.002:/home/toluwa/nfs_share  /mnt/nfs_shared   nfs   defaults   0 0
client.ip/home/toluwa/nfs_share  /mnt/nfs_shared   nfs   defaults   0 0
```



