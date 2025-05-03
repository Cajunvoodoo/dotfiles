{
  pkgs,
  lib,
  config,
  ...
}: {
  #for emacs-unstable
  #nixpkgs.overlays = [
  #(import (builtins.fetchTarball {
  #url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #}))
  #];

  programs.emacs = {
    enable = true;
    # package = pkgs.emacs-gtk;
    # package = pkgs.emacs-unstable;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.irony
      epkgs.irony-eldoc
      epkgs.git-commit
    ];
  };

  # Enable Emacs daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    startWithUserSession = "graphical";
    socketActivation.enable = true;
    # defaultEditor = true;
    client = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ec";
      runtimeInputs = [emacs];

      text = ''
        emacsclient -c
      '';
    })
    wordnet
    w3m
    ## Emacs itself
    binutils
    coreutils
    # 28.2 + native-comp
    #((emacsPackagesFor pkgs.emacs-gtk).emacsWithPackages
    #(epkgs: [ epkgs.vterm ]))

    # necessary for vterm
    cmake
    gnumake
    gcc
    libtool

    # emacsPackages.agda-input
    emacsPackages.agda2-mode
    emacsPackages.agda-editor-tactics

    ## Doom dependencies
    (ripgrep.override {withPCRE2 = true;})
    gnutls

    # Performance booster
    emacs-lsp-booster

    ## Treemacs
    python3

    ## Optional dependencies
    imagemagick
    zstd
    sqlite
    # gcc # moved to environment.systemPackages

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [en en-computers en-science]))
    # :tools editorconfig
    editorconfig-core-c
    # :tools lookup & :lang org +roam
    sqlite
    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium
    # :app everywhere
    xclip
    xdotool
    xorg.xwininfo
    xorg.xprop
    # :lang cc
    # clang # moved to environment.systemPackages
    # clang-tools
    # github copilot
    nodejs_22

    ## Fonts
    dejavu_fonts
    source-serif-pro
    fira-code
    fira-code-symbols
    noto-fonts
    font-awesome
    # iosevka
    # iosevka-bin
    iosevka-comfy.comfy-wide
    # iosevka-comfy.comfy-wide-duo
    # iosevka-comfy.comfy-wide-fixed
    # iosevka-comfy.comfy-wide-motion
    # iosevka-comfy.comfy-wide-motion-duo
    # iosevka-comfy.comfy-wide-motion-fixed
    # modeline
    nerd-font-patcher

    # eaf
    wmctrl
    fd
    aria
  ];

  fonts.fontconfig.enable = true;
  # Install doom emacs
  home.activation = {
    installDoomEmacs = lib.hm.dag.entryAfter ["installPhase"] ''
      if [ ! -d "${config.xdg.configHome}/emacs" ]; then
        ${pkgs.git}/bin/git clone --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "${config.xdg.configHome}/emacs"
        GIT_SSH_COMMAND = ${pkgs.openssh}/bin/ssh ${pkgs.git}/bin/git  clone "git@github.com:Cajunvooodoo/Doom-Emacs-Config.git" "${config.xdg.configHome}/doom"

      fi
    '';
  };
}
