{ config, pkgs, ... }:

{
  enable = true;
  commandLineArgs = [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
  ];
  extensions = [
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
    { id = "honjmojpikfebagfakclmgbcchedenbo"; } # Nord theme
  ];
}
