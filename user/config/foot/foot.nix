{ config, pkgs, ... }:

{
  enable = true;
  server.enable = true;
  settings = {
    main = {
      font = "JetBrainsMono:size=10";
      pad = "8x8";
    };
    colors = {
      background = "2E3440";
      foreground = "D8DEE9";
      # black
      regular0 = "3B4252";
      bright0 = "434C5E";
      # red
      regular1 = "BF616A";
      bright1 = "BF616A";
      # green
      regular2 = "A3BE8C";
      bright2 = "A3BE8C";
      # yellow
      regular3 = "EBCB8B";
      bright3 = "EBCB8B";
      # blue
      regular4 = "81A1C1";
      bright4 = "81A1C1";
      # magenta
      regular5 = "B48EAD";
      bright5 = "B48EAD";
      # cyan
      regular6 = "88C0D0";
      bright6 = "8FBCBB";
      # white
      regular7 = "E5E9F0";
      bright7 = "ECEFF4";
    };
    key-bindings = {
      show-urls-launch = "Control+Shift+l"; # clear existing bindings we want to use
      font-increase = "Control+Shift+k";
      font-decrease = "Control+Shift+j";
      scrollback-up-half-page = "Control+Shift+u";
      scrollback-down-half-page = "Control+Shift+d";
    };
    tweak = {
      font-monospace-warn = "no"; # reduces startup time
      sixel = "yes";
    };
  };
}
