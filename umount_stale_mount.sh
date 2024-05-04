#!/bin/bash
# Umount stale CIFS/SMB or NFS mounts after 300 seconds
# PVE will remount automatically if storage is activated

# Get a list of CIFS/SMB mounts
listsmb=$(mount | grep -E "cifs|smb" | awk '{print $3}')

# Loop through each CIFS/SMB mount
for i in $listsmb; do
    # Check if the mount is stale by trying to list its contents with a timeout of 300 seconds
    timeout 300 ls "$i" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Stale $i"
        echo "Umounting this stale mount"
        umount -f -l "$i" || true  # Forcefully unmount the stale mount
    fi
done

# Get a list of NFS mounts
listnfs=$(mount | grep "nfs" | awk '{print $3}')

# Loop through each NFS mount
for i in $listnfs; do
    # Check if the mount is stale by trying to list its contents with a timeout of 300 seconds
    timeout 300 ls "$i" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Stale $i"
        echo "Umounting this stale mount"
        umount -f -l "$i" || true  # Forcefully unmount the stale mount
    fi
done
