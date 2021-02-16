(
  self: super: {
    libcamlink = super.callPackage ./camlink.nix {};
    keylightctl = super.callPackage ./keylightctl.nix {};
  }
)
