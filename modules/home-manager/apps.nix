{ pkgs, ... }:
{
  # Autoriser les paquets propriétaires (Spotify, etc.)
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # --- Utilitaires Wayland / Niri ---
    quickshell
    wl-clipboard
    grim
    slurp
    brightnessctl
    kando

    # --- Applications ---
    vesktop
    spotify
    wpsoffice
    vscode
    mpv 
    nautilus
    obs-studio   
    vlc
    thunderbird
    obsidian
    rpi-imager
    chromium

    # --- Base dev minimale ---
    firefox        # navigateur
    kitty          # terminal
    #neovim         # éditeur
    git            # versioning
    tailscale
    unzip 
    zip
    gcc
    gnumake

    # --- Quelques outils CLI qui servent tous les jours ---
    ripgrep        # grep en mieux
    fzf            # recherche fuzzy
    fd             # find en mieux
    tree           # Ajoute l'option de tree
    fastfetch      # Tous ca pour impressionner les badies ta capté     
    oculante

    # --- Fichiers / archives ---
    file-roller

    # -- IA / Open Code ---
    #opencode

    # -- Pour pouvoir utiliser Omnicode *
    nodejs # ou nodejs_26 si explicitement supporté par votre version de nixpkgs

    # --- Pour les machines virtuels 
    qemu
  ];
}