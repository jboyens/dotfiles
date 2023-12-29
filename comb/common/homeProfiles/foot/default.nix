{cell, ...}: let
  inherit (cell) lib;
in {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
      };

      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        show-urls-launch = "Control+Shift+u";
        unicode-input = "none";
      };
    };
  };
}
