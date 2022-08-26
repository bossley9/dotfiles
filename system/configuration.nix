# See configuration.nix(5) or run 'nixos-help' for more information.

{ config, pkgs, ... }:

let
  secrets = import ../secrets.nix;
in
  assert secrets.username != "";
  assert secrets.hostname != "";
  assert with secrets; cpu == "amd" || cpu == "intel";

{
  imports = [
    ./hardware-configuration.nix
    ../user/home.nix
  ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    editor = false; # False recommended for security reasons.
  };
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  boot.tmpOnTmpfsSize = "10%";

  hardware = {
    enableRedistributableFirmware = true;
    cpu."${secrets.cpu}".updateMicrocode = true;
  };

  networking.hostName = secrets.hostname;
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.useDHCP = false; # False recommended for security reasons.
  networking.interfaces.enp34s0.useDHCP = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    w3m
    nix-index
  ];

  users.users."${secrets.username}" = {
    isNormalUser = true;
    initialPassword = "test1234";
    extraGroups = [ "wheel" ];
  };

  # shell configuration
  environment.shells = with pkgs; [
    oksh
    dash
  ];
  users.defaultUserShell = pkgs.oksh;
  environment.binsh = "${pkgs.dash}/bin/dash";

  # elevated privileges
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; noPass = false; keepEnv = true; }
      { groups = [ "wheel" ]; cmd = "nixos-rebuild"; noPass = true; keepEnv = true; }
      { groups = [ "wheel" ]; cmd = "shutdown"; noPass = true; keepEnv = true; }
      { groups = [ "wheel" ]; cmd = "reboot"; noPass = true; keepEnv = true; }
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.05";
}

