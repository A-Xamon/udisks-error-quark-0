#The error "udisks-error-quark, 0" comes from a Linux service called udisks, which is a daemon that manages storage devices in Linux. The problem occurs when accessing, mounting, or unmounting a device (in my case, the partition of my HDD).

#To fix it, we mount the partition or the disk using the service

sudo udisksctl mount -b /dev/sdb1

#udisksctl is part of the "udisks2" package, mount mounts a disk/partition, and -b specifies what you want to mount, followed by the partition’s location. I use sdb1, but you can use whichever you need by editing it.

#Once mounted by forcing the use of udisks, we check if it's being used in the background
sleep 2
lsof /dev/sdb1

#lsof = LiSt Open Files followed by the partition/disk path

#We remount the file
sudo umount /dev/sdb1
sudo mount /dev/sdb1 /$HOME/media

#We check that the partition is not corrupted
sleep 2
sudo fsck /dev/sdb1

#fsck = FileSystem Check and the partition path

#We restart the daemon service that manages the disks
sleep 2
sudo systemctl restart udisks2


#And it should work now!!
# What should appear after finishing, if we run lsof again, is something like this:

#COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
#Command: File manager of your distro
#PID: process identifier
#USER: your user
#FD: File descriptor, where 45 is the number used to handle the partition
#Type: file type, DIR means directory
#Device: 
#Size/Off: Represents the size of the directory in bytes, in this case the standard size (4KB)
#Node: the "inode number," which is the data structure used by Linux file systems to store information about directories and files
#Name: where the partition data from /dev/sdb1 is stored, which will be in /media/luks/
