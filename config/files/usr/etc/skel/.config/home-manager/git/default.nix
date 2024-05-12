{ pkgs, lib, ... }:

with builtins;
let
  # builtins.split has an interesting return value. Removes non-strings.
  split_new_lines = s: filter (x: isString(x) && stringLength(x) > 0) (split "\n" s);
  join_semicolons = concatStringsSep "; ";
  # Wraps a list of commands in a function call for use in a git alias.  This
  # function partly exists for readability. To have multiline alias strings
  # within git config one would normally have to append '\' to each line.
  # Fun fact: Aliases that start a new shell (start with !) are run at the git root rather than the current directory.
  git_alias = commands: ''!f() { cd -- ''${GIT_PREFIX:-.}; ${join_semicolons (split_new_lines commands)}; }; f'';
in
  {
    home.packages = with pkgs; [
      perl # Hm. git aliases need this...
      gitAndTools.diff-so-fancy
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "Meptl";
      userEmail = "git-client@meptl.com";
      ignores = [
        ".vim/coc-settings.json"
        ".solargraph.yml"
      ];
      aliases = {
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
        dig = "lg --follow --";

        sync-upstream = git_alias ''
          git fetch upstream
          git merge upstream/$(git rev-parse --abbrev-ref HEAD)
        '';
        sync-origin = ''!git fetch --all && git reset --hard @{u}'';

        # Note this behaves slightly differently than a stash, it does not effect the current git state.
        stash-staged = git_alias ''
          git stash --keep-index
          git stash save --keep-index $1
          git stash apply 'stash@{1}'
          git stash drop 'stash@{1}'
        '';
        stash-unapply = git_alias ''git stash show $1 --patch | git apply --reverse'';
        drop = ''!git stash && git stash drop'';

        alias = ''!git config -l | grep ^alias | cut -c 7-'';
        br = "branch";
        c = "commit";
        co = "checkout";
        df = "diff";
        dfp = ''!git df $(git parent)'';
        dfn = "diff --name-only --relative";
        dfnp = ''!git dfn $(git parent)'';
        # Returns a ref to the first named parent commit. The goal is "the commit you are rebased off of".
        # Example output of format:%D: tag: 2.100.0.3668+cache-20200312, master
        # The second awk fixes up the tag marker.
        parent = ''!git log --format=format:%D HEAD^ | awk -F, '{if (NF>0) print $1}' | awk '{print $NF}' | head -n 1'';
        rgf = ''!git log --patch --follow -- "*$1*"'';
        prune-branches = ''git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'';

        re =  git_alias ''eval $(python ${./git-restore.py} $@)'';
        st = "status";
      };
      extraConfig = {
        core.editor = "nvim";
        core.pager = "diff-so-fancy | less --tabs=4 -RFX";
        checkout.defaultRemote = "origin";
        color = {
          diff-highlight.oldNormal    = "red bold";
          diff-highlight.oldHighlight = "red bold 52";
          diff-highlight.newNormal    = "green bold";
          diff-highlight.newHighlight = "green bold 22";
          diff.meta       = "11";
          diff.frag       = "magenta bold";
          diff.commit     = "yellow bold";
          diff.old        = "red bold";
          diff.new        = "green bold";
          diff.whitespace = "red reverse";
        };
        diff.algorithm = "histogram";
        init.defaultBranch = "main";
        push.followTags = "true";
        pull.ff = "only";
        url = {
          # "git@github.com:" = { insteadOf = [ "https://github.com/" "https://api.github.com/" ]; };
          # "git@gitlab.com:" = { insteadOf = [ "https://gitlab.com/" ]; };
        };
      };
    };
  }
