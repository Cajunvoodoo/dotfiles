{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configuration/hardware-configuration.nix
    ./system76/default.nix
    ./power-management/default.nix
  ];
}
