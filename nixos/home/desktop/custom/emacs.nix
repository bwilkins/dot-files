{lib, pkgs, config, ... }:

let
  emacs-overlay = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  });
  emacs-dir = pkgs.fetchFromGitHub {
    owner  = "bwilkins";
    repo   = "dot-files";
    rev    = "d1853d2c6d0581a7814797497388cd73954ce275";
    sha256 = "0dyipl3xpa8r2ids67wrn3b95c1450217bqrxv7mn1q2izz160b3";
  } + "/emacs/emacs.d/";
  emacs-early-init = emacs-dir + "early-init.el";
  emacs-init = emacs-dir + "init.el";
  emacs-config = emacs-dir + "emacs.org";
in {
  nixpkgs.overlays = [ emacs-overlay ];

  home.file.".emacs.d/early-init.el".source = emacs-early-init;
  home.file.".emacs.d/init.el".source = emacs-init;
  home.file.".emacs.d/emacs.org".source = emacs-config;

  home.packages = with pkgs; [
    (emacsWithPackagesFromUsePackage {
      config = config.home.file.".emacs.d/emacs.org".target;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: with epkgs; [
        company
        evil
        evil-leader
        ivy
        magit
        org-plus-contrib
        projectile
        spacemacs-theme
      ];
    })
  ];
}
