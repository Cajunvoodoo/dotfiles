{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # cajun-xmonad = "file:///home/cajun/Projects/Haskell/xmonad-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      # follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cajun-wallpaper-tool = {
      url = "github:cajunvoodoo/wallpaper-tool";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xmobar-cajun = {
      url = "github:cajunvoodoo/xmobar-cajun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    binary-ninja = {
      url = "github:jchv/nix-binary-ninja";
    };

    # pwndbg-src = {
    #   url = "github:pwndbg/pwndbg";
    # };
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        #cajun-xmonad.default
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        # packages.default = pkgs.hello;
        # formatter = pkgs.nixfmt-rfc-style;
        formatter = pkgs.alejandra;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        nixosConfigurations.cajun = inputs.nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs {
            inherit system;

            config = {
              allowUnfree = true;
              packageOverrides = pkgs: {
                # "package" = pkgs."package".overrideAttrs (attrs: {...})
              };
            };
            overlays = [
              inputs.emacs-overlay.overlay # breaks doom on 30.??
            ];
          };
          specialArgs = {inherit inputs;};
          # extraSpecialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            # inputs.nixos-hardware.nixosModules.system76-gaze18
            # agenix
            # agenix.nixosModules.default
            # home manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cajun = import ./home/home.nix;
              home-manager.extraSpecialArgs = {inherit inputs;};

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      # homeManagerModules = {
      #   everything = import ./home/home.nix;
      # };

      # homeConfigurations = {
      #   # FIXME replace with your username@hostname
      #   "cajun@cajun" = inputs.home-manager.lib.homeManagerConfiguration {
      #     pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     extraSpecialArgs = {inherit (self) outputs; inherit inputs;};
      #     modules = [
      #       # > Our main home-manager configuration file <
      #       ./home/home.nix
      #     ];
      #   };
      # };
    };
}
