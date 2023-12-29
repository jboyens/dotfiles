{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs;
in {
  # portal = {
  #   enable = true;
  #   extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  #
  #   wlr = {
  #     enable = false;
  #     settings = {
  #       screencast = {
  #         output_name = "DP-4";
  #         max_fps = 30;
  #         chooser_type = "simple";
  #         chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  #       };
  #     };
  #   };
  # };
}
