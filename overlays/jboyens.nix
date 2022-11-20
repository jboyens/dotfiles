final: prev:
{
  # pgcenter = prev.pgcenter.overrideAttrs(oa: rec {
  #   version = "0.9.2";
  #
  #   src = prev.fetchFromGitHub {
  #     owner  = "lesovsky";
  #     repo   = "pgcenter";
  #     rev    = "v${version}";
  #     sha256 = "xaY01T12/5Peww9scRgfc5yHj7QA8BEwOK5l6OedziY=";
  #   };
  #
  #   vendorSha256 = final.lib.fakeHash;
  # });

  open-policy-agent = prev.open-policy-agent.overrideAttrs(oa: rec {
    doCheck = false;
  });

  isync-oauth2 = final.buildEnv {
    name = "isync-oauth2";
    paths = [ final.isync ];
    pathsToLink = [ "/bin" ];
    nativeBuildInputs = [ final.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/mbsync" \
        --prefix SASL_PATH : "${final.cyrus_sasl.out.outPath}/lib/sasl2:${prev.my.cyrus-sasl-xoauth2}/lib/sasl2"
    '';
  };

  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs(oa: rec {
    patches = [ ../patches/0001-xdg-desktop-wlr-zoomfix.patch ];
  });

  #
  # ananicy-cpp = prev.ananicy-cpp.overrideAttrs(old: rec {
  #   version = "unstable-2022-10-25";
  #
  #   src = prev.fetchFromGitLab {
  #     owner = "ananicy-cpp";
  #     repo = "ananicy-cpp";
  #     rev = "9a6987ea0ec4c5c5242f41ccac95294b31370603";
  #     sha256 = "sha256-ZTM+owVFfEq9P2SMOPVbqtrCT3DEG3W2zHadFGBJDTs=";
  #   };
  # });
}
