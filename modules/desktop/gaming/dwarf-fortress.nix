{ config, options, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.gaming.dwarf-fortress = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.gaming.dwarf-fortress.enable {
    my.packages = with pkgs; [
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        theme = "spacefox";
      })
    ];
  };
}
