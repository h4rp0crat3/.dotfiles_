{ config, pkgs, ... }:

{
  home.username = "harpocrate";
  home.homeDirectory = "/home/harpocrate";
  home.stateVersion = "24.05";

  imports = [
    ./modules/home-manager/apps.nix
    ./modules/home-manager/kitty.nix
    ./modules/home-manager/services.nix
    ./modules/home-manager/GestionGithub.nix
  ];

  programs.home-manager.enable = true;

  services.udiskie = {
    automount = true;
    enable = true;
    tray = "auto";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [ wl-clipboard ripgrep ];
  };

  # Matugen : paquet + configuration manuelle (pas de module home-manager)
  home.packages = [ pkgs.matugen ];

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.neovim]
    input_path = '${./nvim-colors.json}'
    output_path = '${config.home.homeDirectory}/.cache/matugen/nvim-colors.json'
    post_hook = 'pkill -SIGUSR1 nvim'
  '';
}