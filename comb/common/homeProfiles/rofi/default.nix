{
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs;

  cfg = config.programs.rofi;
in {
  home.file = {
    ".config/rofi/themes" = {
      source = ./_themes;
      recursive = true;
    };

    ".config/rofi/themes/theme.rasi" = {
      source = ./_themes/Catppuccin-Mocha.rasi;
    };

    ".config/rofi/styles" = {
      source = ./_themes;
      recursive = true;
    };

    "${cfg.configPath}".source = ./config.rasi;
  };

  home.packages = [
    (pkgs.rofi-wayland.override {
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-file-browser
        rofi-top
      ];
    })
  ];
}
