{ config, options, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = {
    enable = mkBoolOpt false;
    package = mkOption {
      type = types.package;
      default = if config.modules.desktop.swaywm.enable then pkgs.pass-wayland else pkgs.pass;
      defaultText = "pkgs.pass";
      description = "If Wayland: pass-wayland else pass";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (cfg.package.withExtensions (exts: [
        exts.pass-otp
        exts.pass-genphrase
        exts.pass-update
        exts.pass-audit
      ] ++ (if config.modules.shell.gnupg.enable
            then [ exts.pass-tomb ]
            else [])))
    ];
    env.PASSWORD_STORE_DIR = "$HOME/.secrets/password-store";
  };
}
