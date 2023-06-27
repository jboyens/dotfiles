{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (inputs.nixpkgs-wayland.packages) foot;
  inherit (inputs.cells.homebase) nixosProfiles;

  styles = nixosProfiles.styles.config;
  inherit (styles.styling) fonts fontSizes colors;
in {
  # nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = foot ] && export TERM=xterm-256color
  # '';

  programs.foot = {
    enable = true;
    package = foot;
    settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
        font = "${fonts.monospace.name}:size=${toString fontSizes.terminal}";
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
      };
    };
  };
}
