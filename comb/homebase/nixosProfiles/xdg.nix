{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  xdg = {
    enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings = {
        screencast = {
          output_name = "DP-4";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${nixpkgs.slurp}/bin/slurp -f %o -or";
        };
      };
      extraPortals = with nixpkgs; [xdg-desktop-portal-gtk];
    };
  };
}
