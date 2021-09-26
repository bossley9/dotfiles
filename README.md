# NixOS Installation <a name="nixos-installation">

## Table of Contents

- [Setup](#setup)
- [Boot Start](#boot-start)
- [Internet](#internet)
- [Disk Partitioning](#disk-partitioning)
- [ZFS Installation](#zfs-installation)
- [Operating System Installation](#operating-system-installation)

## Setup <a name="setup"></a>

**I'm assuming from this point forward that you know your way around \*nix distributions.**

- Download the [latest NixOS iso](https://nixos.org/download.html).
  I chose the minimal ISO version `20.09 x86_64`.
  I would highly recommend using the provided checksum verification to validate the integrity of the image before proceeding.
- Burn the image onto a disk. Here are a list of methods for doing so:
  - [Balena Etcher](https://www.balena.io/etcher) (cross-platform)
  - [Rufus](https://rufus.ie) (Windows)
  - [Mkusb](https://help.ubuntu.com/community/mkusb) (Linux/Ubuntu)
  - Command line ($ denotes elevated privileges:
    ```
    $ dd bs=4M if=/path/to/img of=/dev/sdx status=progress
    ```
- Boot the computer from the live usb.
  This may require manual BIOS tweaking depending on your machine.
  Be sure to boot with UEFI.

## Boot Start <a name="boot-start"></a>

The boot process should eventually land on a virtual terminal prompt.

- Verify the boot mode is UEFI by confirming the output of `ls /sys/firmware/efi/efivars` exists.

- In order to be able to install or setup anything, we need to be able to access elevated privileges.
  Set the passwords for both the local user and the root user.
  Don't worry about the actual passwords - they can be changed later.
  ```
  passwd
  sudo passwd root
  ```
- Then switch to root to make the installation process easier.
  ```
  su -
  ```
- Optionally set vi mode.
  ```
  set -o vi
  ```

## Internet <a name="internet"></a>

- You can test for internet with the following command:
  ```
  ping nixos.org
  ```
  If an internet connection has already been established, you will see an incremental
  output of packets. If not, a DNS error will return.
  ```
  ping: nixos.org: Name or service not known
  ```
  Type `ctrl+c` to stop the program. If an internet connection has been established,
  you can skip ahead to the next step. This should automatically be the case for ethernet.
  Wifi, however, is a bit trickier.
- Assuming no internet connection exists, use `ip link` to retrieve the names of all
  network cards. Remember the names of the cards that display.
  On most machines there are at least three types of network cards:

  - `lo` represents a loopback device, which is kind of like a virtual network
    (this is how 127.0.0.1 and other localhost ports are accessed).
  - `eth0` represents an ethernet (wired) network card. Usually the interface is given a
    more specific name, such as `enp34s0`.
  - `wlan0` represents a wireless network card. As with the ethernet card, this is
    usually passes under a more specific name, like `wlp1s0`. In this guide I use
    wlan0 to represent the wireless card name.

- Let's establish an internet connection using WPA Supplicant:
  - Run the following command according to the NixOS documentation to establish a connection with a trusted network.
    ```
    wpa_supplicant -B -i interface -c <(wpa_passphrase 'SSID' 'key')
    ```
  - Verify `ping nixos.org` produces a response. Do not proceed and repeat this
    section until a response appears.

## Disk Partitioning <a name="disk-partitioning"></a>

We will be using ZFS as our primary filesystem.
We only need a boot partition and a main partition since the rest will be done through zpools and datasets.

- Determine the disk that will contain the new installation. This can be done using the `parted` utility. I will be using and referencing `/dev/sda` as my disk.
  ```
  parted -l
  ```
- Use the `parted` utility to create a gpt partition table.
  ```
  parted /dev/sda mklabel gpt
  ```
- Create boot and main partitions.
  ```
  # efi
  parted /dev/sda mkpart "EFI" fat32 0% 100
  parted /dev/sda set 1 esp on
  # main
  parted /dev/sda mkpart "main" 100 100%
  ```

## ZFS Installation <a name="zfs-installation"></a>

- First verify the ZFS module is loaded.
  ```
  modprobe zfs && echo loaded!
  ```
- Make note of the partition numbers.
  In my case, my efi partition is 1 and my root partition is 2, corresponding to `/dev/sda1` and `/dev/sda2` respectively.
  I will reference these names hereafter.
  ```
  parted -l
  ```
- We need to make note of the id corresponding to the root partition.
  It is possible for the disk identifiers to change during boot, which may cause ZFS to fail.
  Using partition ids ensure that ZFS will never fail.
  ```
  ls -l /dev/disk/by-partuuid | grep sda2
  ```
  Remember this value.
- Create a ZFS pool with compression and encryption using the partition uuid we noted earlier.
  All these ZFS options are recommended and will likely save you headaches later.
  You will be prompted for a encryption passphrase for the filesystem.
  ```
  zpool create -f -o ashift=12         \
             -O acltype=posixacl       \
             -O relatime=on            \
             -O xattr=sa               \
             -O dnodesize=legacy       \
             -O normalization=formD    \
             -O mountpoint=none        \
             -O canmount=off           \
             -O devices=off            \
             -R /mnt                   \
             -O compression=on         \
             -O encryption=aes-256-gcm \
             -O keyformat=passphrase   \
             -O keylocation=prompt     \
             zroot /dev/disk/by-partuuid/PART_UUID_HERE
  ```
  You can use `zfs list` to verify the zpool was successfully created.
- Create datasets to separate data from system files.
  This is extremely useful for snapshots and boot environments.
  We need to use legacy mountpoints for NixOS to mount them in the correct order on boot.
  We will also reserve a 1 GB dataset for emergency cases where the filesystem is full to prevent breakages (see [reservations](https://nixos.wiki/wiki/NixOS_on_ZFS)).
  ```
  zfs create -o mountpoint=legacy zroot/ROOT
  zfs create -o mountpoint=none zroot/data
  zfs create -o mountpoint=legacy zroot/data/home
  zfs create -o mountpoint=legacy zroot/data/root
  zfs create -o refreservation=1G -o mountpoint=none zroot/reserved
  ```
- Export and reimport the datasets to validate the configurations.
  **This is required.**
  To get easy access to the partition uuid without having to type it all out, use `ls /dev/disk/by-partuuid`.
  ```
  zpool export zroot
  zpool import -d /dev/disk/by-partuuid/PART_UUID_HERE -R /mnt zroot -N
  ```
- Load the zfs key you specified earlier for native encryption.
  ```
  zfs load-key zroot
  ```
- Then mount all datasets and partitions.
  ```
  mount -t zfs zroot/ROOT /mnt
  mkdir /mnt/home
  mount -t zfs zroot/data/home /mnt/home
  mkdir /mnt/root
  mount -t zfs zroot/data/root /mnt/root
  mkdir /mnt/efi
  mount /dev/sda1 /mnt/efi -o nodev,nosuid,noexec
  ```
  You can use `mount` to verify all datasets (in addition to the efi partition) have been mounted properly.
- Set the bootfs property for bootloaders.
  ```
  zpool set bootfs=zroot/ROOT zroot
  ```
- Create a zpool cache file.
  ```
  zpool set cachefile=/etc/zfs/zpool.cache zroot
  ```

## Operating System Installation <a name="operating-system-installation"></a>

- Generate a basic configuration for the operating system.
  ```
  nixos-generate-config --root /mnt
  ```
- Generate a unique identifier to use as the host id.
  Setting the host id is required for ZFS:
  ```
  head -c 8 /etc/machine-id
  ```
- Determine the networking interfaces for your machine.
  This will be needed for ethernet and DHCP:
  ```
  ip a
  ```
- Edit the system configuration and add the `networking.hostId` generated earlier in addition to other settings required by [this page](https://nixos.wiki/wiki/NixOS_on_ZFS).
  ```sh
  vim /mnt/etc/nixos/configuration.nix
  ```
- Then install the operating system. This may take a while. You will also be prompted for a root password.
  ```
  nixos-install
  ```
- Shutdown the system.
  ```
  shutdown -h now
  ```
  Then safely remove the usb drive.
  You've successfully completed the installation!
- It is **highly** recommended to harden your motherboard hardware BIOS post-installation.
  This includes, but is not limited to:
  - setting a BIOS password
  - removing unused boot options
  - disabling unused ports or buses
