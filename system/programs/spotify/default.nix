{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # spotify-qt
    spotify
  ];
}
