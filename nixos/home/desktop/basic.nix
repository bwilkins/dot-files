{ lib, pkgs, ... }:

let
  settings = import ../../settings.nix;

in {
  imports = [
    ./custom/emacs.nix
    ./custom/kitty.nix
    ./custom/i3.nix
    ./custom/rofi.nix
    ./custom/vscode.nix
  ];

  home.packages = with pkgs; [
    _1password-gui
    discord
    gparted
    kitty
    mattermost-desktop
    maim
    mpv
    jetbrains.ruby-mine
    pinta
    postman
    signal-desktop
    slack
    spotify
    steam
    sxiv
    xclip
    yubikey-manager-qt
    zathura
    zoom-us
  ];

  xsession = {
    enable = true;
  };

  # Create common user dirs.
  xdg = {
    mime = {
      enable = true;
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf"        = "zathura.desktop";
        "image/jpeg"             = "sxiv.desktop";
        "image/png"              = "sxiv.desktop";
        "x-scheme-handler/http"  = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };

    userDirs = {
      enable = true;
    };
  };

  gtk = {
    enable = true;
  };

  services = {
    # Display desktop notfications.
    dunst = {
      enable = true;

      settings = {
        global = {
          follow = "keyboard"; # Show notifications where the keyboard has focus.
          format = "<b>%s</b>\\n%b";
          font = "${settings.font.sansFamily} ${settings.font.defaultSize.points}";
          frame_width = 2; # Border size.
          geometry = "400x5-18+42"; # Size & location of notifications.
          horizontal_padding = 6;
          markup = "yes"; # Enable basic markup in messages.
          padding = 6; # Vertical padding
          separator_color = "frame"; # Match to the frame color.
          separator_height = 2; # Space between notifications.
          sort = "yes"; # Sort messages by urgency.
        };
      };
    };

    # Add the network manager to the status bar.
    network-manager-applet = {
      enable = true;
    };

    # Add the audio manager to the status bar.
    pasystray = {
      enable = true;
    };

    # Add an audio effects manager.
    pulseeffects = {
      enable = true;
    };

    # Set a background image.
    # random-background = {
    #   enable = true;
    #   imageDirectory = toString ./art;
    # };

    # Manage removeable media.
    udiskie = {
      enable = true;
      tray = "auto";
    };

    dropbox = {
      enable = true;
    };
  };

}
