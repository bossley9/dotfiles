{ config, pkgs, lib, ... }:

{
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraConfig = ''
    lua << EOF
    require('defaults')
    require('core')
    require('vars')
    require('plugins')
    require('explorer')
    require('sessions')
    require('terminals')
    require('highlights')
    require('vcs')
    require('formatter')
    EOF
  '';
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
