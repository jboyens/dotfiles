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

  # mu = prev.mu.overrideAttrs(oa: rec {
  #   version = "1c95d28cdeebd58f8fddbdf055fbc5a7408e4e88";
  #
  #   src = prev.fetchFromGitHub {
  #     owner  = "djcb";
  #     repo   = "mu";
  #     rev    = version;
  #     sha256 = "sha256-ZEjKrbccXdZ6Rc/YfOjbLdZDBpgKsC7b6MF/tU1e/nY=";
  #   };
  #
  #   nativeBuildInputs = [ prev.meson prev.pkg-config prev.cmake ];
  #
  #   buildInputs = with prev; [
  #     sqlite xapian glib gmime3 texinfo emacs libsoup icu guile
  #   ];
  # });
}
