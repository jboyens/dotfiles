# modules/dev/cloud.nix
#
# Packages for various cloud services
{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.dev.cloud;
in {
  options.modules.dev.cloud = {
    google.enable = mkBoolOpt false;
    amazon.enable = mkBoolOpt false;
    microsoft.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.google.enable {
      user.packages = with pkgs; [ google-cloud-sdk cloud-sql-proxy ];
    })

    (mkIf cfg.amazon.enable {
      user.packages = with pkgs; [ awscli ];
    })

    (mkIf cfg.microsoft.enable {
      user.packages = with pkgs; [ azure-cli ];
    })

    ({
      user = {
        packages = with pkgs; [
          unstable.terraform
          unstable.kubectl
          unstable.minikube
          unstable.k9s
        ];
      };

      modules.shell.zsh.aliases.k = "kubectl";
    })
  ];
}
