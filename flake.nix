{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    kmonad.url = "github:kmonad/kmonad?ref=0.4.2&dir=nix";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
    home-manager,
    kmonad,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in rec {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs;});
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./shell.nix {inherit pkgs;});

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      crockpot = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main nixos configuration file <
          kmonad.nixosModules.default
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "kasuari@crockpot" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          nixvim.homeManagerModules.nixvim
          ./home-manager/home.nix
        ];
      };

      "gu@osx" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs-darwin.legacyPackages.x86_64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          nixvim.homeManagerModules.nixvim
          ./home-manager/darwin.nix
        ];
      };
    };
  };
}
