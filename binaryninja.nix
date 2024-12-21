{
  pkgs,
  lib ? pkgs.lib,
  buildFHSEnv ? pkgs.buildFHSEnv,
  writeScript ? pkgs.writeScript,
  stdenv,
}: let
  binaryNinja = with pkgs;
    stdenv.mkDerivation rec {
      version = "4.1.5129";
      pname = "binary-ninja";
      # src = /nix/store/a0hgfba2ppclbvshv1rwgjraikspa17q-binary-linux-personal.zip;

      src = /nix/store/zkcalrkagpxrrrf6bf40k0dp3ad21vc0-binaryninja_personal_linux.zip;

      # desktopItems = [
      #   (makeDesktopItem {
      #     name = pname;
      #     desktopName = "binaryninja";
      #     exec = "binaryninja";
      #     icon = pname;
      #     categories = ["Utility"];
      #   })
      # ];

      nativeBuildInputs = with pkgs.xorg; [
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

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mkdir -p $out/opt
        cp -r * $out/opt
        chmod +x $out/opt/binaryninja
        install -Dm644 ./docs/img/logo.png $out/share/icons/hicolor/512x512/apps/${pname}.png
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
    };
in
  buildFHSEnv {
    name = "binaryninja";
    targetPkgs = pkgs:
      with pkgs; [
        dbus
        fontconfig
        freetype
        libGL
        libxml2
        libxkbcommon
        # python311
        (python311.withPackages (ps:
          with ps; [
            pypresence
            z3-solver
            frida-python
            frida-tools
            angr
          ]))
        # frida-tools
        z3

        xorg.libX11
        xorg.libxcb
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
        wayland
        zlib
        gdb
      ];
    runScript = writeScript "binaryninja.sh" ''
      set -e
      exec "${binaryNinja}/bin/binaryninja"
      # exec "/opt/binaryninja/binaryninja"
    '';
    meta = {
      description = "BinaryNinja";
      platforms = ["x86_64-linux"];
    };
  }
