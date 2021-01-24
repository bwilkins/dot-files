{pkgs, ... }:

let
  settings = import ../../../settings.nix;

in {
  # home.packages = with pkgs; [
  #   kitty
  # ];

  programs.kitty = {
    enable = true;

    font = {
      name = settings.font.monoFamily;
    };

    settings = {
      font_size = "18.0";
      scrollback_lines = "9999999999";
      open_url_modifiers = "ctrl";
      open_url_with = "default";
      copy_on_select = "yes";
    };

    keybindings = {
      "ctrl+t"            = "new_tab_with_cwd";
      "cmd+right"         = "next_tab";
      "ctrl+left"         = "previous_tab";
      "ctrl+shift+right"  = "move_tab_forward";
      "ctrl+shift+left"   = "move_tab_backward";
    };
  };
}
