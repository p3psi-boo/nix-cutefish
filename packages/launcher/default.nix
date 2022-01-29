{ stdenv, lib, fetchFromCutefishGitHub, cutefishUpdateScript,
  cmake, extra-cmake-modules, wrapQtAppsHook,
  qtbase, qtquickcontrols2, qttools, kwindowsystem, qtgraphicaleffects,
  libcutefish, fishui
}:

let
  name = "launcher";
  version = "0.4";
in

stdenv.mkDerivation {
  inherit version;
  pname = "cutefish-${name}";

  src = fetchFromCutefishGitHub {
    inherit name version;
    sha256 = "sha256-h1MeRQkbCNYzU3TV8Rl79iZx0J1N68YONspfKKmtyfI=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    qtbase qtquickcontrols2 qttools kwindowsystem qtgraphicaleffects
    libcutefish fishui
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
    description = "CutefishOS - Application launcher";
    homepage = "https://cutefishos.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
