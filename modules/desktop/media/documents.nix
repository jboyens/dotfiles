# modules/desktop/media/docs.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.media.documents;
in {
  options.modules.desktop.media.documents = {
    enable = lib.my.mkBoolOpt false;
    pdf.enable = lib.my.mkBoolOpt false;
    ebook.enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.ebook.enable calibre)
      (mkIf cfg.pdf.enable evince)
      # zathura
    ];

    # TODO calibre/evince/zathura dotfiles
  };
}
