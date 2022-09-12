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
    (lib.strings.fileContents ./scripts/terminals.vim)
    (lib.strings.fileContents ./scripts/highlights.vim)
    (lib.strings.fileContents ./scripts/vcs.vim)
    (lib.strings.fileContents ./scripts/formatter.vim)
  ];
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.nix
  plugins = with pkgs.vimPlugins; [
    # functional
    FixCursorHold-nvim
    fzf-vim
    vim-gitgutter
    git-blame-nvim
    vim-commentary
    vim-surround
    fern-vim
    # cosmetic
    vim-polyglot
    nord-vim
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
