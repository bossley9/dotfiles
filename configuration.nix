{ config, pkgs, ... }:

let
  hostid = "2bf9900d";
  hostname = "horizon";
  wifi_enable = true;
  wifi_interface = "wlp1s0";
  eth_interface = "enp0s31f6";
  user = "sam";
  timezone = "America/Los_Angeles";
  locale  = "en_US.UTF-8";
  keymap  = "us";
  ssh_port = 8008;
in
{

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules
  ];

  # hardware microcode
  hardware.cpu.intel.updateMicrocode = true;

  # boot
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/efi";

      # bootloader
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };

      timeout = 0;
    };

    supportedFilesystems = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];
  };

  # /tmp tmpfs
  boot.tmpOnTmpfs = true;
  boot.cleanTmpDir = true;

  # networking
  networking.hostId = hostid;
  networking.hostName = hostname;
  networking.networkmanager.enable = wifi_enable;
  # global useDHCP flag is deprecated and explicitly set to false
  networking.useDHCP = false;
  networking.interfaces.${eth_interface}.useDHCP = true;
  networking.interfaces.${wifi_interface}.useDHCP = true;

  # localization
  services.timesyncd.enable = true;
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-i24n";
    keyMap = keymap;
  };
  fonts = {
    enableFontDir = true;
  };

  # zfs
  # scrub pools once a week as recommended
  services.zfs.autoScrub.enable = true;
  # don't import all pools at once to prevent corruption
  boot.zfs.forceImportAll = false;

  # users
  users = {
    motd = "";

    users = {
      ${user} = {
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" ];
        home = "/home/" + user;
        initialPassword = "test";
        isNormalUser = true;
      };
    };
  };
  
  environment.etc.profile.text = pkgs.lib.mkBefore ''
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"

    # as recommended by the NSA
    umask 0077
  '';

  # system packages
  environment.systemPackages = with pkgs; [
    # essentials
    doas git
    bc

    # system utilities
    parted
  ];

  # include all module documentation
  # documentation.nixos.includeAllModules = true;

  # shell
  programs.mksh.enable = true;
  environment.shellAliases = {
    cp = "cp -v";
    mv = "mv -v";
    rm = "rm -v";
    md = "mkdir -p";
    grep = "grep --color=auto";
    ls = "ls --color=auto --group-directories-first";
    sed = "sed --posix";
    bc = "bc -w -q";
    g = "git";
  };

  # editor
  programs.neovim.enable = true;

  # ssh
  services.openssh = {
    enable = true;
    ports = [ ssh_port ];
    # disable root ssh login
    permitRootLogin = "no";
  };

  # elevated privileges
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [
    { groups = [ "wheel" ]; noPass = false; keepEnv = true; }
  ];

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
  # disable loading kernel modules after boot
  security.lockKernelModules = true;

  # systemd
  # reduce the amount of journaling
  services.journald.extraConfig =
  ''
    SystemMaxUse=250M
    MaxRetentionSec=7day
  '';

  # power consumption and lid events
  services.logind.lidSwitch = "suspend";
  services.logind.extraConfig = "HandlePowerKey=hibernate";
  services.tlp.enable = true;
}

