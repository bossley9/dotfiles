{ config, pkgs, ... }:

{
  # hardware and boot {{{

  boot.initrd.availableKernelModules = [
    "aesni_intel"
    # load cryptroot modules first to make boot disk decryption fast
    "cryptd"
  ];
  boot.kernelModules = [
    "kvm-intel"
    # camera and microphone
    "v4l2loopback"
    "snd-aloop"
  ];
  hardware.cpu.intel.updateMicrocode = true;

  # }}}

  # networking and localization {{{

  networking.hostName = "aegir";
  networking.networkmanager = {
    enable = true;
    # randomizing mac addresses messes up most wifi connections
    wifi.scanRandMacAddress = false;
  };
  networking.interfaces.wlp170s0.useDHCP = true;
  networking.firewall.allowedTCPPorts = [
    19000 # expo server
  ];


  # }}}

  services.tlp.enable = true;
}
