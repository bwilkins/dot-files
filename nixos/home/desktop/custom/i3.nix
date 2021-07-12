{ lib, pkgs, config, ... }:

let
  settings = import ../../../settings.nix;
  grep = (lib.getBin pkgs.gnugrep) + "/bin/grep";
  egrep = (lib.getBin pkgs.gnugrep) + "/bin/egrep";
  bash = (lib.getBin pkgs.bash) + "/bin/bash";
  echo = (lib.getBin pkgs.coreutils) + "/bin/echo";
  tee = (lib.getBin pkgs.coreutils) + "/bin/tee";
  awk = (lib.getBin pkgs.gawk) + "/bin/awk";
  pactl = (lib.getBin pkgs.pulseaudio) + "/bin/pactl";
  rofi = (lib.getBin config.programs.rofi.package) + "/bin/rofi";
in {

  home.packages = with pkgs; [
    i3lock-color
    clipcat
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
      set $chat     "2:"
      set $code     "3:"
      set $four     "4"
      set $five     "5"
      set $six      "6"
      set $seven    "7"
      set $eight    "8"
      set $games    "9:"

      set $launcher-clipboard-insert clipcat-menu insert
      set $launcher-clipboard-remove clipcat-menu remove

      assign [class="Mozilla Firefox"] $web
      assign [class="^Slack"] $chat
      assign [class="Discord$"] $chat
      assign [class="Mattermost$"] $chat
      assign [class="^Signal$"] $chat

      for_window [title="emacs-capture"] floating enable

      exec clipcatd
    '';

    config = {
      fonts = {
        names = [
          settings.font.monoFamily
        ];
        size = settings.font.defaultSize.pointsFloat;
      };

      menu = "\"${rofi} -show combi -modi combi -combi-modi run,emoji\"";
      terminal = "kitty";

      keybindings = let
        modifier = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        # Switch to workspace.
        "${modifier}+1"   = "workspace $web";
        "${modifier}+2"   = "workspace $chat";
        "${modifier}+3"   = "workspace $code";
        "${modifier}+4"   = "workspace $four";
        "${modifier}+5"   = "workspace $five";
        "${modifier}+6"   = "workspace $six";
        "${modifier}+7"   = "workspace $seven";
        "${modifier}+8"   = "workspace $eight";
        "${modifier}+9"   = "workspace $games";
        "${modifier}+Tab" = "workspace back_and_forth";

        # Move applications to another workspace.
        "${modifier}+Shift+1" = "move container to workspace $web";
        "${modifier}+Shift+2" = "move container to workspace $chat";
        "${modifier}+Shift+3" = "move container to workspace $code";
        "${modifier}+Shift+4" = "move container to workspace $four";
        "${modifier}+Shift+5" = "move container to workspace $five";
        "${modifier}+Shift+6" = "move container to workspace $six";
        "${modifier}+Shift+7" = "move container to workspace $seven";
        "${modifier}+Shift+8" = "move container to workspace $eight";
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

        # Toggle between stacking/tabbed/split.
        "${modifier}+t" = "layout toggle";

        # Emoji "keyboard"
        "${modifier}+e" = "exec ${rofi} -show emoji";

        # clipboard manipulation
        "${modifier}+Shift+v" = "exec $launcher-clipboard-insert";

        # screenshot
        "${modifier}+s" = "exec flameshot gui -p ~/Pictures/screenshots";

        # offline code docs
        "${modifier}+z" = "exec zeal";
      };

      gaps = {
        inner = 12;
        outer = 6;
      };

      bars = [{
        position = "top";

        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configFile."i3status-rust/config-top.toml".target}";

        fonts = {
          names = [
            settings.font.nerdFamily
            settings.font.monoFamily
          ];
          size = settings.font.defaultSize.pointsFloat;
        };

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

  xdg.configFile."clipcat/clipcatd.toml" = {
    text = ''
      daemonize = true
      max_history = 100
      log_level = 'ERROR'

      [monitor]
      load_current = true       # load current clipboard content at startup
      enable_clipboard = true   # watch X11 clipboard
      enable_primary = true     # watch X11 primary clipboard

      [grpc]
      host = '127.0.0.1'
      port = 45045
    '';
  };

  xdg.configFile."clipcat/clipcatctl.toml" = {
    text = ''
      server_host = '127.0.0.1'
      server_port = 45045
      log_level = 'ERROR'
    '';
  };

  xdg.configFile."clipcat/clipcat-menu.toml" = {
    text = ''
      server_host = '127.0.0.1' # host address of clipcat gRPC server
      server_port = 45045       # port number of clipcat gRPC server
      finder = 'rofi'

      [rofi]
      line_length = 200
      menu_length = 10
    '';
  };

  xdg.dataFile."bin/toggle-sound-output" = {
    executable = true;

    text = ''
      #!${bash}

      set -e

      # Get in-use sink (set as the default-sink)
      current_output=$(${pactl} info | ${grep} 'Default Sink:' | ${awk} '{print $3}')
      ${echo} "Current Output: $current_output" | ${tee} -a ~/click.log

      # Only select alsa outputs, only outputs I want (edifier speakers, steelseries headset), and not the current output
      next_output=$(${pactl} list short sinks | ${grep} alsa_output | ${egrep} 'EDIFIER|SteelSeries' | ${grep} -v $current_output)
      next_output_name=$(${echo} $next_output | ${awk} '{print $2}')

      ${echo} "Next output: $next_output_name" | ${tee} -a ~/click.log

      ${pactl} set-default-sink $next_output_name | ${tee} -a ~/click.log
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
              time = "🕓 ";
              toggle_off = "🌑";
              toggle_on = "💡";
              volume_empty = "🔈";
              volume_muted = "🔇";
              volume_half = "🔉";
              volume_full = "🔊";
            };
          };
        };

        blocks = [
/*
          {
            block = "toggle";
            text = " Keylight";
            command_on = ''curl -XPUT -d'{"numberOfLights": 1, "lights": [{ "on": 1 }]}' http://elgato-key-light-2404.local:9123/elgato/lights'';
            command_off = ''curl -XPUT -d'{"numberOfLights": 1, "lights": [{ "on": 0 }]}' http://elgato-key-light-2404.local:9123/elgato/lights'';
            command_state = ''bash -c 'light_status=$(curl http://elgato-key-light-2404.local:9123/elgato/lights      | jq .lights[0].on); if [ "$light_status" == "1" ]; then echo "on"; fi' '';
            interval = 60;
          }
*/
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            format = "/ {available}";
            unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
          }

          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_total_used_percents}";
            clickable = false;
            interval = 4;
          }

          {
            block = "cpu";
            interval = 2;
            format = "{utilization} {frequency}";
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
            format = "{max}";
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
            format = "{output_name} {volume}";
            on_click = config.xdg.dataFile."bin/toggle-sound-output".target;
            mappings = {
              "alsa_output.usb-EDIFIER_EDIFIER_S880DB-00.analog-stereo" = " Speakers📣";
              "alsa_output.usb-EDIFIER_EDIFIER_S880DB-00.output_analog-stereo" = " Speakers📣";
              "alsa_output.usb-SteelSeries_Arctis_Pro_Wireless-00.stereo-game" = " Headset🎧";
              "alsa_output.usb-SteelSeries_Arctis_Pro_Wireless-00.output_mono-chat_output_stereo-game_input_mono-chat" = " Headset🎧";
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
