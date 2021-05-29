## NixOS Installation <a name="nixos-installation">

## Table of Contents

- [Setup](#setup)
- [Boot Start](#boot-start)
- [Internet](#internet)
- [Disk Partitioning](#disk-partitioning)
- [ZFS Installation](#zfs-installation)
- [Operating System Installation](#operating-system-installation)
- [Creating a User](#creating-a-user)
- [Configuration Tweaking](#configuration-tweaking)
- [Cloning](#cloning)

## Setup <a name="setup"></a>

**I'm assuming from this point forward that you know your way around Unix distributions, not to mentions disk images and ISOs.**

- Download the [latest NixOS iso](https://nixos.org/download.html). I chose the minimal ISO version `20.09 x86_64`. I would highly recommend using the provided checksum verification to validate the integrity of the ISO before proceeding.
- Burn the ISO onto a disk. If you are unsure of what tools to use, try looking at my [Archlinux installation](./arch.md#setup).

4. Boot the computer from the live usb. This may require manual BIOS tweaking depending on your machine. Be sure to boot with UEFI if you plan on dual booting with Windows in the future.

## Boot Start <a name="boot-start"></a>

The boot process should eventually land on a virtual terminal prompt.

- Verify the boot mode is UEFI by confirming the output of `ls /sys/firmware/efi/efivars` exists.

- In order to be able to install or setup anything, we need to be able to access elevated privileges. Set the passwords for both the install user and the root user. Don't worry about the actual passwords - they can be changed later.
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
- Use the GNU `parted` utility to use a gpt partition table and create a boot partition of size ~100 MB:
  ```
  parted /dev/sda mklabel gpt
  parted /dev/sda mkpart non-fs 0% 100
  parted /dev/sda set 1 boot on
  mkfs.fat -F32 /dev/sda1
  ```
- Create a root partition to install ZFS.
  ```
  parted /dev/sda mkpart primary 100 100%
  ```

## ZFS Installation <a name="zfs-installation"></a>

- First, verify the ZFS module is loaded.
  ```
  modprobe zfs
  ```
- Make note of the partition device names. In my case, my efi partition is `/dev/sda1` and my root partition is `/dev/sda2`. I will reference these hereafter.
  ```
  fdisk -l
  ```
- We need to make note of the id corresponding to the root partition. It is possible for the disk identifiers to change during boot, which will cause ZFS to fail. Using partition ids ensure that ZFS will never fail.
  ```
  ls -l /dev/disk/by-partuuid | grep sda2
  ```
  Remember this value.
- Create a ZFS pool with compression and encryption using the partition uuid we noted earlier. All these ZFS options are recommended and will likely save you headaches later. You will be prompted for a encryption passphrase for the filesystem.
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
- Create datasets as "pseudo partitions" to separate data from system files. This is extremely useful for snapshots and boot environments. We need to use legacy mountpoints for NixOS to mount them in the correct order on boot.
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
- Load the zfs key you specified earlier for native encryption.
  ```
  zfs load-key zroot
  ```
- Then mount all datasets, including the EFI partition created earlier.
  ```
  mkdir -p /mnt/efi
  mkdir -p /mnt/usr/home
  mkdir -p /mnt/root
  mount -t zfs zroot/root /mnt
  mount -t zfs zroot/data/home /mnt/usr/home
  mount -t zfs zroot/data/root /mnt/root
  mount /dev/sda1 /mnt/efi -o nodev,nosuid,noexec
  ```
  You can use `mount` to verify all datasets (in addition to the efi partition) have been mounted properly.
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
- Generate a unique identifier to use as the host id. Setting the host id is required for ZFS:
  ```
  head -c 8 /etc/machine-id
  ```
- Determine your ethernet interface for your machine. This will be needed for ethernet DHCP:
  ```
  ip a
  ```
- Download my NixOS configuration and substitute the corresponding requried variables. The other variables are optional and can be adjusted if desired. Then replace the current configuration with the new configuration
  ```
  curl https://raw.githubusercontent.com/bossley9/dotfiles/master/.config/install/configuration.nix -o configuration.nix
  # edit variables as necessary
  vim configuration.nix
  mv configuration.nix /mnt/etc/nixos/configuration.nix
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
- Power on the machine. You likely need to change the BIOS/UEFI settings of your machine in order to tell your motherboard the location of the efi boot partition. If the boot lands on a login prompt, you have successfully completed the initial installation!
- Log in to the new user you created in the configuration file, using the temporary `test` password.
- Change the user password.
  ```
  passwd
  ```

## Cloning <a name="cloning"></a>

- Clone this repository to your home folder using the steps outlined below.
  ```sh
  cd $HOME
  git clone --recursive https://github.com/bossley9/dotfiles.git .
  ```
- Log out and log back in as the main user.
  ```
  exit
  ```
- Run the install script I have created:
  ```sh
  chmod +x $XDG_CONFIG_HOME/install/nixos.sh
  sh $XDG_CONFIG_HOME/install/nixos.sh
  ```
- Reboot to allow changes to take effect.
  ```
  reboot
  ```
- It is **highly** recommended to harden your BIOS post-installation. This includes, but is not limited to:
  - setting a BIOS password
  - removing unused boot options
  - disabling unused ports or buses
