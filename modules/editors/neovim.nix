{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;
  cfg = config.programs.neovim;

  vimrc = "/etc/vim/vimrc";

in

{

  options = {

    programs.neovim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable neovim as the default editor.";
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.neovim ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MYVIMRC = vimrc;
    };

    environment.etc."vim/vimrc".source = ./init.vim;

    environment.shellAliases = {
      vim = "nvim -u " + vimrc;
      vi = "vim";
      v = "vim";
    };

  };

}
