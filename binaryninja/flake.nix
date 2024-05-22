{
  description = "Reverse Engineering in Style";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: true;
      };
    in {
      defaultPackage.${system} = pkgs.callPackage ./. { };
    };
}
