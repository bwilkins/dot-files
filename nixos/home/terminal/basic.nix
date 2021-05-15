{ lib, pkgs, config, ... }:

let
  settings = import ../../settings.nix;

  gpg-agent-config = {
    enable = if pkgs.stdenvNoCC.isDarwin then false else true;
    enableSshSupport = true;
    enableScDaemon = true;
    sshKeys = [
      settings.user.gpg.authenticationKey
    ];
  };
in {
  imports = [
    ./custom/neovim.nix
  ];

  nixpkgs.overlays = [
    (import ../../pkgs)
    (self: super: { notmuch = super.notmuch.overrideAttrs (_: { withEmacs = true; });})

  ];

  home.packages = with pkgs; [
    bundix
    coreutils
    curl
    du-dust
    exa
    fd
    fzy
    gnupg
    htop
    keylightctl
    offlineimap
    notmuch
    rofi-pass
    (if stdenvNoCC.isDarwin then pinentry_mac else pinentry)
    ripgrep
    sqlite
    tig
    unzip
    wget
  ];

  home.sessionPath = ["$HOME/bin" "${config.xdg.dataHome}/bin"];

  programs = {
    bat = {
      enable = true;
    };

    git = {
      enable = true;
      userName = settings.user.name;
      userEmail = settings.user.email;

      signing = {
        signByDefault = true;
        key = settings.user.gpg.signingKey;
      };

      delta = {
        enable = true;
      };

      extraConfig = {
        pull = {
          ff = "only";
        };
        core = {
          excludesfile = "~/.gitignore_global";
        };
      };
    };

    htop = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    fish = {
      enable = true;
    };

    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };

      shellAliases = {
        be = "bundle exec";
        bi = "bundle install";
        ls = "exa";
        find = "fd";
      };

      initExtra = ''
        unset MAILCHECK

        if [ -a "''${HOME}/.bash_env" ]; then
          source "''${HOME}/.bash_env"
        fi

        # Replace cd with pushd https://gist.github.com/mbadran/130469
        function push_cd() {
          # typing just `push_cd` will take you $HOME ;)
          if [ -z "$1" ]; then
            push_cd "$HOME"

          # use `push_cd -` to visit previous directory
          elif [ "$1" == "-" ]; then
            if [ "$(dirs -p | wc -l)" -gt 1 ]; then
              current_dir="$PWD"
              popd > /dev/null
              pushd -n $current_dir > /dev/null
            elif [ -n "$OLDPWD" ]; then
              push_cd $OLDPWD
            fi

          # use `push_cd -l` or `push_cd -s` to print current stack of folders
          elif [ "$1" == "-l" ] || [ "$1" == "-s" ]; then
            dirs -v

          # use `push_cd -l N` to go to the Nth directory in history (pushing)
          elif [ "$1" == "-g" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
            indexed_path=$(dirs -p | sed -n $(($2+1))p)
            push_cd $indexed_path

          # use `push_cd +N` to go to the Nth directory in history (pushing)
          elif [[ "$1" =~ ^+[0-9]+$ ]]; then
            push_cd -g ''${1/+/}

          # use `push_cd -N` to go n directories back in history
          elif [[ "$1" =~ ^-[0-9]+$ ]]; then
            for i in `seq 1 ''${1/-/}`; do
              popd > /dev/null
            done

          # use `push_cd -- <path>` if your path begins with a dash
          elif [ "$1" == "--" ]; then
            shift
            pushd -- "$@" > /dev/null

            # basic case: move to a dir and add it to history
          else
            pushd "$@" > /dev/null

            if [ "$1" == "." ] || [ "$1" == "$PWD" ]; then
              popd -n > /dev/null
            fi
          fi

          if [ -n "$CD_SHOW_STACK" ]; then
            dirs -v
          fi
        }

        # replace standard `cd` with enhanced version, ensure tab-completion works
        alias cd=push_cd
        complete -d cd
      '';
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNixDirenvIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        add_newline = true;
        line_break.disabled = true;
        package.disabled = true;
        rust.format = "$symbol ";
        nix_shell.format = "$symbol ";
        ruby.format = "$symbol ";
        nodejs.format = "$symbol ";
      };
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp /* exts.pass-import */]);
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };

    offlineimap = {
      enable = true;

      extraConfig.general = {
        fsync = false;
      };

      pythonFile = ''
        from subprocess import check_output

        def get_pass(account, *args):
          return check_output("pass Mail/" + account, shell=True).splitlines()[0]
      '';
    };

    notmuch = {
      enable = true;
      hooks = {
        preNew = ''
          ${lib.getBin pkgs.offlineimap}/bin/offlineimap -o;
        '';

        postNew = ''
          ${lib.getBin pkgs.afew}/bin/afew --tag --new
        '';
      };

      new = {
        tags = [ "new" ];
      };
    };

    afew = {
      enable = true;

      extraConfig = ''
        [FolderNameFilter]
          folder_transforms = Sent\ Mail:sent Drafts:draft Trash:deleted Deleted\ Messages:deleted Bin:deleted Sent\ Messages:sent UnrealEngine.Spam:spam
          folder_lowercases = true
        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]
        [InboxFilter]
      '';
    };
  };

  accounts.email.maildirBasePath= "Mail";
  accounts.email.accounts."brett@brett.geek.nz" = {
    address  = "brett@brett.geek.nz";
    userName = "brett@brett.geek.nz";
    realName = "Brett Wilkins";
    primary  = true;
    passwordCommand = "";
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };

    maildir.path = "brett@brett.geek.nz";

    offlineimap = {
      enable = true;

      extraConfig.remote = {
        maxconnections = 3;
      };
    };

    notmuch = {
      enable = true;
    };
  };
  accounts.email.accounts."bushido.katana@gmail.com" = {
    address  = "bushido.katana@gmail.com";
    userName = "bushido.katana@gmail.com";
    realName = "Brett Wilkins";
    passwordCommand = "";
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };

    maildir.path = "bushido.katana@gmail.com";

    offlineimap = {
      enable = true;

      extraConfig.remote = {
        maxconnections = 3;
      };
    };

    notmuch = {
      enable = true;
    };
  };
  accounts.email.accounts."brett@cogent.co" = {
    address  = "brett@cogent.co";
    userName = "brett@cogent.co";
    realName = "Brett Wilkins";
    passwordCommand = "";
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };

    maildir.path = "brett@cogent.co";

    offlineimap = {
      enable = true;

      extraConfig.remote = {
        maxconnections = 3;
      };
    };

    notmuch = {
      enable = true;
    };
  };

  services = if pkgs.stdenvNoCC.isDarwin then {
    gpg-agent = gpg-agent-config;
  } else {
    gpg-agent = gpg-agent-config;
    lorri = {
      enable = true;
    };
  };
}
