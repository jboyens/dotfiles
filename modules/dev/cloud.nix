# modules/dev/cloud.nix
#
# Packages for various cloud services

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.dev.cloud = {
    google = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    amazon = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    microsoft = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkMerge [
    (mkIf config.modules.dev.cloud.google.enable {
      my.packages = with pkgs; [ google-cloud-sdk ];
    })

    (mkIf config.modules.dev.cloud.amazon.enable {
      my.packages = with pkgs; [ awscli ];
    })

    (mkIf config.modules.dev.cloud.microsoft.enable {
      my.packages = with pkgs; [ azure-cli ];
    })
  ];
}
