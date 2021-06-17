final: prev:
{
  pgcenter = prev.pgcenter.overrideAttrs(oa: rec {
    version = "0.9.0";

    src = prev.fetchFromGitHub {
      owner  = "lesovsky";
      repo   = "pgcenter";
      rev    = "v${version}";
      sha256 = "sha256-IBybV1aAdjj061b9CJHNlRqIwegoMU5hvi/0F+tRbVA=";
    };

    vendorSha256 = final.lib.fakeHash;
  });

  mu = prev.mu.overrideAttrs(oa: rec {
    version = "9020389a5625391da8f996eadf2e022d118d4881";

    src = prev.fetchFromGitHub {
      owner  = "djcb";
      repo   = "mu";
      rev    = version;
      sha256 = "sha256-WWoJ5aWpZXYKaPvqghVSsyLsicYMupl9PxsIrd3byUY=";
    };
  });
}
