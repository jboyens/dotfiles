{...}: {
  services.nfs.idmapd.settings = {
    General = {Domain = "fooninja.org";};
    Translation = {GSS-Methods = "static,nsswitch";};
    Static = {"jboyens@fooninja.org" = "jboyens";};
  };
}
