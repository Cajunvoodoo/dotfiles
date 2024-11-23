{
  autoPatchelfHook,
  copyDesktopItems,
  dbus,
  fontconfig,
  glib,
  libGL,
  makeDesktopItem,
  makeWrapper,
  python3,
  qt6,
  stdenv,
  unzip,
  wayland,
  xkeyboard_config,
  xorg,
  lib,
  libXcursor,
  # , binary-ninja-path
}: let
  binaryNinjaPath = /nix/store/g9d1awjlz6kvm6y7rdfhzbn0jdix2fbs-binaryninja_personal_dev_linux.zip; # /nix/store/c900w7fnh6qrg53h7c1qyxlqyggp5w9i-binaryninja_personal_dev_linux.zip;
in
  stdenv.mkDerivation rec {
    version = "4.1.5129";
    pname = "binary-ninja";

    src =
      # binary-ninja-path;
      if builtins.pathExists binaryNinjaPath
      then binaryNinjaPath
      else builtins.error "please download and run `nix store add-file` with BinaryNinja-personal.zip
            and to run this flake with --impure";

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
      dbus
      fontconfig
      glib
      libGL
      makeWrapper
      qt6.full
      qt6.qtbase
      qt6.wrapQtAppsHook
      stdenv.cc.cc.lib
      unzip
      wayland
      xorg.libXi
      libXcursor
      xorg.libXrender
    ];

    propagatedBuildInputs = [
      (python3.withPackages (pypkgs:
        with pypkgs; [
          z3-solver
        ]))
    ];

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        desktopName = "binaryninja";
        exec = "binaryninja";
        icon = pname;
        categories = ["Utility"];
      })
    ];

    buildPhase = ''
      runHook preBuild
      runHook postBuild
    '';

    # dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/opt
      cp -r * $out/opt
      chmod +x $out/opt/binaryninja
      install -Dm644 ${./icon.png} $out/share/icons/hicolor/512x512/apps/${pname}.png
      makeWrapper $out/opt/binaryninja \
        $out/bin/binaryninja \
        --prefix "QT_QPA_PLATFORM_PLUGIN_PATH" ":" "$out/opt/" \
        --set LD_LIBRARY_PATH $out/opt:$NIX_LD_LIBRARY_PATH
        # --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"\
        # --prefix "QT_DEBUG_PLUGINS" ":" "1" \
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "binary.ninja";
      description = "Reverse Engineering in Style";
      platforms = platforms.linux;
      license = licenses.unfree;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
    };
  }
