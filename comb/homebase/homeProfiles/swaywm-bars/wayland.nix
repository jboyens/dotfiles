{
  inputs,
  cell,
  config,
}: let
  inherit (config.styling) colors fonts;
in {
  windowManager.sway.config.bars = [
    {
      fonts = {
        names = [fonts.sansSerif.name "Font Awesome 5 Pro"];
        size = 12.0;
      };
      position = "bottom";
      statusCommand = "i3status-rs config-bottom.toml";
      colors = {
        background = colors.withHashtag.base00;
        statusline = colors.withHashtag.base05;

        focusedWorkspace = {
          border = colors.withHashtag.base02;
          background = colors.withHashtag.base02;
          text = colors.withHashtag.base05;
        };
        activeWorkspace = {
          border = colors.withHashtag.base02;
          background = colors.withHashtag.base02;
          text = colors.withHashtag.base05;
        };
        inactiveWorkspace = {
          border = colors.withHashtag.base00;
          background = colors.withHashtag.base00;
          text = colors.withHashtag.base05;
        };
        urgentWorkspace = {
          border = colors.withHashtag.base08;
          background = colors.withHashtag.base08;
          text = colors.withHashtag.base05;
        };
      };
    }
  ];
}
