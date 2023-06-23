{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.pass;
  package = pkgs.pass-wayland.overrideAttrs (oa: {
    x11Support = false;
    waylandSupport = true;
  });
in {
  options.modules.shell.pass = with types; {
    enable = lib.my.mkBoolOpt false;
    passwordStoreDir = lib.my.mkOpt str "$HOME/.secrets/password-store";
  };

  config = mkIf cfg.enable {
    user.packages = [
      (package.withExtensions (exts:
        [exts.pass-otp exts.pass-genphrase exts.pass-update exts.pass-audit]
        ++ (
          if config.modules.shell.gnupg.enable
          then [exts.pass-tomb]
          else []
        )))
    ];
    env.PASSWORD_STORE_DIR = cfg.passwordStoreDir;
  };
}
