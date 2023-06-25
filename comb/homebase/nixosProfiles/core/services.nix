{
  openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  earlyoom.enable = true;
  earlyoom.enableNotifications = true;
  earlyoom.enableDebugInfo = false;

  atd.enable = true;

  nscd.enableNsncd = true;

  nfs.idmapd.settings = {
    General = {Domain = "fooninja.org";};
    Translation = {GSS-Methods = "static,nsswitch";};
    Static = {"jboyens@fooninja.org" = "jboyens";};
  };

  openssh.startWhenNeeded = true;
  tailscale.enable = true;
}
