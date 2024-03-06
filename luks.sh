#!/bin/bash 
read -p "Please provide the path to your disk eg(/dev/vda,/dev/nvme0n1..): " disk
read -p "please specify the size of the partition eg ( +2G..): " size
# Creating a 1G partition 
fdisk $disk <<EOF
n
p
1

$size
w
EOF

# Format partition with LUKS encryption
echo "YES" | echo -n "testpass1234@" | cryptsetup luksFormat /dev/vdb1

# Open the encrypted LUKS partition
echo -n "testpass1234@" | cryptsetup luksOpen /dev/vdb1 new

# Create an XFS filesystem
mkfs.xfs /dev/mapper/new

# Creating mount point and add it to /etc/fstab
mkdir /test && echo -n "/dev/mapper/new		/test	xfs	defaults	0 0" >> /etc/fstab

# Generating a random keyfile to useb for decryption
dd if=/dev/urandom of=/root/keyfile bs=1024 count=4

# Adding the KeyFile to the LUKS slots
echo -n "testpass1234@" | cryptsetup luksAddKey  /dev/vdb1 /root/keyfile

# Adding the entry to /etc/crypttab
echo "new	/dev/vdb1	/root/keyfile"  >> /etc/crypttab

# Removing the First Key 
echo "YES" | echo -n "testpass1234@" | cryptsetup luksRemoveKey /dev/vdb1

# Verifying that only one key left
if [ $? -eq 0 ]; then 
	cryptsetup luksDump /dev/vdb1 | awk '/^Keyslots:/,/^$/'
	echo "Key Removed Succesfully" 
else
	echo "Key Removel Failed" 
fi

