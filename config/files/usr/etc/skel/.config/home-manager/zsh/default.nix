{ pkgs, ... }:

with builtins;
let
  dotDir = ".config/zsh";
in
  {
    home.packages = with pkgs; [
      expect  # See nix repl functions.zsh
      gnome3.nautilus

      # ocrsnap shell alias
      imagemagick
      tesseract5
    ];
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      dotDir = dotDir;
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignorePatterns = [
          "vim *" "ls *" "ls" "cat *" "rg *" "echo *" "man *"
          "alsamixer" "dmesg *"
          "reboot*" "shutdown *"
          "git commit*" "git add*"
        ];
        size = 1000000000; # 100MB
      };

      envExtra = ''
        path+=~/bin
        path+=~/.npm/bin
        path+=~/.cargo/bin
        BUNDLE_PATH=vendor/bundle
      '';
      sessionVariables = {
        EDITOR = "nvim";
        NIXPKGS_ALLOW_UNFREE = 1;
        FZF_DEFAULT_COMMAND = ''rg --files --no-ignore --hidden --follow --color never --glob \!.git 2>/dev/null'';
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "bgnotify"
          "colored-man-pages"
          "git-prompt"
          "vi-mode"
        ];
        # These occur before oh-my-zsh's compinit.
        # Which allows CASE_SENSITIVE to function properly.
        extraConfig = ''
          # For zsh autocomplete engine.
          CASE_SENSITIVE="true"
        '';
      };
      initExtra = let
        # Call into python scripts with command name as argument.
        as_py_funcs = map (f: "function ${f} { python ${./zsh.py} ${f} $@ }");
        python_commands = concatStringsSep "\n" (as_py_funcs [
          "vimrg"
          "vimfd"
          "rgf"
          "stamp"
          "unzip"
          "sedrg"
        ]);
        # Aliases that forward to other commands but supply their args.
        as_sh_func = set: value: "function ${value} { ${getAttr value set} }";
        as_sh_funcs = set: map (as_sh_func set) (attrNames set);
        arged_aliases = concatStringsSep "\n" (as_sh_funcs {
          vimf = "vim -p $(rgf $@)";
          vimrgf = "vimf $@";
        });
      in
        ''
        # External oh-my-zsh plugins
        # source ${./nix-shell.plugin.zsh}

        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        # oh-my-zsh's git-prompt sets RPROMPT. Clear it.
        RPROMPT=""
        PROMPT='%F{245}%~$(git_super_status) %F{140}$ %f'

        # TODO: Make git-prompt not garbage by removing useless.
        ZSH_THEME_GIT_PROMPT_PREFIX=" "
        ZSH_THEME_GIT_PROMPT_SUFFIX=""
        ZSH_THEME_GIT_PROMPT_SEPARATOR=""
        ZSH_THEME_GIT_PROMPT_BRANCH="%F{250}"
        ZSH_THEME_GIT_PROMPT_STAGED=" %{$fg[red]%}%{●%G%}"
        ZSH_THEME_GIT_PROMPT_CONFLICTS=" %{$fg[red]%}%{✖%G%}"
        ZSH_THEME_GIT_PROMPT_CHANGED=" %{$fg[green]%}%{✚%G%}"
        ZSH_THEME_GIT_PROMPT_BEHIND=" %{↓%G%}"
        ZSH_THEME_GIT_PROMPT_AHEAD=" %{↑%G%}"

        # Workaround for not being able to disable these values. Make them black font.
        ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[black]%}"
        ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[black]%}"
        ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[black]%}"

        # vi-mode ESC with jk
        bindkey -v
        # Note this is escaping nix strings
        bindkey -e jk vi-cmd-mode

        unsetopt autocd
        unsetopt share_history
        unset SSH_ASKPASS

        # Regular .zshrc configs.
        eval "$(direnv hook zsh)"

        eval "wal -R --saturate 0.4 -n -a 0 -q"

        if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi

        # [[ -z "$TMUX" ]] && [[ -z "$NO_TMUX" ]] && tmux new-session

        ${readFile ./functions.zsh}
        export OPENAI_API_KEY=$(cat /run/secrets/openai/api-key)
        export LLM_NVIM_API_TOKEN=$(cat /run/secrets/huggingface/api-key)
        ${readFile ./lazyshell.zsh}

        ${python_commands}
        ${arged_aliases}

        # Modify the bgnotify notification to play a sound. Uses a function
        # we've defined so is defined after those.
        function bgnotify_formatted {
          loudly bgnotify "$2: $1"
        }
      '';
      shellAliases = let
        # Retrieve these everytime I call the binary.
        # In short I don't use them often to always have them in my system.
        remote_pkgs = with pkgs; [
          # godot
          kicad
          inkscape
          wireshark
          kdenlive
        ];
        runner = "echo 'Downloading...' && nix run -- github:NixOS/nixpkgs/$(nixos-version --json | jq -r .nixpkgsRevision)#";
        remote_pkg_aliases = builtins.listToAttrs (builtins.map (pkg: { name = pkg.pname; value = "${runner}${pkg.pname}"; }) remote_pkgs);
      in remote_pkg_aliases // {

        # Tools.
        fbrowse = "nautilus";
        crop = "gthumb";
        rss = "newsboat -r";
        serve-web = "python -m http.server";
        video-crop = "ghb";  # From handbrake package.
        torrent = "transmission";

        k8 = "kubectl";
        vim = "nvim";
        xclip = "xclip -selection c";
        fd = "fd -HI";
        mpv = "mpv --volume=60";
        ungron = "gron --ungron";

        vimeos = "cd /etc/nixos; vim -p localhost.nix configuration.nix home/default.nix; cd -";
        vimdfn = "vim -p $(git dfn)";
        vimdfnp = "vim -p $(git dfnp)";
      };
    };

    home.file = {
      ".direnvrc" = { source = ./direnvrc.sh; };
    };
  }
