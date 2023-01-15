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
enable_network 0 # wait for connection to be logged
quit
ping google.com # sanity check

fdisk -l
dd if=/dev/urandom of=/dev/MY_DRIVE bs=1M status=progress # write random data to disk
parted /dev/MY_DRIVE -- mklabel gpt
parted /dev/MY_DRIVE -- mkpart primary 512MB -8GB
parted /dev/MY_DRIVE -- mkpart primary linux-swap -8GB 100%
parted /dev/MY_DRIVE -- mkpart ESP fat32 1MB 512MB
parted /dev/MY_DRIVE -- set 3 esp on

fdisk -l
cryptsetup luksFormat /dev/MAIN_PARTITION # type in disk password
cryptsetup luksOpen /dev/MAIN_PARTITION cryptroot

mkfs.ext4 -L nixos /dev/mapper/cryptroot
mkswap -L swap /dev/SWAP_PARTITION
swapon /dev/SWAP_PARTITION
mkfs.fat -F 32 -n boot /dev/BOOT_PARTITION

mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix # sanity check
vim /mnt/etc/nixos/configuration.nix # ensure that you add system packages neovim and git, and enable Network Manager.

nixos-install # type in a temporary root password. This password will be erased later.
reboot # unplug usb and harden BIOS
```

Upon logging back in as root:

```sh
nmtui # internet connection if needed
git clone https://git.sr.ht/~bossley9/dotfiles nixos
# create a new flake configuration and copy over the hardware configuration here if necessary.
rm -r /etc/nixos
mv nixos /etc/
```

Finally, build the configuration:

```sh
cd /etc/nixos
# where NAME is the name of the configuration:
nixos-rebuild switch --flake .#NAME
reboot
```

## Post Install

After booting for the first time, there are a few configurations that are cannot automatically be applied.

1. Set your user password with `passwd` after using the initial password to log in.
2. Implicitly remove the root password with `doas passwd -l root`.
2. Change the permissions of the configuration directory.
    ```sh
    doas chown -Rv USERNAME:wheel /etc/nixos
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
    bw login # be sure to log out after every use as it does not re-prompt MFA.
    ```
6. Copy over all Yubikey ECC/RSA keys.
    ```sh
    mkdir -p ~/.ssh
    cd ~/.ssh
    ssh-keygen -K # without passphrase
    # see https://sam.bossley.us/thoughts/22/11/enhancing-security-with-yubikeys for details
    ```
