{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
in {
  services.fnott = {
    enable = true;

    settings = {
      main = {
        default-timeout = 10;
        title-font = lib.mkForce "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        summary-font = lib.mkForce "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        body-font = lib.mkForce "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
      };
    };
  };
}
