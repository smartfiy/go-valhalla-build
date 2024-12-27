let
    nixpkgs = import (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";  # This version uses older GLIBC  
        sha256 = "sha256:05cbl1k193c9la9xhlz4y6y8ijpb2mkaqrab30zij6z4kqgclsrd";
  }) {
        # Use GCC 12 etter compatibility
        config = {
            replaceStdenv = { pkgs }: pkgs.gcc12Stdenv;
        };
    };

in
nixpkgs.callPackage ./bindings {
  inherit (nixpkgs)
    lib stdenv abseil-cpp cmake fetchFromGitHub fetchpatch gtest zlib
    boost179 pkg-config python3 glibc protobuf sqlite libspatialite lua5_3 geos
    ;
  
}