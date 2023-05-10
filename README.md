# dotfiles

## Table of Contents

1. [Foreward](#foreward)
2. [Installation](#installation)
3. [Post Install](#post-install)
4. [Installation (Darwin)](#installation-darwin)
5. [Available Configurations](#available-configurations)

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
3. Change the permissions of the configuration directory.
    ```sh
    doas chown -Rv USERNAME:wheel /etc/nixos
    ```
4. Open `about:preferences#search` in Firefox and set the default search engine to a more privacy-respecting search engine.
5. Make sure all policy-installed extensions run in private windows if applicable.
6. Set your Bitwarden server.
    ```sh
    bw config server https://myvault.example.com
    bw login # be sure to log out after every use as it does not re-prompt MFA.
    ```
7. Copy over all Yubikey ECC/RSA keys.
    ```sh
    mkdir -p ~/.ssh
    cd ~/.ssh
    ssh-keygen -K # without passphrase
    # see https://sam.bossley.us/thoughts/22/11/enhancing-security-with-yubikeys for details
    ```

## Installation (Darwin)

1. Install the [Nix package manager](https://nixos.org/download.html#nix-install-macos). At the time of writing, the current package manager version is 2.15.0. Afterwards I prefer to reboot to ensure a clean state even if this isn't strictly necessary.
    ```sh
    sh <(curl -L https://nixos.org/nix/install)
    sudo reboot
    ```
    If ssl certificates aren't recognized by the nix daemon, you may need to manually modify the environment to make them visible:
    ```sh
    sudo launchctl setenv NIX_SSL_CERT_FILE $NIX_SSL_CERT_FILE
    sudo launchctl kickstart -k system/org.nixos.nix-daemon
    ```
2. Enable nix flakes.
    ```sh
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```
3. Install [nix-darwin](https://github.com/LnL7/nix-darwin) which allows us to declaratively manage an entire MacOS system*. We will convert this to a flake later since nix-darwin doesn't yet support flakes out of the box. (*MacOS is still pretty locked down but nix-darwin helps bridge the gap.)
    ```sh
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
    Would you like to edit the default configuration.nix before starting? [y/n] n
    Would you like to manage <darwin> with nix-channel? [y/n] y
    Would you like to load darwin configuration in /etc/bashrc? [y/n] y
    Would you like to load darwin configuration in /etc/zshrc? [y/n] y
    Would you like to create /run? [y/n] y
    ```
    You can ignore any error pertaining `/etc/nix/nix.conf` linking.
4. Clone these dotfiles.
    ```sh
    git clone https://github.com/bossley9/dotfiles
    ```
5. Create a basic configuration in `~/.nixpkgs/darwin-configuration.nix`. We need this first to bootstrap a non-flake configuration:
    ```nix
    { config, pkgs, ... }:

    {
    environment.systemPackages = with pkgs; [
        htop
        neovim
    ];

    programs.zsh.enable = true;

    services.nix-daemon.enable = true;
    nix.package = pkgs.nix;
    system.stateVersion = 4;
    }
    ```
6. Build the configuration.
    ```sh
    darwin-rebuild switch
    ```
7. Now build the new flake configuration.
    ```sh
    cd path/to/dotfiles
    darwin-rebuild switch --flake .#
    ```

## Available Configurations

These are the configurations I have defined for my devices:

* **bastion**: a powerful desktop with an AMD Ryzen 9 3900x and AMD Radeon RX 6600
* **aegir**: an 11th-gen 13 inch Framework laptop
* **C02FL5MBMD6M**: an Intel i7 Macbook Pro for work
