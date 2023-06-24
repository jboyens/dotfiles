{
  lib,
  inputs,
  ...
}:
with builtins;
with lib; let
  inherit (inputs.nixpkgs) runCommand sass imagemagick;
in {
  toCSSFile = file: let
    fileName = removeSuffix ".scss" (baseNameOf file);
    compiledStyles =
      runCommand "compileScssFile"
      {buildInputs = [sass];} ''
        mkdir "$out"
        scss --sourcemap=none \
             --no-cache \
             --style compressed \
             --default-encoding utf-8 \
             "${file}" \
             >>"$out/${fileName}.css"
      '';
  in "${compiledStyles}/${fileName}.css";

  toFilteredImage = imageFile: options: let
    result = "result.png";
    filteredImage =
      runCommand "filterWallpaper"
      {buildInputs = [imagemagick];} ''
        mkdir "$out"
        convert ${options} ${imageFile} $out/${result}
      '';
  in "${filteredImage}/${result}";
}
