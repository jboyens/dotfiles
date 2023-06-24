{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  # hey... it's kind of a keyboard.
  systemPackages = [nixpkgs.solo2-cli];
}
