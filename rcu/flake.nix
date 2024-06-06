{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.default = pkgs.callPackage ./. {};
    # packages.${system}."rcu-real" = pkgs.callPackage ./fhs.nix { };
    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.default}/bin/rcu";
    };
  };
}
