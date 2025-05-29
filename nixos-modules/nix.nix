{
  inputs,
  lib,
  ...
}: let
  filteredInputs = lib.filterAttrs (n: _: n != "self") inputs;
  nixPathInputs = lib.mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
  registryInputs = lib.mapAttrs (_: v: {flake = v;}) filteredInputs;
in {
  nix = {
    settings = {
      substituters = ["https://cache.nixos.org"];

      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    sshServe = {
      enable = true;
      protocol = "ssh-ng";
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL915OY2qIMYEk/jHRFE4mNo0lUANs7Qwe+D0pSommD jboyens@fooninja.org"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDECXnI34NJU+L32GB7vwdTv4R9Uv53DElOZ5T/1or7X1VJxEb2+vNjxFQm1WNru1p23Wq8vGKasjIJt20L3B2E+9A2JHuL8MDpXU5Ednk3TgR1ghSdXzqmUTWmEMuqeU7nzYtnFeEyMSpW/FLy8YxO69C3QKsJGlk6+zEMYy17EhcT87K37/Odw326yXqEG2PAyQFQuSUSUIKixjLqYdRyVUTS43PY9kFwny4XqBof+vprkSfpQJi9qbSYPTOlfdadVE4wtb0TBdHRPS9owBk09ouj3okbT4TyEgedG6QrZn5j06nAYZqI4ggAI3sKgvLaec5jwqF+mX0Jo8naV4in jr@irongiant.local"
      ];
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d";
    # };

    settings = {
      sandbox = true;

      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
        "@wheel"
        "nix-ssh"
      ];

      auto-optimise-store = true;
    };

    # HACK
    nixPath = nixPathInputs ++ ["nixpkgs=${inputs.nixpkgs}"];

    registry =
      registryInputs
      // {
        nixpkgs.flake = inputs.nixpkgs;
      };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
}
