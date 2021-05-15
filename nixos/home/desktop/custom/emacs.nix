{lib, pkgs, config, ... }:

let
  emacs-overlay = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  });
  emacs-dir = pkgs.fetchFromGitHub {
    owner  = "bwilkins";
    repo   = "dot-files";
    rev    = "f5feb45de0fecf0b1c88aeb3248bc5c21963d8c1";
    sha256 = "0fclkc2rns457jk93j1mgnwv32dbvfy01g81pjvwgr2lirxz47vc";
  } + "/emacs/emacs.d/";
  emacs-early-init = emacs-dir + "early-init.el";
  emacs-init = emacs-dir + "init.el";
  emacs-config = emacs-dir + "emacs.org";
  my-emacs = with pkgs; (emacsWithPackagesFromUsePackage {
    config = config.home.file.".emacs.d/emacs.org".target;
    alwaysEnsure = true;
    extraEmacsPackages = epkgs: with epkgs; [
      calibredb
      company
      company-box
      direnv
      evil
      evil-leader
      ivy
      magit
      notmuch
      org-plus-contrib
      projectile
      spacemacs-theme
    ];
  });

in {
  nixpkgs.overlays = [ emacs-overlay ];

  home.file.".emacs.d/early-init.el".source = emacs-early-init;
  home.file.".emacs.d/init.el".source = emacs-init;
  home.file.".emacs.d/emacs.org".source = emacs-config;

  services.emacs = {
    enable = true;
    package = my-emacs;
  };

  # The following is inspired by (and stolen from) http://www.diegoberrocal.com/blog/2015/08/19/org-protocol/
  xdg.dataFile."bin/emacs-capture" = {
    executable = true;
    text = ''
      #!/bin/sh
      emacsclient -c -F '((name . "emacs-capture") (height . 10) (width . 80))' "$@"
    '';
  };

  xdg.dataFile."bin/clock-in" = {
    executable = true;
    text = ''
      #!/bin/sh
      emacs-capture --eval "(--autoclose 2 '--clock-in)"
    '';
  };

  xdg.dataFile."bin/clock-out" = {
    executable = true;
    text = ''
      #!/bin/sh
      emacs-capture --eval "(--autoclose 2 '--clock-out)"
    '';
  };

  home.packages = [
    my-emacs
    (pkgs.makeDesktopItem {
      name = "emacs-capture";
      desktopName = "Emacs Capture";
      exec = "${config.xdg.dataFile."bin/emacs-capture".target} %u";
      terminal = "false";
    })
  ];
}
