{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.strings) removePrefix;
  inherit (config.home) homeDirectory;

  xdgDataHome = removePrefix homeDirectory config.xdg.dataHome;
in
{
  programs.go = {
    enable = true;
    env.GOPATH = "${xdgDataHome}/go";
  };
}
