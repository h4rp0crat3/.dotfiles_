{
  description = "Configuration système avec Niri, DMS, Qylock et Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dms = {
      url = "path:./modules/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qylock.url = "github:Darkkal44/qylock";
    asus-numberpad-driver.url = "github:asus-linux-drivers/asus-numberpad-driver";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      
    };

    openclaw.url = "github:Scout-DJ/openclaw-nix";

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, dms, qylock, home-manager, openclaw, matugen, ... }@inputs: {
    nixosConfigurations.AsusNeven = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/AsusNeven/configuration.nix
        ./hosts/AsusNeven/openclaw.nix

        inputs.dms.nixosModules.default
        inputs.qylock.nixosModules.default

        {
          nixpkgs.overlays = [
            inputs.asus-numberpad-driver.overlays.default
            (final: prev: {
              asus-numberpad-driver = prev.asus-numberpad-driver.overrideAttrs (old: {
                postPatch = (old.postPatch or "") + ''
                  sed -i '/^backlight_levels = \[/,/^[[:space:]]*\]/c backlight_levels = ["0x41", "0x45", "0x48"]' layouts/up5401ea.py
                '';
              });
            })
          ];
        }

        inputs.asus-numberpad-driver.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.harpocrate = import ./home.nix;
        }

        ({ pkgs, ... }: {
          programs.dank-material-shell.enable = true;

          programs.qylock = {
            enable = true;
            theme = "pixel-munchlax";
          };

          nix.settings.experimental-features = [ "nix-command" "flakes" ];
        })
      ];
    };
  };
}
