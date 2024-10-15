{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs lib;
in {
  portal = {
    enable = true;
    # extraPortals = [pkgs.xdg-desktop-portal-hyprland];

    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "DP-4";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
