{
  lib,
  gnupg,
  ...
}: (gnupg.overrideAttrs (oa: {
  patches = oa.patches ++ [./fix-2.4.1-emacs-breakage.patch];
}))
