{lib, stdenv, fetchFromGitHub, buildGoModule}:

buildGoModule rec {
  pname = "keylightctl";
  version = "0.0.4-pre";

  src = fetchFromGitHub {
    owner  = "endocrimes";
    repo   = "keylightctl";
    rev    = "074c162d986f94f4e4c84bfd6d4f0803f20095d4";
    sha256 = "0llp65qr06p51dlfiqp8jzr5a8bmz07w7j4h3fb04vb5w0izmmhy";
  };

  vendorSha256 = null;

  subPackages = [ "." "command" "version" ];

  deleteVendor = false;
  runVend = false;
}
