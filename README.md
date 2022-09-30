# dotfiles

## Table of Contents

1. [Foreward](#foreward)
2. [Installation](#installation)
3. [Post Install](#post-install)

## Foreward

This is a collection of all my dotfiles I've accumulated and configured over the years after hopping across many distros and operating systems (MacOS, Linux, BSDs, etc). The following instructions are mostly personal instructions for me in the case I need to reclone my configuration elsewhere.

## Installation

This installation process heavily draws from the [official NixOS installation manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation) as well as the [full disk encryption wiki](https://nixos.wiki/wiki/Full_Disk_Encryption). Please be familiar with both before continuing. I'm also assuming you have a strong knowledge of Unix operating systems and have already flashed and booted the installer in UEFI mode.

```sh
sudo -i
set -o vi

# you can skip this if you are using ethernet
systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "WIFI_NAME"
set_network 0 psk "WIFI_PASSWORD"
set_network 0 key_mgmt WPA-PSK
enable_network 0
quit
ping nixos.org # sanity check

fdisk -l
dd if=/dev/urandom of=/dev/MY_DRIVE bs=1M status=progress # write random data to disk
parted /dev/MY_DRIVE -- mklabel gpt
parted /dev/MY_DRIVE -- mkpart primary 512MB -8GB
parted /dev/MY_DRIVE -- mkpart primary linux-swap -8GB 100%
parted /dev/MY_DRIVE -- mkpart ESP fat32 1MB 512MB
parted /dev/MY_DRIVE -- set 3 esp on

fdisk -l
cryptsetup luksFormat /dev/ROOT_PARTITION # type in disk password
cryptsetup luksOpen /dev/ROOT_PARTITION cryptroot

mkfs.ext4 -L nixos /dev/mapper/cryptroot
mkswap -L swap /dev/SWAP_PARTITION
swapon /dev/SWAP_PARTITION
mkfs.fat -F 32 -n boot /dev/BOOT_PARTITION

mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix # sanity check
vim /mnt/etc/nixos/configuration.nix
```

Ensure that you add system packages `vim` and `git`. Be sure to enable `NetworkManager`.

```sh
nixos-install # type in root password
reboot # unplug usb and harden BIOS
```

Upon logging back in:

```sh
nmtui # internet connection if needed
git clone https://git.sr.ht/~bossley9/dotfiles nixos
cp /etc/nixos/hardware-configuration.nix nixos/
rm -r /etc/nixos
mv nixos /etc/
```

Then create a `/etc/nixos/secrets.nix` file containing secrets:

```
ip a
```

```nix
{
  username = "username";
  email = "email"; # used for git
  hostname = "hostname";
  arch = "intel or amd";
  ethEnabled = true;
  ethInterface = "em0"; # any ethernet interface
  wifiEnabled = true;
  wifiInterface = "iwm0"; # any wifi interface
  isDesktop = true; # optimize for performance
}
```

Finally, subscribe to the following channels and build the configuration:

```sh
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nixos-rebuild switch
reboot
```

## Post Install

After booting for the first time, there are a few configurations that are cannot automatically be applied.

1. Set your user password after using the initial password to log in.
2. Change the permissions of the configuration directory.
    ```sh
      doas chown -R USERNAME:wheel /etc/nixos
    ```
3. Open `about:preferences#search` in Firefox and set the default search engine to a more privacy-respecting search engine.
4. Install the following extensions for Firefox, making sure all run in private windows if applicable.
    * uBlock Origin by Raymond Hill
    * Firefox Multi-Account Containers by Mozilla Firefox
    * Bitwarden - Free Password Manager by Bitwarden Inc. (make sure to set the server URL)
    * Vimium-FF by Stephen Blott and Phil Crosby
5. Set your Bitwarden server.
    ```sh
      bw config server https://myvault.example.com
      bw login
    ```
6. Copy over all Yubikey ecdsa keys.
    ```sh
      mkdir -p ~/.ssh
      cd ~/.ssh
      ssh-keygen -K # without passphrase
      # then rename keys
    ```
