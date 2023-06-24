{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  # colorscheme = inputs.stylix.config.lib.stylix;
in {
  # nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = foot ] && export TERM=xterm-256color
  # '';

  programs = {
    foot.enable = true;
    foot.package = nixpkgs.foot;
    foot.settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
      };
      # cursor.color = "${colorscheme.colors.base00} ${colorscheme.colors.base05}";
      # colors = {
      #   alpha = 1.0;
      #   background = "${colorscheme.colors.base00}";
      #   foreground = "${colorscheme.colors.base05}";
      #   regular0 = "${colorscheme.colors.base00}";
      #   regular1 = "${colorscheme.colors.base08}";
      #   regular2 = "${colorscheme.colors.base0B}";
      #   regular3 = "${colorscheme.colors.base0A}";
      #   regular4 = "${colorscheme.colors.base0D}";
      #   regular5 = "${colorscheme.colors.base0E}";
      #   regular6 = "${colorscheme.colors.base0C}";
      #   regular7 = "${colorscheme.colors.base05}";
      #   bright0 = "${colorscheme.colors.base03}";
      #   bright1 = "${colorscheme.colors.base08}";
      #   bright2 = "${colorscheme.colors.base0B}";
      #   bright3 = "${colorscheme.colors.base0A}";
      #   bright4 = "${colorscheme.colors.base0D}";
      #   bright5 = "${colorscheme.colors.base0E}";
      #   bright6 = "${colorscheme.colors.base0C}";
      #   bright7 = "${colorscheme.colors.base07}";
      # };
      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
      };
    };
  };

  home.packages = with nixpkgs; [foot];
}
