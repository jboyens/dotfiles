{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  gtk = {
    enable = true;

    # theme = {
    #   package = nixpkgs.catppuccin-gtk.override {variant = "mocha";};
    #   name = "Catppuccin-Mocha-Standard-Blue-dark";
    # };

    # cursorTheme = {
    #   package = nixpkgs.bibata-cursors;
    #   name = "Bibata-Modern-Ice";
    #   size = 20;
    # };

    # iconTheme = {
    #   package = nixpkgs.tela-circle-icon-theme;
    #   name = "Tela-circle-dracula";
    # };
  };
}
