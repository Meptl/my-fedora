{ pkgs, ... }:

{
  enable = true;
  settings = {
    window = {
      opacity = 0.0;
    };
    shell = {
      program = "${pkgs.zsh}/bin/zsh";
      args = [ "-i" ];
    };
    colors = {
      primary = {
        background = "#282828";
        foreground = "#eeeeee";
      };
      normal = {
        black = "#282828";
        red = "#f92672";
        green = "#a6e22e";
        yellow = "#f4bf75";
        blue = "#66d9ef";
        magenta = "#ae81ff";
        cyan = "#66d9ef";
        white = "#f8f8f2";
      };
      bright = {
        black = "#f92672";
        red = "#f92672";
        green = "#a6e22e";
        yellow = "#f4bf75";
        blue = "#66d9ef";
        magenta = "#ae81ff";
        cyan = "#66d9ef";
        white = "#f8f8f2";
      };
    };
    font = {
      size = 14;
    };
    keyboard.bindings = [
      # Modifier+Return doesn't work by default.
      # { key = "Return"; mods = "Shift"; chars = ''\x1b[13;2u''; }
      # { key = "Return"; mods = "Control"; chars = ''\x1b[13;5u''; }
      { key = "Return"; mods = "Shift"; chars = ''\u001B[13;2u''; }
      { key = "Return"; mods = "Control"; chars = ''\u001B[13;5u''; }
      { key = "V"; mods = "Control|Alt"; action = "PasteSelection"; }
      { key = "Key0"; mods = "Control|Shift"; action = "ResetFontSize"; }
      { key = "Plus"; mods = "Control|Shift"; action = "IncreaseFontSize"; }
      # Why this no work?
      { key = "Minus"; mods = "Control|Shift"; action = "DecreaseFontSize"; }
    ];
  };
}
