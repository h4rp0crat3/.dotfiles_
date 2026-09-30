{ config, pkgs, ...}: 

{
    imports = 
    [
    ./hardware-configuration.nix
    ];
    
    # Demarrage ultra-rapide sans menu
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true; 
    boot.loader.timeout = 0; # Masque le menu et lance directement la dernière version

    # Reseau et nom de la machine 
    networking.hostName = "Asus_Neven";
    networking.networkmanager.enable = true; 

    # Localisation et claviers 
    time.timeZone = "Europe/Paris"; 
    i18n.defaultLocale = "fr_FR.UTF-8";

    services.tailscale.enable = true;

    services.xserver.xkb = {
    layout = "fr"; 
    variant = "azerty";
    };
    console.keyMap = "fr"; 

    services.syncthing = {
    enable = true;
    user = "harpocrate";
    dataDir = "/home/harpocrate";
    configDir = "/home/harpocrate/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };

    services.udisks2.enable = true;

    hardware.bluetooth.enable = true; # Active le support BlueZ
    hardware.bluetooth.powerOnBoot = true; # Allume le Bluetooth au démarrage

    virtualisation.docker.enable = true;

    # Variables d'environnement globales du système
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    # Acceleration Materiel
    hardware.graphics = {
    enable = true; 
    extraPackages = with pkgs; [
        intel-media-driver
        libva-utils
        intel-vaapi-driver
        ];
    };

    # Activation du bus I2C pour communiquer avec le NumberPad
    hardware.i2c.enable = true;
    boot.kernelModules = [ "i2c-dev" ];

    nixpkgs.config = {
        allowUnfree = true;
        # Tes autres options comme allowUnfreePredicate si tu en as
    };

    services.asus-numberpad-driver = {
        enable = true;
        layout = "up5401ea";
        wayland = true;
        waylandDisplay = "wayland-1";
        
        config = {
          "activation_time" = "0.1";
          "top_left_icon_activation_time" = "0.25";
          "top_left_icon_brightness_func_max_min_only" = "0";
          "enabled_touchpad_pointer" = "0";
          "sys_numlock_enables_numpad" = "0";   # ← nouveau : ne plus activer le pavé quand NumLock s'active
        };
    };

    virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    ports = [ "127.0.0.1:20128:20128" ];
    volumes = [ "omniroute-data:/app/data" ];
    environment = {
      OMNIROUTE_MEMORY_MB = "8192";
    };
    extraOptions = [ "--memory=10g" ];
    autoStart = true;
  };

    services.thermald.enable = true; 
    services.power-profiles-daemon.enable = true; 
    services.upower.enable = true; 

    # Audio pipeware 
    security.rtkit.enable = true; 
    services.pipewire = {
    enable = true; 
    alsa.enable = true; 
    alsa.support32Bit = true; 
    pulse.enable = true; 
    };

    hardware.enableAllFirmware = true;
    hardware.pulseaudio.enable = false;

    programs.niri.enable = true; 

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestions = {
    enable = true;
    highlightStyle = "fg=8";
  };
  syntaxHighlighting = {
    enable = true;
    styles = {
      command = "fg=2";
      # error = "fg=1";
    };
  };
};

    programs.starship = {
      enable = true;
      presets = ["pure-preset"];
      settings = {
        add_newline = false;
        # Tu pourras customiser le style ici plus tard si tu veux
      };
    };

    users.users.harpocrate = { 
    isNormalUser = true; 
    description = "Harpocrate"; 
    extraGroups = ["docker" "networkmanager" "wheel" "video" "input"];
    initialPassword = "nixos";
    shell = pkgs.zsh;
    packages = with pkgs; [
    firefox
    kitty
    git
    ];
    };

    environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    wl-clipboard
    xwayland-satellite
    ];

    # Configuration du demarrage silencieux (Masque les logs [OK])
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    
    boot.kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "loglevel=3"
    ];
    
    programs.kdeconnect.enable = true;

    # Interface graphique de demarrage
    boot.plymouth.enable = true;
    # boot.plymouth.theme = "bgrt"; # Optionnel : décommente si tu veux le thème du constructeur au lieu du flocon NixOS

    nix.settings.experimental-features = ["nix-command" "flakes"];
    system.stateVersion = "24.05";
}