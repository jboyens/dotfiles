{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs base16;
  inherit (nixpkgs) lib;

  scheme =
    (base16.lib {
      pkgs = nixpkgs;
      lib = lib;
    })
    .mkSchemeAttrs "${inputs.base16-schemes}/horizon-dark.yaml";

  fontOptions = {
    options = {
      name = lib.mkOption {type = lib.types.str;};
      package = lib.mkOption {type = lib.types.package;};
    };
  };

  mkFontOption = default: description:
    lib.mkOption {
      inherit default description;
      type = lib.types.submodule fontOptions;
    };

  mkFontSize = default:
    lib.mkOption {
      inherit default;
      type = lib.types.int;
    };
in {
  options = {
    styling = {
      image = lib.mkOption {type = lib.types.oneOf [lib.types.str lib.types.path];};

      colors = lib.mkOption {type = lib.types.attrs;};

      fonts = {
        serif = mkFontOption null "Serif font face";
        sansSerif = mkFontOption null "SansSerif font face";
        monospace = mkFontOption null "Monospace font face";
        emoji = mkFontOption null "Emoji font face";
      };

      fontSizes = {
        applications = mkFontSize 12;
        desktop = mkFontSize 12;
        terminal = mkFontSize 10;
        popups = mkFontSize 10;
      };
    };
  };

  config = {
    styling = {
      image = /home/jboyens/Downloads/vhs.png;

      colors = scheme;

      fonts = {
        serif = {
          package = inputs.nixpkgs.iosevka-bin.override {variant = "etoile";};
          name = "Iosevka Etoile";
        };

        sansSerif = {
          package = inputs.nixpkgs.iosevka-bin.override {variant = "aile";};
          name = "Iosevka Aile";
        };

        monospace = {
          package = inputs.cells.homebase.packages.pragmasevka;
          name = "Pragmasevka";
        };

        emoji = {
          package = inputs.nixpkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };

      fontSizes = {
        applications = 12;
        desktop = 12;
        terminal = 10;
        popups = 10;
      };
    };
  };
}
