{ stdenv, lib, fetchFromGitHub, bluez, glew, glfw3, dbus, cmake, pkg-config, git }:

let
  pname = "sony-headphones-client";
  version = "1.3.1";
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
    sha256 = "sha256-flEEHWx94gQrdsPZMvGJUUUpIN3KahJGp2oxIPVncoY=";
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

  meta = with lib; {
    description = "An alternative for the mobile-only Sony Headphones app";
    homepage    = "https://github.com/Plutoberth/SonyHeadphonesClient";
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jboyens ];
  };
}
