#!/bin/bash

# Restores backup from proxmox_config_backup.sh
#   example: proxmox_config_restore.sh pve_proxmoxhostname_2023-12-02.15.48.10.tar.gz

set -e

if [[ $# -eq 0 ]] ; then
    echo 'Argument missing -> restore.sh pve_proxmoxhostname_2023-12-02.15.48.10.tar.gz'
    exit 1
fi

FOLDER_1="./$1_1"
FOLDER_2="./$1_2"

mkdir -p "$FOLDER_1"
mkdir -p "$FOLDER_2"

tar -zxvf "$1" -C "$FOLDER_1"
find "$FOLDER_1" -name "*.tar" -exec tar xvf '{}' -C "$FOLDER_2" \;

for i in pve-cluster pvedaemon vz qemu-server; do systemctl stop "$i" || true; done

cp -avr "$FOLDER_2"/* /

rm -r "$FOLDER_1" "$FOLDER_2" || true

read -p "Restore complete. Hit 'Enter' to reboot or CTRL+C to cancel."
reboot