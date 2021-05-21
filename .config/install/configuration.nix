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

  # system hardening
  boot.cleanTmpDir = true;
  boo.tmpOnTmpfs = true;

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
  # prevent external pointer errors
  boot.loader.grub.copyKernels = true;
  # recommended to automatically scrub pools once a week
  services.zfs.autoScrub.enable = true;
  # don't import all pools at once bc they can get corrupted
  boot.zfs.forceImportAll = false;

  # user
  users.extraUsers.${user} = {
    createHome = true;
    extraGroups = [ "wheel" ];
    home = "/home/" + user;
    initialPassword = "test";
    isNormalUser = true;
    shell = pkgs.mksh;
  };

  # list packages installed in system profile.
  # to search, run 'nix search wget'
  environment.systemPackages = with pkgs; [
    # basics
    mksh bc
    doas git vim

    # core
    mandoc
    neovim ripgrep nodejs nodePackages.npm fzf
    vifm
    # TODO
    # sc-im requires manual building

    # development
    abook
    nodePackages.typescript deno yarn
    python
    rustup
    texlive.combined.scheme-full
    # rss reader
    newsboat
    # ssh
    openssh
    # tuning and power management
    tlp brightnessctl
    # various utils
    dash
    mmv
    unzip wget

    # the hack
    nethack

    xorg.xorgserver xorg.xinit
    xorg.xsetroot
    xorg.xinput
    xdotool
    xorg.xev
    # xorg.xf86videointel

    bspwm sxhkd
    polybar
    # TODO picom ibhagwan

    # TODO
    firefox
    # firefox-bin
    # firefox-tridactyl
    tridactyl-native
    # firefox-ublock-origin
    # firefox-extensions-multi-account-containers

    firejail

    feh
    mpv
    ffmpeg
    screenkey
    youtube-dl
    xclip
    slop
    zathura girara mupdf
    imagemagick
    # gimp inkscape
    mpd ncmpcpp
    ncspot
    # spotify
    alsaUtils
    pamixer
    pulseaudio
    # TODO
    # pulseaudio-alsa
    pavucontrol
    # pipewire
    # scrcpy
    # lmms
    # kdenlive
    # TODO
    # obs-studio
    # linuxPackages-libre.v4l2loopback
    # discord

    # hsetroot
    redshift
    # liberation_ttf
    source-code-pro
    wqy_zenhei
    # breeze-icons
    adapta-gtk-theme
    roboto

    pandoc
    networkmanager
    # nm-connection-editor
    aria
    qrencode

    # TODO ...
  ];

  # ssh
  services.openssh.enable = true;

  # security
  security.doas.enable = true;
  security.doas.extraRules = [
    { groups = [ "wheel" ]; noPass = false; keepEnv = true; }
  ];

  # audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # DO NOT change! Read the docs first
  system.stateVersion = "20.09";
}
