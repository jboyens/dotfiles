{
  config,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings.main.dpi-aware = lib.mkForce "yes";
    settings.main.font = lib.mkForce "${config.stylix.fonts.monospace.name}:size=${toString config.stylix.fonts.sizes.popups}";
  };
}
