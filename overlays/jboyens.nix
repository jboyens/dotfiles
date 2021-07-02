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
    version = "7034556ab4d7b0fc36eda93ab4b7a5370fdbea83";

    src = prev.fetchFromGitHub {
      owner  = "djcb";
      repo   = "mu";
      rev    = version;
      sha256 = "sha256-4XefHlIGB/H/Slt4O9nFe3lMsGhtK/KWtyeEznNNmrk=";
    };
  });
}
