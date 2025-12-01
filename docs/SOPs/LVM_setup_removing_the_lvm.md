# LVM Setup removing the LVM
This is a safe way to remove the LVM partition & cleanup

## Step 1
Unmount the mounted drive used for the LVM
`umount /mnt/basketball`

## Step 2
Check if it is unmounted
`df -h | grep "basketball"`

## Step 3 
Remove the logical volume
`lv remove /dev/vg/lv`

## Step 4
Remove the volume group
`vgremove vg`

## Step 5
Remove the physical volume
`pvremove /dev/sdb1`

## Step 6
Delete the partition with fdisk if you want

## Step 7
edit the `/etc/fstab` if you deleted the partition
