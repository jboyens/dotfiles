[
  (self: super:
    with super; {
      my = {
        linode-cli = (callPackage ./packages/linode-cli.nix { });
        ripcord = (callPackage ./packages/ripcord.nix { });
        zunit = (callPackage ./packages/zunit.nix { });
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        ant-dracula = (callPackage ./packages/ant-dracula.nix { });
        ferdi = (callPackage ./packages/ferdi.nix { });
        bosh-cli = (callPackage ./packages/bosh-cli.nix { });
        bosh-bootloader = (callPackage ./packages/bosh-bootloader.nix { });
        credhub-cli = (callPackage ./packages/credhub-cli.nix { });
        logcli = (callPackage ./packages/logcli.nix { });
        # dell-bios-fan-control = (callPackage ./packages/dell-bios-fan-control.nix {});
      };

      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Occasionally, "stable" packages are broken or incomplete, so access to the
      # bleeding edge is necessary, as a last resort.
      unstable = import <nixpkgs-unstable> { inherit config; };
    })

  # emacsGit
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))

]
