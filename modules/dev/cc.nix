# modules/dev/cc.nix --- C & C++
#
# I love C. I tolerate C++. I adore C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion. It's my guilty secret, so don't
# tell anyone pls.
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  devCfg = config.modules.dev;
  cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = lib.my.mkBoolOpt false;
    xdg.enable = lib.my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        clang
        gcc
        bear
        gdb
        cmake
        llvmPackages.libcxx
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
