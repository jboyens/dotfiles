final: prev:
{
  offlineimap = prev.offlineimap.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "OfflineIMAP";
      repo = "offlineimap";
      rev = "2d0d07cd6a0560e5845ac09a0b3fbada3a034ba6";
      sha256 = "NU/kqsBUPR+0EnEDIXMQaBU6gm2Y+KExH5XWKMFJ2x0=";
    };
  });
}
