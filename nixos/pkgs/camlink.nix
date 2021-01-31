{lib, stdenv, fetchFromGitHub}:

let
  pname = "libcamlink";
  version = "0.1";
in stdenv.mkDerivation rec {
  name = pname;

  src = fetchFromGitHub {
    owner  = "xkahn";
    repo   = "camlink";
    rev    = "b2e71e23f0057cc9d964feb070f5c1cbbd447cd6";
    sha256 = "1ap6rmnwn7pccc0m4cqzb815mrnlxv9xniydi3nar5rsj9a6cddh";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp camlink.so $out/lib
  '';
}
