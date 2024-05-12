{ config, pkgs, inputs, ... }@attrs:

with builtins;
{
  imports = [
    ./zsh
    ./git
  ];

  home.stateVersion = "21.11";

  xsession.enable = true;
  xsession.windowManager.i3 = (import ./i3.nix attrs);
  programs.neovim = (import ./vim pkgs );
  programs.alacritty = (import ./alacritty.nix pkgs);
  programs.newsboat = (import ./newsboat.nix pkgs);
  services.dunst = (import ./dunst.nix);

  services.picom = {
    enable = false;
    backend = "glx";
    # inactiveDim = "0.2";
    # opacityRule = [
    #   "86:class_g = 'Firefox' && !focused"
    #   "70:class_g = 'URxvt' && !focused"
    #   "94:class_g = 'Firefox' && argb"  # Drop down menus
    #   "94:class_g = 'URxvt' && focused"
    #   # I don't know why this is necessary but it is...
      # "99:class_g = 'Dunst'"
    # ];
  };

  services.easyeffects = {
    enable = true;
    preset = "DenoiseCompressor";
  };

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    theme = {
      name = "Adapta-Nokto-Eta";
      package = pkgs.adapta-gtk-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.file = {
      ".config/rofi/zsh_aliases.sh" = { text = "
        #!${pkgs.zsh}/bin/zsh -i
        alias | awk -F'[ =]' '{print $1}'
      "; };
  };
}
