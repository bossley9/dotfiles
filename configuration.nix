# See configuration.nix(5) or run 'nixos-help' for more information.
# vim:fdm=marker

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
  assert secrets.username != "";
  assert secrets.hostname != "";
  assert with secrets; arch == "amd" || arch == "intel";

{
  imports = [
    ./hardware-configuration.nix
    ./user/home.nix
  ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # hardware and boot {{{

  boot.initrd.availableKernelModules = builtins.concatLists [
    # load cryptroot modules first to make boot disk decryption fast
    (if secrets.arch == "intel" then [ "aesni_intel" ] else [])
    [ "cryptd" ]
  ];
  boot.kernelModules = builtins.concatLists [
    (if secrets.arch == "amd" then [ "kvm_amd" ] else [])
    (if secrets.arch == "intel" then [ "kvm_intel" ] else [])
    # camera and microphone
    [ "v4l2loopback" "snd-aloop" ]
  ];
  # https://www.reddit.com/r/NixOS/comments/p8bqvu/how_to_install_v4l2looback_kernel_module/
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
  ];
  boot.extraModprobeConfig = ''
    # exclusive_caps: only show device when actually streaming
    # card_label: name
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    editor = false; # False recommended for security reasons.
  };
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  # if too small, builds will fail with "no space left on device"
  boot.tmpOnTmpfsSize = "30%";

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = false;
    cpu."${secrets.arch}".updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      # better hardware acceleration
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        amdvlk
      ];
    };
  };

  # }}}

  # networking and localization {{{

  networking.hostName = secrets.hostname;
  networking.useDHCP = false; # False recommended for security reasons.
  networking.wireless.enable = false;
  networking.networkmanager = {
    enable = if secrets.wifiInterface != "" then true else false;
    # randomizing mac addresses messes up most wifi connections
    wifi.scanRandMacAddress = false;
  };
  networking.interfaces = builtins.removeAttrs {
    ${secrets.ethInterface}.useDHCP = true;
    ${secrets.wifiInterface}.useDHCP = true;
  } (builtins.concatLists [
    (if secrets.ethInterface == "" then [ secrets.ethInterface ] else [])
    (if secrets.wifiInterface == "" then [ secrets.wifiInterface ] else [])
  ]);

  services.timesyncd.enable = true; # slightly more lightweight than ntpd
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # }}}

  # audio {{{

  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
  };

  # }}}

  # user environment and packages {{{

  environment.systemPackages = with pkgs; [
    # core
    vim
    pinentry-curses # for gnupg
    # utils
    bc w3m file gzip
    # nix-specific utils
    nix-index # for nix-locate
    nix-prefetch nix-prefetch-scripts # for nix-prefetch and nix-prefetch-git
  ];

  users.users."${secrets.username}" = {
    isNormalUser = true;
    initialPassword = "test1234";
    extraGroups = [ "wheel" "network" "networkmanager" "plugdev" ];
  };

  # shell configuration
  environment.shells = with pkgs; [
    oksh
    dash
  ];
  users.defaultUserShell = pkgs.oksh;
  environment.binsh = "${pkgs.dash}/bin/dash";

  # }}}

  # security {{{

  # elevated privileges
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; noPass = true; keepEnv = true; }
    ];
  };

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

  # disable loading kernel modules after boot
  security.lockKernelModules = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
  };

  # }}}

  # optimization {{{
  # reduce the amount of systemd journaling
  services.journald.extraConfig =
  ''
    SystemMaxUse=250M
    MaxRetentionSec=7day
  '';
  # automatically garbage collect nix
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  # }}}

  # keyboard layout {{{
  hardware.keyboard.zsa.enable = true;
  # }}}

  # power consumption and lid events
  services.logind.lidSwitch = "suspend";
  services.logind.extraConfig = "HandlePowerKey=suspend";
  services.tlp.enable = !secrets.isDesktop;

  system.stateVersion = "22.05";
}

