{
  buildEnv,
  makeWrapper,
  isync,
  cyrus_sasl,
  cyrus-sasl-xoauth2,
}:
buildEnv {
  name = "isync-oauth2";
  paths = [isync];
  pathsToLink = ["/bin"];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram "$out/bin/mbsync" \
      --prefix SASL_PATH : "${cyrus_sasl.out.outPath}/lib/sasl2:${cyrus-sasl-xoauth2}/lib/sasl2"
  '';
}
