{ config, pkgs, lib, ... }:

{
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraConfig = builtins.concatStringsSep "\n" [
    ''
    lua << EOF
    require('defaults')
    require('core')
    require('plugins')
    EOF
    ''
    (lib.strings.fileContents ./vars.vim)
    (lib.strings.fileContents ./scripts/explorer.vim)
    (lib.strings.fileContents ./scripts/sessions.vim)
    (lib.strings.fileContents ./scripts/terminals.vim)
    (lib.strings.fileContents ./scripts/highlights.vim)
    (lib.strings.fileContents ./scripts/vcs.vim)
    (lib.strings.fileContents ./scripts/formatter.vim)
  ];
  coc = {
    enable = true;
    pluginConfig = (lib.strings.fileContents ./scripts/coc.vim);
    settings = {
      "suggest.autoTrigger" = "trigger";
      "coc.preferences.extensionUpdateCheck" = "never";
      "coc.preferences.messageLevel" = "warning";
      "coc.preferences.formatOnSaveFiletypes" = [
        "cs"
        "css"
        "javascript"
        "json"
        "markdown"
        "scss"
        "typescript"
        "typescriptreact"
      ];
    };
  };
}
