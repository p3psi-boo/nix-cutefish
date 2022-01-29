{ stdenv, lib, fetchFromCutefishGitHub, cutefishUpdateScript,
  cmake, extra-cmake-modules, wrapQtAppsHook,
  qtbase, qtx11extras, qttools, kwindowsystem,
  kcoreaddons, kdecoration, kconfig, kwin, epoxy
}:

let
  name = "kwin-plugins";
  version = "0.5";
in

stdenv.mkDerivation {
  inherit version;
  pname = "cutefish-${name}";

  src = fetchFromCutefishGitHub {
    inherit name version;
    sha256 = "1kafaf4dpsqbw9709ccng9hjnavys8zwk01yq3cjgz4q4mwgh8jx";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    qtbase qtx11extras qttools kwindowsystem
    kcoreaddons kdecoration kconfig kwin epoxy
  ];

  patches = [
    ./cmake.patch 
    ./workaround.patch
  ];

  postPatch = ''
    for i in $(find -name CMakeLists.txt)
    do
      substituteInPlace $i \
        --replace /usr/ "" \
        --replace /etc/ etc/
    done

    for i in $(find -name '*.cpp')
    do
      substituteInPlace $i \
        --replace /usr/share /run/current-system/sw/share
    done
  '';

  passthru.updateScript = cutefishUpdateScript { inherit name version; };

  meta = with lib; {
    description = "CutefishOS - Some configuration and plugins of KWin";
    homepage = "https://cutefishos.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
