{...}: {
  imports = [
    # Utility
    # ./audacity/default.nix
    # Audio & Music
    ./spotify/default.nix
    # WM Setup
    # TODO: Replace with xmonad
    ./powertop/default.nix
    # Virtualization
    ./virtualization/virtualization.nix
    # Social TODO: move this to home manager config using home.packages
    ./social/default.nix
  ];
}
