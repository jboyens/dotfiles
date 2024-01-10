{
  inputs,
  cell,
}: rec {
  inherit (inputs.cells) common;

  default =
    [
      inputs.stylix.nixosModules.stylix
      {
        stylix = {
          targets = {
            gnome.enable = false;
          };
          base16Scheme = "${inputs.catppuccin-base16}/base16/frappe.yaml";
          image = /home/jboyens/hyprdots/Configs/.config/swww/Catppuccin-Mocha/escape_velocity.jpg;
          polarity = "dark";
        };
      }
      cell.nixosProfiles.core
      cell.nixosProfiles.backup
      cell.nixosProfiles.fonts
      cell.nixosProfiles.pipewire
    ]
    ++ common.nixosSuites.default;
}
