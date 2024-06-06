{
  lib,
  pkgs,
  stdenv,
  steam-run,
  xkeyboard_config,
  makeDesktopItem,
  ...
}: let
  rcuPath = /nix/store/8q5pmijs71cxyqr2764nsn5i8hfnnlnw-rcu-d2024.001o-fedora38.tar.gz;
in
  stdenv.mkDerivation rec {
    name = "rcu";
    version = "0.0.1";
    pname = "rcu";

    # src = rcu-tar-path;
    src =
      if builtins.pathExists rcuPath
      then rcuPath
      else
        builtins.error ''
          please download and run `nix store add-file` with rcu-<version>.tar.gz
          and to run this flake with --impure
        '';

    propagatedBuildInputs = [
      steam-run
    ];

    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        desktopName = "rcu";
        icon = pname;
        categories = ["Utility"];
      })
    ];

    buildPhase = ''
      runHook preBuild
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/opt
      cp -r * $out/opt
      mv $out/opt/rcu $out/opt/rcu-raw
      chmod +x $out/opt/rcu-raw

      ### TERRIBLE UGLY HACK
      echo "${steam-run}/bin/steam-run $out/opt/rcu-raw" > $out/bin/rcu
      ls $out/bin
      chmod +x $out/bin/rcu
      ###

      install -Dm644 ${./davisr-rcu.png} $out/share/icons/hicolor/512x512/${pname}.png
      makeWrapper $out/opt/rcu-raw \
        $out/bin/rcu-raw \
        --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb" \
        --prefix LD_LIBRARY_PATH : ${
        lib.strings.makeLibraryPath propagatedBuildInputs
      }
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://files.davisr.me/projects/rcu/";
      description = "Remarkable Connection Utility";
      platforms = platforms.linux;
      license = licenses.unfree;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
    };
  }
