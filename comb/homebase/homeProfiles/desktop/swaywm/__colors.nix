{
  inputs,
  cell,
}: let
  nixosProfiles = inputs.cells.homebase.nixosProfiles;
  styles = nixosProfiles.styles.config;

  inherit (styles.styling) colors;

  text = colors.withHashtag.base05;
  urgent = colors.withHashtag.base08;
  focused = colors.withHashtag.base0A;
  unfocused = colors.withHashtag.base03;

  fonts = {
    names = [styles.styling.fonts.sansSerif.name];
    size = styles.styling.fontSizes.desktop + 0.0;
  };
in {
  wayland.windowManager.sway.config = {
    inherit fonts;

    colors = let
      background = colors.withHashtag.base00;
      indicator = colors.withHashtag.base0B;
    in {
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
