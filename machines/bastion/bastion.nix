{ config, pkgs, ... }:

{
  # hardware and boot {{{

  boot.initrd.availableKernelModules = [
    # load cryptroot modules first to make boot disk decryption fast
    "cryptd"
  ];
  boot.kernelModules = [
    "kvm-amd"
    # camera and microphone
    "v4l2loopback"
    "snd-aloop"
    # focusrite audio interface
    "snd_usb_audio"
  ];
  hardware.cpu.amd.updateMicrocode = true;
  # virtualization
  virtualisation.libvirtd.enable = true;

  # }}}

  # networking and localization {{{

  networking.hostName = "bastion";
  networking.networkmanager.enable = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowedTCPPorts = [
    19000 # expo server
  ];

  # }}}
}
