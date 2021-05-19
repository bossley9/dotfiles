# help is availabel in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help')

{ config, pkgs, ... }:

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

  # recommended to automatically scrub pools once a week
  services.zfs.autoScrub.enable = true;

  networking.hostName = "${HOSTNAME}";
  networking.hostId = "${HOSTID}";

  # wifi
  networking.wireless.enable = true;

  # localization
  time.timeZone = "${TIMEZONE:"America/Los_Angeles}";
  i18n.defaultLocale = "${LOCALE:"en_US.UTF-8"}"
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  }

  # global useDHCP flag is deprecated and set to false explicitly
  networking.useDHCP = false;
  # need to explicitly enable DHCP for each eth interface. Example:
  # networking.interfaces.eth0.useDHCP = true;

  # list packages installed in system profile.
  # to search, run 'nix search wget'
  # environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
  # ]

  # X11
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;

  # audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # user
  users.extraUsers.${USER} = {
    createHome = true;
    extraGroups = [ "wheel" ];
    home = "/home/${USER}";
    initialPassword = "test";
    isNormalUser = true;
    shell = pkgs.mksh;
  };

  # ssh
  services.openssh.enable = true;

  # DO NOT change! Read the docs first
  system.stateVersion = "20.09";
}
