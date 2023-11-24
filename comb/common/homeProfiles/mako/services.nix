{
  cell,
  config,
  ...
}: let
  inherit (config.styling) colors fonts fontSizes;

  lib = builtins // cell.pkgs.lib // cell.lib;

  iconPath = let
    basePaths = [
      "/run/current-system/sw"
      config.home.profileDirectory
      "/home/jboyens/.nix-profile"
      "/etc/profiles/per-user/jboyens"
    ];
    themes = ["Dracula" "Adwaita" "hicolor"];
    mkPath = {
      basePath,
      theme,
    }: "${basePath}/share/icons/${theme}";
  in
    lib.concatMapStringsSep ":" mkPath (lib.cartesianProductOfSets {
      basePath = basePaths;
      theme = themes;
    });
in {
  mako = {
    inherit iconPath;

    enable = true;
    actions = true;
    anchor = "top-right";
    borderRadius = 2;
    borderSize = 1;
    defaultTimeout = 0;
    height = 1000;
    icons = true;
    ignoreTimeout = false;
    margin = "4,26";
    markup = true;
    maxVisible = -1;
    padding = "20,16";
    width = 440;

    backgroundColor = colors.withHashtag.base00 + "FF";
    borderColor = colors.withHashtag.base0D;
    textColor = colors.withHashtag.base05;
    progressColor = "over ${colors.withHashtag.base02}";
    font = "${fonts.sansSerif.name} ${toString fontSizes.popups}";

    extraConfig = ''
      [urgency=low]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base0A}

      [urgency=high]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base08}

      [app-name="Slack"]
      group-by=summary
      default-timeout=15000
    '';
  };
}
