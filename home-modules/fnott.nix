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
        background = colors.base00 + "FF";
        border-color = colors.base0D + "FF";
        title-color = colors.base05 + "FF";
        title-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        summary-color = colors.base05 + "FF";
        summary-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        body-color = colors.base05 + "FF";
        body-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
      };

      low = {
        background = colors.base00 + "FF";
        border-color = colors.base0D + "FF";
        title-color = colors.base05 + "FF";
        title-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        summary-color = colors.base05 + "FF";
        summary-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        body-color = colors.base0A + "FF";
        body-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
      };

      normal = {
        background = colors.base00 + "FF";
        border-color = colors.base0D + "FF";
        title-color = colors.base05 + "FF";
        title-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        summary-color = colors.base05 + "FF";
        summary-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        body-color = colors.base05 + "FF";
        body-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
      };

      critical = {
        background = colors.base00 + "FF";
        border-color = colors.base0D + "FF";
        title-color = colors.base08 + "FF";
        title-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        summary-color = colors.base08 + "FF";
        summary-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        body-color = colors.base08 + "FF";
        body-font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
      };
    };
  };
}
