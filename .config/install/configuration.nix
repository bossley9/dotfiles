# NixOS configuration

# help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help')

{ config, pkgs, ... }:

# change these variables as desired
let
  # required
  hostid = "12345678";
  eth_interface = "eth0";
  # optional
  user = "sam";
  hostname = "sunset";
  timezone = "America/Los_Angeles";
  locale  = "en_US.UTF-8";
  wifi_enable = false;
  ssh_port = 2067;
in
{
  imports = [
    # include results of hardware scan
    ./hardware-configuration.nix
  ];

  # boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ]; # boot from zfs

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.editor = false;

  # prevent external pointer errors
  boot.loader.grub.copyKernels = true;

  # networking
  networking.hostName = hostname;
  networking.hostId = hostid;
  networking.networkmanager.enable = wifi_enable;
  # global useDHCP flag is deprecated and set to false explicitly
  networking.useDHCP = false;
  # need to explicitly enable DHCP for each eth interface
  networking.interfaces.${eth_interface}.useDHCP = true;

  # localization
  services.timesyncd.enable = true;
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      roboto
      source-code-pro
      wqy_zenhei
    ];
  };

  # zfs
  # recommended to automatically scrub pools once a week
  services.zfs.autoScrub.enable = true;
  # don't import all pools at once bc they can get corrupted
  boot.zfs.forceImportAll = false;

  # user
  users.extraUsers.${user} = {
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/" + user;
    initialPassword = "test";
    isNormalUser = true;
    shell = pkgs.mksh;
  };

  environment.etc = {
    profile = {
      text = ''
        # as recommended by the NSA
        umask 0077
      '';
    };
    issue.enable = false;
  };

  # system-wide packages
  # nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # basics
    envsubst
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
    # unable to relink /bin/sh to dash
    # due to NixOS dependency on bash
    dash
    mmv
    unzip wget
    pfetch
    pwgen
    (htop.overrideAttrs (oldAttrs: rec {
      src = fetchTarball {
        url = "https://github.com/bossley9/htop/archive/master.tar.gz";
      };
    }))

    nethack

    # TODO
    # suckless utilities
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchTarball {
        url = "https://github.com/bossley9/st/archive/master.tar.gz";
      };
    }))

    xorg.xorgserver xorg.xinit
    xorg.xauth
    xorg.xsetroot
    xorg.xinput
    xdotool
    xorg.xev

    bspwm sxhkd
    polybar
    (picom.overrideAttrs (oldAttrs: rec {
      src = fetchTarball {
        url = "https://github.com/ibhagwan/picom/archive/next-rebase.tar.gz";
      };
    }))

    firefox
    # TODO
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
    gimp inkscape
    mpd ncmpcpp
    ncspot
    alsaUtils
    pamixer
    pulseaudio
    # TODO
    # pulseaudio-alsa
    pavucontrol
    # pipewire

    redshift
    adapta-gtk-theme

    # discord
    pandoc
    networkmanager
    aria
    qrencode

    # Unity development
    # unityhub

    # TODO extra installation
  ];

  # ssh
  services.openssh.enable = true;
  services.openssh.ports = [ ssh_port ];

  # security and system hardening
  # clear /tmp tmpfs
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  # doas
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [
    { groups = [ "wheel" ]; noPass = false; keepEnv = true; }
  ];
  # disable root ssh login
  services.openssh.permitRootLogin = "no";
  # resource limits
  security.pam.loginLimits = [
    # suppress mandatory code dump generation
    { domain = "*"; item = "core"; type = "soft"; value = "0"; }
    { domain = "*"; item = "core"; type = "hard"; value = "unlimited"; }
    # maximum file size: 25 GB or 25000 MB or 25000000 KB
    { domain = "*"; item = "fsize"; type = "hard"; value = "25000000"; }
    # number of files able to be open by domain at once: 2^16
    { domain = "*"; item = "nofile"; type = "soft"; value = "65536"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "65536"; }
    # maximum number of processes per user: 2^11 (root: 2^16)
    { domain = "*"; item = "nproc"; type = "soft"; value = "2048"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "2048"; }
    { domain = "root"; item = "nproc"; type = "hard"; value = "65536"; }
    # default niceness
    { domain = "*"; item = "priority"; type = "soft"; value = "0"; }
    # prevent non-root from running minimal niceness
    { domain = "*"; item = "nice"; type = "hard"; value = "-19"; }
    { domain = "root"; item = "nice"; type = "hard"; value = "-20"; }
  ];
  # hide unowned processes
  security.hideProcessInformation = true;

  # systemd
  # reduce the amount of journaling
  services.journald.extraConfig = ''
    SystemMaxUse=250M
    MaxRetentionSec=7day
  '';
  # power and lid events
  services.logind.lidSwitch = "suspend";
  services.logind.extraConfig = "HandlePowerKey=hibernate";

  # audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # miscellaneous services
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.autorun = false;
  services.tlp.enable = true;

  # OpenGL for 32-bit programs such as Wine
  hardware.opengl.driSupport32Bit = true;
}
