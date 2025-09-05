{
  config,
  pkgs,
  ...
}:
let
  # pkgs = import (builtins.fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/5a8650469a9f8a1958ff9373bd27fb8e54c4365d.tar.gz";
  #   sha256 = "sha256:0qij2z6fxlmy4y0zaa3hbza1r2pnyp48pwvfvba614mb8x233ywq";
  # }) { system = "x86_64-linux"; };
in
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
    # package = myPkg;
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    defaultCacheTtl = 3600; # 1hr
    enableZshIntegration = true;
    extraConfig = ''
      allow-loopback-pinentry
    '';

    pinentry.package = pkgs.pinentry-all;
  };
}
