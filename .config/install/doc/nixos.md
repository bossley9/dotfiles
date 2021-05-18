## NixOS Installation <a name="nixos-installation">

## Table of Contents

- [Setup](#setup)
- [Boot Start](#boot-start)
- [Internet](#internet)
- [Disk Partitioning](#disk-partitioning)
- [ZFS Installation](#zfs-installation)
- [Operating System Installation](#operating-system-installation)
- [Creating a User](#creating-a-user)

## Setup <a name="setup"></a>

**I'm assuming from this point forward that you know your way around Unix distributions, not to mentions disk images and ISOs.**

- Download the [latest NixOS iso](https://nixos.org/download.html). I chose the minimal ISO version `20.09 x86_64`. I would highly recommend using the provided checksum verification to validate the integrity of the ISO before proceeding.
- Burn the ISO onto a disk. If you are unsure of what tools to use, try looking at my [Archlinux installation](./arch.md#setup).

4. Boot the computer from the live usb. This may require manual BIOS tweaking depending on your machine. Be sure to boot with UEFI if you plan on dual booting with Windows in the future.

## Boot Start <a name="boot-start"></a>

The boot process should eventually land on a virtual terminal prompt.

- Verify the boot mode is UEFI by confirming the output of `ls /sys/firmware/efi/efivars` exists.

- In order to be able to install or setup anything, we need to be able to access elevated privileges. Set the passwords for both the install user and the root user. Don't worry, the actual passwords can be changed later.
  ```
  passwd
  sudo passwd root
  ```
- Then switch to root to make the installation process easier.
  ```
  su -
  ```
- Optionally, if you prefer a vi command mode prompt:
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

Since we will be using ZFS as our filesystem, we will not need to heavily partition the disk as recommended for security. We only need a boot partition and a main partition since the rest will be done through zpools and datasets.

- Determine the disk that will contain the new installation. This can be done with the `fdisk` utility. I will be using and referencing `/dev/sda` as my disk.
  ```
  fdisk -l
  ```
- Use the GNU `parted` utility to use a gpt partition table and create a boot partition of size 200 MB:
  ```
  parted /dev/sda mklabel gpt
  parted /dev/sda mkpart non-fs 0% 200
  parted /dev/sda set 1 boot on
  mkfs.fat -F32 /dev/sda1
  ```
- Create a root partition to install ZFS.
  ```
  parted /dev/sda mkpart primary 200 100%
  ```

## ZFS Installation <a name="zfs-installation"></a>

- First, verify the ZFS module is loaded.
  ```
  modprobe zfs
  ```
- Make note of the partition device names.
  ```
  fdisk -l
  ```
- We need to make note of the id corresponding to the root partition. It is possible for the disk identifiers to change during boot, which will cause ZFS to fail. Using partition ids ensure that ZFS will never fail. In my case, my root partition is `/dev/sda2`:
  ```
  ls -l /dev/disk/by-partuuid | grep sda2
  ```
  Remember this value.
- Create a ZFS pool with compression and encryption using the partition uuid we noted earlier.
  All these options are recommended and will save you headaches later.
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
             -O compression=lz4        \
             -O encryption=aes-256-gcm \
             -O keyformat=passphrase   \
             -O keylocation=prompt     \
             zroot /dev/disk/by-partuuid/PART_UUID_HERE
  ```
- Create datasets as "pseudo partitions" to separate data from system files. This is extremely useful for snapshots and boot environments.
  ```
  zfs create -o mountpoint=legacy zroot/root
  zfs create -o mountpoint=none zroot/data
  zfs create -o mountpoint=legacy zroot/data/home
  zfs create -o mountpoint=legacy zroot/data/root
  ```
- Export and reimport the datasets to validate the configurations. This is required.
  ```
  zpool export zroot
  zpool import -d /dev/disk/by-partuuid/PART_UUID_HERE -R /mnt zroot -N
  ```
- Load zfs key for native encryption.
  ```
  zfs load-key zroot
  ```
- Then mount all datasets, where `/dev/sda1` is the EFI partition created earlier.
  ```
  mount -t zfs zroot/root /mnt
  mkdir /mnt/home
  mount -t zfs zroot/data/home /mnt/home
  mkdir /mnt/root
  mount -t zfs zroot/data/root /mnt/root
  mkdir /mnt/efi
  mount /dev/sda1 /mnt/efi -o nodev,nosuid,noexec
  ```
- Set the bootfs property for bootloaders.
  ```
  zpool set bootfs=zroot/root zroot
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
- Generate a unique identifier to use as the host id:
  ```
  head -c 8 /etc/machine-id
  ```
- Edit `/mnt/etc/nixos/configuration.nix` to edit the NixOS configuration file and add the following settings:
  ```
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = ["zfs"]; # boot from zfs
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  ...
  networking.hostId = "HOST_ID_HERE";
  ```
- Then install the operating system.
  ```
  nixos-rebuild switch
  nixos-install
  ```
- Shutdown the system.
  ```
  shutdown -h now
  ```
  Then safely remove the usb drive.
- Power on the machine. You likely need to change the BIOS/UEFI settings of your machine in order to tell your motherboard the location of the efi boot partition. If the boot lands on a login prompt, you have successfully completed the initial installation!
- Log in to root using `root` as the username and the password you created earlier.
- Sync the clock to the time zone specified.
  ```
  hwclock --systohc
  ```

## Creating a User <a name="creating-a-user"></a>

- Create a new user. This will be the main user in which you will use to log into and
  interact with your system.
  ```
  useradd -m -g wheel sam
  passwd sam
  ```
  Then logout and log back in as the newly created user.
