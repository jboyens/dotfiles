{config, ...}: let
  inherit (config.styling) colors fonts;

  background = colors.withHashtag.base00;
  indicator = colors.withHashtag.base0B;

  text = colors.withHashtag.base05;
  urgent = colors.withHashtag.base08;
  focused = colors.withHashtag.base0A;
  unfocused = colors.withHashtag.base03;
in {
  windowManager.sway.config = {
    fonts = {
      names = [fonts.sansSerif.name "Font Awesome 5 Pro"];
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
