{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.vaultwarden;
in {
  options.modules.shell.vaultwarden = with types; {
    enable = lib.my.mkBoolOpt false;
    config = lib.my.mkOpt attrs {};
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bitwarden-cli
    ];

    modules.shell.zsh.rcInit = "_cache bw completion --shell zsh; compdef _bw bw;";

    system.userActivationScripts = mkIf (cfg.config != {}) {
      initVaultwarden = ''
        ${concatStringsSep "\n" (mapAttrsToList (n: v: "${pkgs.bitwarden-cli}/bin/bw config ${n} ${v}") cfg.config)}
      '';
    };
  };
}
