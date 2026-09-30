{ config, pkgs, inputs, ... }:

{
  # Import du module NixOS (utile si vous activez le service en arrière-plan)
  imports = [ inputs.openclaw.nixosModules.default ];

  # Applique l'overlay pour rendre le paquet pkgs.openclaw disponible
  nixpkgs.overlays = [ inputs.openclaw.overlays.default ];

  # Installation de l'outil pour le terminal Bash
  environment.systemPackages = with pkgs; [
    openclaw
  ];

  # -- OPTIONNEL --
  # Pour faire tourner OpenClaw en tâche de fond 24/7 sur un serveur headless :
  /*
  services.openclaw = {
    enable = true;
    domain = "localhost";
    modelProvider = "ollama"; # ou anthropic, openai, etc.
  };
  */
}