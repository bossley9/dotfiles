{ config, pkgs, lib, ... }:

{
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraConfig = builtins.concatStringsSep "\n" [
    (lib.strings.fileContents ./defaults.vim)
    (lib.strings.fileContents ./core.vim)
    (lib.strings.fileContents ./vars.vim)
    (lib.strings.fileContents ./scripts/explorer.vim)
    (lib.strings.fileContents ./scripts/sessions.vim)
  ];
}
