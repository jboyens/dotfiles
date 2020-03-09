# modules/chat.nix
#
# Even neckbeards have a social life. Not that I have one. A neckbeard, I mean.
# But when I do have either, then discord and weechat are my go-to.

{ pkgs, ... }:
{
  my.packages = with pkgs; [
    weechat        # TODO For the real neckbeards
    discord        # For everyone else
  ];
}
