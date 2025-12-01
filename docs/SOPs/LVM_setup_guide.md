# LVM Setup Guide
## What we're gonna do
- Create a 6GB partition
- Initialize it for LVM
- Create a **Physical Volume (PV)**
- Create a **Volume Group (VG)**
- Create a **Logical Volume (LV)**
- formate, mount and persist

## Note flow is
PV → VG(PE) → LV → MountPoint

PV = Physical Volume
VG = Volume Group
PE = Physical Extents
LV = Logical Volume

# Steps
## Step 1
Create a partition (e.g `/dev/sdb`)
`fdisk /dev/sdb`

## Step 2
Inside fdisk, we select the following options consecutively
`n` = new partition
`p` = primary
`1` = partition number
`<enter>` = default first sector
`+6G` = size (6GB)
`t` = change partition type
`8e` = LVM type
`w` = write to disk

## Step 3
reload using `partprobe`

## Step 4
verify partition has been made `lsblk`

## Step 5
Create the **physical volume (PV)**
you'll see this sdb1 in the lsblk command under the drive you used initially in step 1
`pvcreate /dev/sdb1`

## Step 6
Create the **volume group (VG)**
`vgcreate volume_group_name /dev/drive_path_partition`
`vgcreate MyVG /dev/sdb1`

## Step 7
Create the logical volume
`lvcreate -L 4G -n logical_volume_name volume_group_name`
`lvcreate -L 4G -n MyLV MyVG`

to create with extents use
`lvcreate -L 20 -n LVName VGName`
`lvcreate -L 20 -n MyLV MyVG`

## Step 8
format the drive
look up how to format your drive format, `mkfs.xfs` works for my drive format
`mkfs.xfs /dev/MyVG/MyLV`

## Step 9
Create directory for mount, mount it then add it to the `/etc/fstab` file
`mount /dev/MyVG/MyLV /mnt/mydata`

## Step 10
in `/etc/fstab` add the mounted directory to the file so you dont break your system lol
`UUID="{numbers_you_get_from_lsblk}" /mnt/mydata   xfs   deafaults   0 0`


## Useful commands


|**Purpose**             | **Commands**                     |
| ---------------------- | -------------------------------- |
| View PV's              | `pvdisplay`, `pvs {pv_name}`     |
| View VG's              | `vgdisplay`, `vgs {vg_name}`     |
| View LV's              | `lvdisplay`, `lvs {lv_name}`     |
| Scan for LVMs          | `lvscan`, `pvscan`, `vgscan`     |
| List block devices     | `lsblk`                          |
| Extend LV              | `lvextend -L +1G /dev/myVG/myLV` |
| Resize FS after extend | `resize2fs /dev/myVG/myLV` and or `xfs_growfs /dev/myVG/myLV` |
| Remove LV              | `lvremove /dev/myVG/myLV`        |
| Remove VG              | `vgremove myVG`                  |
| Remove PV              | `pvremove /dev/sdb1`             |

















