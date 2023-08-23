{config, ...}: let
  cfg = config.styling;

  background = cfg.colors.withHashtag.base00;
  indicator = cfg.colors.withHashtag.base0B;

  text = cfg.colors.withHashtag.base05;
  urgent = cfg.colors.withHashtag.base08;
  focused = cfg.colors.withHashtag.base0A;
  unfocused = cfg.colors.withHashtag.base03;
in {
  wayland.windowManager.sway.config = {
    fonts = {
      names = [cfg.fonts.sansSerif.name "Font Awesome 5 Pro"];
      size = 12.0;
    };

    colors = {
      inherit background;

      urgent = {
        inherit background indicator text;
        border = urgent;
        childBorder = urgent;
      };

      focused = {
        inherit background indicator text;
        border = focused;
        childBorder = focused;
      };

      focusedInactive = {
        inherit background indicator text;
        border = unfocused;
        childBorder = unfocused;
      };

      unfocused = {
        inherit background indicator text;
        border = unfocused;
        childBorder = unfocused;
      };

      placeholder = {
        inherit background indicator text;
        border = unfocused;
        childBorder = unfocused;
      };
    };
  };
}
