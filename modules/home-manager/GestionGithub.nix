{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # 1. COMPTE PAR DÉFAUT
    settings = {
      user = { 
        name = "h4rp0crat3"; 
        email = "n.quefelec@gmail.com"; 
      };
      core = {
        sshCommand = "ssh -i ~/.ssh/id_github_perso";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      safe = {
        directory = "*";
      };
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
      };
    };
    
    includes = [
      {
        # 2. EXCEPTION ÉTUDIANT
        # Modification ici : on utilise le slash de fin au lieu de **
        condition = "gitdir:~/Documents/BUT/";
        contents = {
          user = { 
            name = "Neven Quefelec"; 
            email = "neven.quefelec@etu.univ-orleans.fr"; 
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/id_github_pro";
          };
        };
      }
    ];
  };
}