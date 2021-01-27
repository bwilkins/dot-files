{ lib, pkgs, ... }: {
  # Launch a duckduckgo search.
  xdg.dataFile."bin/duckduckgo" = {
    executable = true;
    text = ''
      #!/bin/sh
      ${lib.getBin pkgs.rofi}/bin/rofi -dmenu -lines 0 -p duckduckgo | xargs -I{} firefox-sandboxed 'https://duckduckgo.com/?q={}'
    '';
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    extraConfig = {
      modi = "run,emoji,window,ssh";
    };
  };
}
