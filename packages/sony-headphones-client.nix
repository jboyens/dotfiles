{ stdenv, fetchFromGitHub, bluez, glew, glfw3, dbus, cmake, pkg-config, git }:

let
  pname = "sony-headphones-client";
  version = "1.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "fe6369b03dab08c6636e32f57757e72c047e7cf1";
    sha256 = "OhDy+VF40OZNvtzXSOkOsmsdfX1z75A0+24f9ukSnr4=";
  };

  src = fetchFromGitHub {
    owner = "Plutoberth";
    repo = "SonyHeadphonesClient";
    rev = "v${version}";
    sha256 = "gQ3p3Be0A2I7HzW9h7nw2eBiv+6dNJbMyYbAl1mTrjU=";
  };

  sourceRoot = "source/Client/";

  postUnpack = ''
    cp -r ${imgui}/* ${sourceRoot}/imgui/
    '';

  nativeBuildInputs = [ cmake pkg-config git ];
  propagatedBuildInputs = [ bluez glew glfw3 dbus ];

  installPhase = ''
    mkdir -p $out/bin
    cp SonyHeadphonesClient $out/bin
    '';

  meta = with stdenv.lib; {
    description = "An alternative for the mobile-only Sony Headphones app";
    homepage    = "https://github.com/Plutoberth/SonyHeadphonesClient";
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jboyens ];
  };
}
