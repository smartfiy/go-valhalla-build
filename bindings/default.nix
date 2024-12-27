{ lib
, stdenv
, abseil-cpp
, cmake
, fetchFromGitHub
, fetchpatch
, gtest
, zlib
, boost179 #
, protobuf
, sqlite
, libspatialite
, luajit
, geos
# downstream dependencies
, python3

, ...
}:

#with nixpkgs;

let
  valhallaCustom = (import ./valhalla) { inherit 
    stdenv 
    fetchFromGitHub 
    cmake 
    zlib
    boost179
    protobuf
    sqlite
    libspatialite
    luajit
    geos; };
  protobufCustom = (import ./protobuf) { inherit lib abseil-cpp stdenv fetchFromGitHub cmake fetchpatch gtest zlib python3; };
in stdenv.mkDerivation rec {
  name = "go-valhalla-build";
  src = ./.;

  buildInputs = [
    boost179
    valhallaCustom
    zlib.static
    protobufCustom
  ];

  buildPhase = ''
    c++ \
      valhalla_go.cpp \
      -fPIC \
      -shared \
      -o libvalhalla_go.so \
      -Wl,-Bstatic \
      -lvalhalla \
      -lprotobuf-lite \
      -lz \
      -Wl,-Bdynamic \
      -lpthread
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libvalhalla_go.so $out/lib
  '';
}