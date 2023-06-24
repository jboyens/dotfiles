{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  xsession.windowManager.i3 = {
    enable = true;
  };

  home.packages = with nixpkgs; [dmenu i3status i3lock];
}
