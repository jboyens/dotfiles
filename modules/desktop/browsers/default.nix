{ config, lib, pkgs, ... }:
with lib; {
  imports =
    [ ./firefox.nix ./qutebrowser.nix ./vivaldi.nix ./google-chrome.nix ];

  options.modules.desktop.browsers = {
    default = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf (config.modules.desktop.browsers.default != null) {
    my.env.BROWSER = config.modules.desktop.browsers.default;
  };
}
