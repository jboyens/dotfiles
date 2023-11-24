{
  cell,
  config,
  ...
}: let
  inherit (config.styling) colors;
  lib = builtins // cell.pkgs.lib // cell.lib;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
        # font = "${fonts.monospace.name}:size=${toString fontSizes.terminal},Symbols Nerd Font Mono:size=${toString fontSizes.terminal}";
      };

      colors = {
        foreground = colors.base05-hex;
        background = colors.base00-hex;
        regular0 = colors.base00-hex;
        regular1 = colors.base08-hex;
        regular2 = colors.base0B-hex;
        regular3 = colors.base0A-hex;
        regular4 = colors.base0D-hex;
        regular5 = colors.base0E-hex;
        regular6 = colors.base0C-hex;
        regular7 = colors.base05-hex;
        bright0 = colors.base03-hex;
        bright1 = colors.base08-hex;
        bright2 = colors.base0B-hex;
        bright3 = colors.base0A-hex;
        bright4 = colors.base0D-hex;
        bright5 = colors.base0E-hex;
        bright6 = colors.base0C-hex;
        bright7 = colors.base07-hex;
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
