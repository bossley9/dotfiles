{ config, pkgs, ... }:

{
  # hardware and boot {{{
  boot.initrd.availableKernelModules = [
    # load cryptroot modules first to make boot disk decryption fast
    "cryptd"
  ];
  boot.kernelModules = [
    "kvm_amd"
    # camera and microphone
    "v4l2loopback" "snd-aloop"
  ];
  hardware.cpu.amd.updateMicrocode = true;

  # }}}

  # networking and localization {{{

  networking.hostName = "bastion";
  networking.networkmanager.enable = false;
  networking.interfaces.enp34s0.useDHCP = true;

  # }}}
}
