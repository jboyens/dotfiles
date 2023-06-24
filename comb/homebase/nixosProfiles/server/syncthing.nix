{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "jboyens";
    configDir = "/home/jboyens/.config/syncthing";
    dataDir = "/home/jboyens/.local/share/syncthing";
  };
}
