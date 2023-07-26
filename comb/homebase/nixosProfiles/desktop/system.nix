{
  # Clean up leftovers, as much as we can
  userActivationScripts.cleanupHome = ''
    pushd "/home/jboyens"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';
}
