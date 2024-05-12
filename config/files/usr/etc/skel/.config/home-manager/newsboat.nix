{ pkgs, ... }:

{
  enable = true;
  extraConfig = ''
    # unbind keys
    unbind-key j
    unbind-key k
    unbind-key J
    unbind-key K

    # bind keys - vim style
    bind-key j down
    bind-key k up

    # colorscheme
    color listfocus white black bold
    color listnormal_unread magenta black
    color listfocus_unread magenta black bold

    color title white black bold
    color info white black bold

    color hint-key white black bold
    color hint-keys-delimiter white black
    color hint-separator white black bold
    color hint-description white black
  '';
  urls = [
    { url = "https://godotengine.org/rss.xml"; }
    { url = "https://nixos.org/blog/announcements-rss.xml"; }
    { url = "https://ciechanow.ski/atom.xml"; }
    { url = "https://svelte.dev/blog/rss.xml"; }
    { url = "https://meptl.com/blog/rss.xml"; }
    { url = "https://meptl.com/twits/rss.xml"; }

  ];
}
