{ config, pkgs, ... }:

{
  systemd.user.services.fetch-agenda = {
    Unit = {
      Description = "Mise à jour de l'agenda IUT pour Quickshell";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.dotfiles/scripts/fetch_agenda.py";
    };
  };

  systemd.user.timers.fetch-agenda = {
    Unit = {
      Description = "Timer pour la mise à jour de l'agenda";
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "2h";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
