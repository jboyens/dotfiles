{ pkgs, ... }:
{
  my.packages = with pkgs; [
    podman
    runc
    conmon
    slirp4netns
    fuse-overlayfs
  ];

  users.users.jboyens.subUidRanges = [{ startUid = 100000; count = 65536; }];
  users.users.jboyens.subGidRanges = [{ startGid = 100000; count = 65536; }];

  environment.etc."containers/policy.json" = {
    mode="0644";
    text=''
      {
        "default": [
          {
            "type": "insecureAcceptAnything"
          }
        ],
        "transports":
          {
            "docker-daemon":
              {
                "": [{"type":"insecureAcceptAnything"}]
              }
          }
      }
    '';
  };

  environment.etc."containers/registries.conf" = {
    mode="0644";
    text=''
      [registries.search]
      registries = ['docker.io', 'quay.io']
    '';
  };
}
