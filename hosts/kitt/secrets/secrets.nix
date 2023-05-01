let
  jboyens_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL915OY2qIMYEk/jHRFE4mNo0lUANs7Qwe+D0pSommD jboyens@fooninja.org";
  users = [ jboyens_key ];

  kitt_host_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMBiHK9GCIMikQLtBl6X3d/cxiCPdwtlSOSQIZeaZdst root@kitt";
  systems = [ kitt_host_key ];
in {
  "netrc.age".publicKeys = users ++ systems;
}
