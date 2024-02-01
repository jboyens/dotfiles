{
  inputs,
  cell,
  ...
}: let
  inherit (cell) pkgs;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "frappe";

    enabledCustomApps = with spicePkgs.apps; [
      reddit
      new-releases
    ];

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      history
      songStats
    ];
  };
}
