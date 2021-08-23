final: prev:
{
  pgcenter = prev.pgcenter.overrideAttrs(oa: rec {
    version = "0.9.2";

    src = prev.fetchFromGitHub {
      owner  = "lesovsky";
      repo   = "pgcenter";
      rev    = "v${version}";
      sha256 = "xaY01T12/5Peww9scRgfc5yHj7QA8BEwOK5l6OedziY=";
    };

    vendorSha256 = final.lib.fakeHash;
  });

  mu = prev.mu.overrideAttrs(oa: rec {
    version = "b62f70f9d03a72fbdf25f652e2c9897ece475de8";

    src = prev.fetchFromGitHub {
      owner  = "djcb";
      repo   = "mu";
      rev    = version;
      sha256 = "oF6n4ayc70FKO3v3wKoPocjFlWOYlpv5614o2+xfdWs=";
    };
  });
}
