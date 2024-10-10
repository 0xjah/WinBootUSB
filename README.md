# Create Windows 11 Bootable USB

## Overview
This script creates a bootable USB drive for Windows 11 using a specified ISO file.

## Requirements
- Linux system with root access
- `parted`, `wipefs`, `mkfs.vfat`, `mkfs.ntfs`, `rsync`, and `udisksctl` installed

## Usage

1. Download the script:
 ```bash
 git clone https://github.com/0xjah/WinBootUSB.git
 cd WinBootUSB
 ```
2. Make the script executable:
```bash
chmod +x WindowsUSB.sh
```
3. Run the script as root:
```bash
sudo ./WindowsUSB.sh
```
4. Follow the prompts to enter the USB device location and the Windows ISO file path.

## NOTES
- Ensure you select the correct USB device to avoid data loss.
- Back up any important data from the USB drive before running the script.
- The script requires root privileges, so use `sudo` to run it.
