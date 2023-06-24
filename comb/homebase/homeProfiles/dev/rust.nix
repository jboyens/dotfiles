{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home = {
    packages = [nixpkgs.rustup];

    shellAliases = {
      rs = "rustc";
      rsp = "rustup";
      ca = "cargo";
    };

    sessionVariables = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
    };

    sessionPath = [
      "$(${nixpkgs.yarn}/bin/yarn global bin)"
      "$CARGO_HOME/bin"
    ];
  };
}
