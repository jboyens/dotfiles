{
  gpg-agent = {
    # homedir = "$XDG_CONFIG_HOME/gnupg";
    enable = true;
    enableExtraSocket = true;
    defaultCacheTtl = 3600; # 1hr
    enableZshIntegration = true;
    extraConfig = ''
      allow-loopback-pinentry
    '';

    pinentryFlavor = "gtk2";
  };
}
