{ lib, pkgs, config, ... }:

let
  settings = import ../../../settings.nix;
  grep = (lib.getBin pkgs.gnugrep) + "/bin/grep";
  egrep = (lib.getBin pkgs.gnugrep) + "/bin/egrep";
  sed = (lib.getBin pkgs.gnused) + "/bin/sed";
  bash = (lib.getBin pkgs.bash) + "/bin/bash";
  cut = (lib.getBin pkgs.coreutils) + "/bin/cut";
  echo = (lib.getBin pkgs.coreutils) + "/bin/echo";
  tee = (lib.getBin pkgs.coreutils) + "/bin/tee";
  pacmd = (lib.getBin pkgs.pulseaudio) + "/bin/pacmd";
in {

  home.packages = with pkgs; [
    i3lock-color
  ];

  services = {
    screen-locker = {
      enable = true;
      lockCmd = "${lib.getBin pkgs.i3lock-color}/bin/i3lock-color -n -B 10 -c 000000";
      inactiveInterval = 60;
    };
  };

  xsession.windowManager.i3 = {
    enable = true;

    extraConfig = ''
      set $web      "1:"
      set $code     "2:"
      set $code-alt "3:"
      set $files    "4:"
      set $chat     "5:"
      set $open     "6:"
      set $open-alt "7:"
      set $music    "8:"
      set $games    "9:"
    '';

    config = {
      fonts = [
        "${settings.font.monoFamily} ${settings.font.defaultSize.points}"
      ];

      menu = "${lib.getBin pkgs.rofi}/bin/rofi -show run";
      terminal = "kitty";

      keybindings = let
        modifier = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        # Switch to workspace.
        "${modifier}+1"   = "workspace $web";
        "${modifier}+2"   = "workspace $code";
        "${modifier}+3"   = "workspace $code-alt";
        "${modifier}+4"   = "workspace $files";
        "${modifier}+5"   = "workspace $chat";
        "${modifier}+6"   = "workspace $open";
        "${modifier}+7"   = "workspace $open-alt";
        "${modifier}+8"   = "workspace $music";
        "${modifier}+9"   = "workspace $games";
        "${modifier}+Tab" = "workspace back_and_forth";

        # Move applications to another workspace.
        "${modifier}+Shift+1" = "move container to workspace $web";
        "${modifier}+Shift+2" = "move container to workspace $code";
        "${modifier}+Shift+3" = "move container to workspace $code-alt";
        "${modifier}+Shift+4" = "move container to workspace $files";
        "${modifier}+Shift+5" = "move container to workspace $chat";
        "${modifier}+Shift+6" = "move container to workspace $open";
        "${modifier}+Shift+7" = "move container to workspace $open-alt";
        "${modifier}+Shift+8" = "move container to workspace $music";
        "${modifier}+Shift+9" = "move container to workspace $games";

        # Move current window within the current workspace.
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Resize current window.
        "${modifier}+Shift+Left"  = "resize shrink width 2 px or 2 ppt";
        "${modifier}+Shift+Down"  = "resize grow height 2 px or 2 ppt";
        "${modifier}+Shift+Up"    = "resize shrink height 2 px or 2 ppt";
        "${modifier}+Shift+Right" = "resize grow width 2 px or 2 ppt";

        # Fullscreen current window.
        "${modifier}+f" = "fullscreen toggle";

        # Kill current window.
        "${modifier}+w" = "kill";

        # Split window horizontally.
        # "${modifier}+x" = "split h";

        # Split window verticalally.
        # "${modifier}+v" = "split v";

        # Toggle between stacking/tabbed/split.
        "${modifier}+t" = "layout toggle";
      };

      gaps = {
        inner = 12;
        outer = 6;
      };

      bars = [{
        position = "top";

        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configFile."i3status-rust/config-top.toml".target}";

        fonts = [
          "${settings.font.nerdFamily} ${settings.font.defaultSize.points}"
          "${settings.font.monoFamily} ${settings.font.defaultSize.points}"
        ];

        trayOutput = "primary";
      }];

      window = {
        border = 1;
        titlebar = false;
      };

      floating = {
        border = 1;
        titlebar = false;
      };
    };
  };

  xdg.dataFile."bin/toggle-sound-output" = {
    executable = true;

    text = ''
      #!${bash}

      set -e

      # Get in-use sink (set as the default-sink)
      current_output=$(${pacmd} dump | ${grep} set-default-sink | ${cut} -d\  -f2)
      ${echo} "Current Output: $current_output" | ${tee} -a ~/click.log

      # Only select alsa outputs, only outputs I want (edifier speakers, steelseries headset), and not the current output
      next_output=$(${pacmd} list-sinks | ${grep} name: | ${grep} alsa_output | ${egrep} 'EDIFIER|SteelSeries' | ${grep} -v $current_output)
      next_output_name=$(${echo} $next_output | ${sed} -e 's/^.*<\(.*\)>$/\1/')

      ${echo} "Next output: $next_output_name" | ${tee} -a ~/click.log

      ${pacmd} set-default-sink $next_output_name | ${tee} -a ~/click.log
    '';
  };

  programs.i3status-rust = {
    enable = true;

    bars = {
      top = {
        settings = {
          theme = {
            name = "modern";
          };

          icons = {
            name = "awesome5";
            overrides = {
              memory_mem = "💭 ";
              cpu = "🖥️ ";
              thermometer = "🌡️";
              volume_empty = "🔈";
              volume_muted = "🔇";
              volume_half = "🔉";
              volume_full = "🔊";
              time = "🕓";
            };
          };
        };

        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
          }

          {
            block = "memory";
            display_type = "memory";
            format_mem = "{Mup}%";
            clickable = false;
            interval = 4;
          }

          {
            block = "cpu";
            interval = 2;
            format = "{utilization}% {frequency}GHz";
          }

          #  {
          #    block = "load";
          #    format = "{1m} {5m}";
          #    interval = 4;
          #  }

          {
            block = "temperature";
            collapsed = false;
            interval = 4;
            format = "{max}°";
            chip = "k10temp-*";
          }

          # {
          #   block = "nvidia_gpu";
          #   label = "GFX";
          #   show_memory = false;
          #   interval = 1;
          # }

          # {
          #   block = "net";
          #   device = "enp6s0";
          #   interval = 2;
          # }

          {
            driver = "pulseaudio";
            block = "sound";
            step_width = 6;
            format = "{output_name} {volume}%";
            on_click = config.xdg.dataFile."bin/toggle-sound-output".target;
            mappings = {
              "alsa_output.usb-EDIFIER_EDIFIER_S880DB-00.analog-stereo" = " Speakers📣";
              "alsa_output.usb-SteelSeries_Arctis_Pro_Wireless-00.stereo-game" = " Headset🎧";
            };
          }

          {
            block = "time";
            interval = 60;
            format = "%d %b %l:%M %p";
          }
        ];
      };
    };
  };
}
