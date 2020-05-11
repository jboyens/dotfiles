{ config, options, pkgs, lib, ... }:
with lib;
{
  options.modules.shell.pass = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.pass.enable {
    my = {
      packages = with pkgs; [
        (pass.withExtensions (exts: [
          exts.pass-otp
          exts.pass-genphrase
          exts.pass-update
          exts.pass-audit
          exts.pass-checkup
        ]))
      ];
      env.PASSWORD_STORE_DIR = "$HOME/.secrets/password-store";
    };
  };
}
