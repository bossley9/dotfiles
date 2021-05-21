# NixOS configuration

# help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help')

{ config, pkgs, ... }:

# change these variables as desired
let
  # required
  hostid =    "12345678";
  eth_interface =    "eth0";
  # optional
  user =      "sam";
  hostname =  "sunset";
  timezone =  "America/Los_Angeles";
  locale  =   "en_US.UTF-8";
  wifi_enable = false;
in
{
  imports = [
    # include results of hardware scan
    ./hardware-configuration.nix
  ];

  # boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ]; # boot from zfs
  # boot.loader.grub.efiInstallAsRemovable = false;
  # boot.loader.grub.enable = false;
  # boot.loader.grub.device = "nodev";

  # networking
  networking.hostName = hostname;
  networking.hostId = hostid;
  networking.wireless.enable = wifi_enable;
  # global useDHCP flag is deprecated and set to false explicitly
  networking.useDHCP = false;
  # need to explicitly enable DHCP for each eth interface
  networking.interfaces.${eth_interface}.useDHCP = true;

  # localization
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # zfs
  # recommended to automatically scrub pools once a week
  services.zfs.autoScrub.enable = true;

  # user
  users.extraUsers.${user} = {
    createHome = true;
    extraGroups = [ "wheel" ];
    home = "/home/" + user;
    initialPassword = "test";
    isNormalUser = true;
    shell = pkgs.mksh;
  };

  # audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # list packages installed in system profile.
  # to search, run 'nix search wget'
  environment.systemPackages = with pkgs; [
    doas
    git
    vim
    bc

    mandoc
    neovim ripgrep nodejs nodePackages.npm fzf
    vifm
    # sc-im requires manual building
  ];

  # ssh
  services.openssh.enable = true;

  # DO NOT change! Read the docs first
  system.stateVersion = "20.09";
}
