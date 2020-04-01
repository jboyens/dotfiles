[
  (self: super:
    with super; {
      linuxPackages_latest = super.linuxPackages_latest.extend
        (lpself: lpsuper: {
          macbook12-spi-driver =
            lpself.callPackage ./packages/macbook12-spi-driver.nix { };
        });
      my = {
        ant-dracula = (callPackage ./packages/ant-dracula.nix { });
        bosh-bootloader = (callPackage ./packages/bosh-bootloader.nix { });
        bosh-cli = (callPackage ./packages/bosh-cli.nix { });
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        credhub-cli = (callPackage ./packages/credhub-cli.nix { });
        emacs27 = (callPackage ./packages/emacs27.nix { });
        # dell-bios-fan-control = (callPackage ./packages/dell-bios-fan-control.nix {});
        ferdi = (callPackage ./packages/ferdi.nix { });
        # gmailctl = (callPackage ./packages/gmailctl.nix { });
        linode-cli = (callPackage ./packages/linode-cli.nix { });
        logcli = (callPackage ./packages/logcli.nix { });
        ripcord = (callPackage ./packages/ripcord.nix { });
        zunit = (callPackage ./packages/zunit.nix { });
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
