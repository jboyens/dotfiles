{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  libgit2,
  openssl,
  zlib,
  zstd,
  stdenv,
  darwin,
}:
with import <nixpkgs> {
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};
  rustPlatform.buildRustPackage rec {
    pname = "jj";
    version = "20230801";

    src = fetchFromGitHub {
      owner = "martinvonz";
      repo = "jj";
      rev = "7751cea47cfe6dd96542757b72c72627c93cdc12";
      hash = "sha256-SA30TwWBq6qd9vpG/4R8Z446PEh9/KOhA1E27AWRPv8=";
    };

    cargoHash = "sha256-LOXf20RdPWrKX3GkMSkp5F5IDx9d/2IY8NCssK2WWtQ=";

    nativeBuildInputs = [
      rust-bin.stable.latest.minimal
      pkg-config
      protobuf
    ];

    buildInputs =
      [
        libgit2
        openssl
        zlib
        zstd
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.CoreFoundation
        darwin.apple_sdk.frameworks.Security
        darwin.apple_sdk.frameworks.SystemConfiguration
      ];

    env = {
      OPENSSL_NO_VENDOR = true;
      ZSTD_SYS_USE_PKG_CONFIG = true;
    };

    meta = with lib; {
      description = "A Git-compatible DVCS that is both simple and powerful";
      homepage = "https://github.com/martinvonz/jj";
      changelog = "https://github.com/martinvonz/jj/blob/${src.rev}/CHANGELOG.md";
      license = licenses.asl20;
      maintainers = with maintainers; [];
    };
  }
