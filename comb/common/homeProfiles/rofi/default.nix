{
  inputs,
  cell,
}: let
  inherit (config.styling) colors;
  inherit (inputs) nixpkgs;

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
    (nixpkgs.rofi-wayland.override {
      plugins = with nixpkgs; [
        rofi-calc
        rofi-emoji
        rofi-file-browser
        rofi-top
      ];
    })
  ];
}
