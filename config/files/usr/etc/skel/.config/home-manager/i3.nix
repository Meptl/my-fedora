{ pkgs, ... }:

rec {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      startup = let
        list_files = ''ls -d $DIR/* | grep -v "^$DIR/latest$"'';
        list_files_sorted = ''ls -td $DIR/* | grep -v "^$DIR/latest$"'';
        entr_cmd = ''entr -nd ln -fs "$(${list_files_sorted} | head -n 1)" $DIR/latest'';
      in [
        { command = "autorandr -l desktop"; notification = false; } # Configure using arandr
        { command = "feh --bg-tile ${../modules/noise.png}"; notification = false; }
        { command = "autotiling"; notification = false; }
        { command = "wal -i ${../modules/colorscheme-image.webp} --saturate 0.4 -n -a 0"; notification = false; }
        { command = ''xinput set-prop "pointer:Logitech G305" "libinput Middle Emulation Enabled" 0''; notification = false; }
        { command = "signal-desktop"; notification = false; }
        { command = "Discord"; notification = false; }
        { command = "i3-msg 'workspace 1'; firefox"; notification = false; }
        { command = "i3-msg 'workspace 1'"; }
        # Maintain a $HOME/Downloads/latest to point to the most recently modified file in the folder.
        # { command = ''DIR=$HOME/Downloads; while true; do ${list_files} | ${entr_cmd}; done''; notification = false; }
        # { command = ''xsetwacom set "Wacom Bamboo Pen Pen stylus" MapToOutput 2400x1440+1360+0''; notification = false; }
        { command = ''sleep 5 && xinput map-to-output "pointer:UGTABLET 24 inch PenDisplay stylus" HDMI-A-0''; notification = false; }
        # { command = ''sleep 5 && carla-rack -n /home/yutoo/micfilter.carxp''; notification = false; }
        # { command = ''obs --startreplaybuffer''; notification = false; }
      ];
      floating = {
        criteria = [
          { class = "org.gnome.Nautilus"; }
        ];
      };
      assigns = {
        "9" = [{ class = "^Signal$|^discord$"; }];
        "8" = [{ class = "^obs$"; }];
      };
      workspaceOutputAssign = let
        # Configure multimonitor setup for specific hosts.
        # TODO: use user@host home-manager config?
        output = spaceNum: if "fume" == "fume" then
                             if spaceNum < 6 || spaceNum == 0 then { output = "HDMI-A-0"; }
                             else { output = "DisplayPort-2"; }
                           else {};
        workspace = spaceNum: { workspace = builtins.toString spaceNum; } // output spaceNum;
      in [
        (workspace 1)
        (workspace 2)
        (workspace 3)
        (workspace 4)
        (workspace 5)
        (workspace 6)
        (workspace 7)
        (workspace 8)
        (workspace 9)
        (workspace 10)
      ];
      keybindings = let mod = config.modifier; in {
        "${mod}+Ctrl+f" = "exec firefox";
        "${mod}+Return" = "exec tabbed -o '#a285cb' -t '#222222' -c alacritty --embed";
        "${mod}+Shift+Return" = "exec rofi -run-list-command '. ~/.config/rofi/zsh_aliases.sh' -run-command \"${pkgs.zsh}/bin/zsh -ic '{cmd}'\" -rnow -show run";

        "${mod}+Escape" = "exec i3lock-fancy";
        "${mod}+Shift+t" = "exec compton-trans -c 70";
        "${mod}+Ctrl+l" = "exec layout_manager.sh";

        "${mod}+Shift+Tab" = "floating toggle";
        "${mod}+backslash" = "split h";
        "${mod}+minus" = "split v";

        "${mod}+Shift+period" = "resize grow width 50px";
        "${mod}+Shift+comma" = "resize shrink width 50px";
        "${mod}+Shift+minus" = "resize shrink height 50px";
        "${mod}+Shift+equal" = "resize grow height 50px";

        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-msg 'exit'";
        "${mod}+Shift+q" = "kill";
        "${mod}+f" = "fullscreen";

        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+h" = "move left 40";
        "${mod}+Shift+j" = "move down 40";
        "${mod}+Shift+k" = "move up 40";
        "${mod}+Shift+l" = "move right 40";
        "${mod}+Shift+Left" = "move left 40";
        "${mod}+Shift+Down" = "move down 40";
        "${mod}+Shift+Up" = "move up 40";
        "${mod}+Shift+Right" = "move right 40";
        "${mod}+Ctrl+Shift+h" = "move workspace to output left";
        "${mod}+Ctrl+Shift+j" = "move workspace to output down";
        "${mod}+Ctrl+Shift+k" = "move workspace to output up";
        "${mod}+Ctrl+Shift+l" = "move workspace to output right";
        "${mod}+Ctrl+Shift+Left" = "move workspace to output left";
        "${mod}+Ctrl+Shift+Down" = "move workspace to output down";
        "${mod}+Ctrl+Shift+Up" = "move workspace to output up";
        "${mod}+Ctrl+Shift+Right" = "move workspace to output right";

        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";
        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5";
        "${mod}+Shift+6" = "move container to workspace 6";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8";
        "${mod}+Shift+9" = "move container to workspace 9";
        "${mod}+Shift+0" = "move container to workspace 10";
      };
      focus = {
        forceWrapping = false;
        followMouse = false;
        newWindow = "none";
      };
      bars = [{ mode = "invisible"; }];
      window = {
        titlebar = false;
        border = 3;
      };
      gaps = {
        inner = 10;
      };
      colors.focused = {
        background = "#a285cb";
        border = "#a285cb";
        childBorder = "#a285cb";
        indicator = "#a285cb";
        text = "#c6c6c6";
      };
    };
  }
