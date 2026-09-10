{
  description = "Darwin Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    cats.url = "github:briheet/cats";
    cats.inputs.nixpkgs.follows = "nixpkgs";
    cats.inputs.home-manager.follows = "home-manager";


    # Zen stuff
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    # llm latest via numtide
    llm-agents.url = "github:numtide/llm-agents.nix";

    # Disko stuff
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darwin,
      ...
    }:
    {

      darwinConfigurations = {

        # invideo lappy
        goryutenmetsu = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            ./hosts/goryutenmetsu/default.nix
          ];
        };

        # personal lappy
        makima = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            ./hosts/makima/default.nix
          ];
        };
      };

      nixosConfigurations = {

        # zangetsu vm config
        zangetsu = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/zangetsu/default.nix
          ];
        };

        # Temp: You can use this to install nixos on remote machines;
        # Uses nixos-anywhere
        # Nixos anywhere setup
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.disko.nixosModules.disko
            ./hosts/hetzner/default.nix
          ];
        };
      };

      # Put other configs here for other systems
    };
}
