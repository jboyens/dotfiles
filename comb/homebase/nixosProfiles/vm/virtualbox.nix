{
  virtualisation.virtualbox.host = {
    enable = true;
    # urg, takes so long to build, but needed for macOS guest
    # enableExtensionPack = true;
  };

  users.users.jboyens.extraGroups = ["vboxusers"];
}
