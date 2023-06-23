{
  inputs,
  cell,
}: let
  inherit (inputs.std) std lib;
  inherit (inputs) nixpkgs;
in {
  default = lib.dev.mkShell {
    name = "A shell";

    commands = [
      {
        package = nixpkgs.treefmt;
        category = "formatting";
      }
    ];

    imports = [std.devshellProfiles.default];
  };
}
