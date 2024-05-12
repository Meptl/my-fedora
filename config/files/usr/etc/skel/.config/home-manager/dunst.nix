{
  enable = true;
  settings = {
    global = {
      font = "Share Tech Mono";
      plain_text = "yes";
      format = ''%s\n%b'';
      sort = "no";
      indicate_hidden = "no";
      alignment = "center";
      # Disable word wrap via side scroll
      bounce_freq = 0;
      startup_notification = "false";
      sticky_history = "no";
      history_length = 15;
      show_age_threshold = "-1";
      word_wrap = "yes";
      ignore_newline = "no";
      stack_duplicates = "no";
      hide_duplicates_count = "no";
      shrink = "true";
      follow = "keyboard";
      show_indicators = "no";

      # Don't remove messages if I've been idle for 5min
      idle_threshold = 300;

      geometry = "500x10-24-24";
      line_height = 3;
      separator_height = 2;
      padding = 6;
      horizontal_padding = 6;
      corner_radius = 10;

      # Define a color for the separator.
      # possible values are:
      #  * auto: dunst tries to find a color fitting to the background;
      #  * foreground: use the same color as the foreground;
      #  * frame: use the same color as the frame;
      #  * anything else will be interpreted as a X color.
      separator_color = "frame";


      # Align icons left/right/off
      icon_position = "off";
      max_icon_size = 80;

      # Paths to default icons.
      # icon_path = "/usr/share/icons/Paper/16x16/mimetypes/:/usr/share/icons/Paper/48x48/status/:/usr/share/icons/Paper/16x16/devices/:/usr/share/icons/Paper/48x48/notifications/:/usr/share/icons/Paper/48x48/emblems/";

      frame_width = 2;
      frame_color = "#994d84";
    };
    urgency_low = {
      frame_color = "#4e4e4e";
      foreground = "#c6c6c6";
      background = "#262626";
      timeout = 4;
    };
    urgency_normal = {
      frame_color = "#994d84";
      foreground = "#c6c6c6";
      background = "#262626";
      timeout = 6;
    };
    urgency_critical = {
      frame_color = "#b722ab";
      foreground = "#c6c6c6";
      background = "#4e4e4e";
      timeout = 8;
    };
  };
}
