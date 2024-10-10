#!/bin/bash

# Prompt for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Get USB location and ISO file from user
read -p "Enter the USB device location (e.g., /dev/sdX): " usb_location
read -p "Enter the path to the Windows 11 ISO file: " iso_location

# Wipe the USB
wipefs -a "$usb_location"

# Create a new partition table and partitions
parted "$usb_location" --script mklabel gpt
parted "$usb_location" --script mkpart BOOT fat32 0% 1GiB
parted "$usb_location" --script mkpart INSTALL ntfs 1GiB 100%
parted "$usb_location" --script quit

# Mount the ISO
mkdir -p /mnt/iso
mount "$iso_location" /mnt/iso

# Format and copy boot files
mkfs.vfat -n BOOT "${usb_location}1"
mkdir -p /mnt/vfat
mount "${usb_location}1" /mnt/vfat
rsync -r --progress --exclude sources --delete-before /mnt/iso/ /mnt/vfat/
mkdir -p /mnt/vfat/sources
cp /mnt/iso/sources/boot.wim /mnt/vfat/sources/

# Format and copy install files
mkfs.ntfs --quick -L INSTALL "${usb_location}2"
mkdir -p /mnt/ntfs
mount "${usb_location}2" /mnt/ntfs
rsync -r --progress --delete-before /mnt/iso/ /mnt/ntfs/

# Cleanup
umount /mnt/ntfs
umount /mnt/vfat
umount /mnt/iso
sync

# Power off the USB device
udisksctl power-off -b "$usb_location"

echo "Bootable USB created successfully!"

