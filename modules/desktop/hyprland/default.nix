{ options, config, lib, pkgs, inputs, ... }:
with lib;
with lib.my;
let
  inherit (config.stylix) fonts;
  cfg = config.modules.desktop.hyprland;
  colorscheme = config.lib.stylix;
in {
  options.modules.desktop.hyprland = { enable = mkBoolOpt false; };

  # config.wayland.windowManager.hyprland = {enable = true;};
  config.programs.hyprland.enable = true;
}
