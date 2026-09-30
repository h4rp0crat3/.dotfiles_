{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      hide_window_decorations = "yes";
      background_opacity = "0.85";
      background_blur = "32";
      window_padding_width = "12";
    };

    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };
}