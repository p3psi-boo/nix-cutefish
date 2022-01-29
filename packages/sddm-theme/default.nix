{ stdenv, lib, fetchFromCutefishGitHub, cutefishUpdateScript,
  cmake, extra-cmake-modules, wrapQtAppsHook,
  qtbase, qtquickcontrols2, qtgraphicaleffects,
  libcutefish, fishui
}:

let
  name = "sddm-theme";
  version = "1";
in

stdenv.mkDerivation {
  inherit version;
  pname = "cutefish-${name}";

  src = fetchFromCutefishGitHub {
    inherit name;
    version = "d3722b62c5b87b8bb88a7e2d75dbdefaadc7d1a2";
    sha256 = "0mwah806qy7548gpyiwpyyfgslgpg9qbamqfx1bf3q5y3918j81j";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    qtbase 
    qtquickcontrols2 
    qtgraphicaleffects
    libcutefish 
    fishui
  ];
  propagatedUserEnvPkgs = [ libcutefish fishui qtgraphicaleffects ];

  postPatch = ''
    for i in $(find -name CMakeLists.txt)
    do
      substituteInPlace $i \
        --replace /usr/ "" \
        --replace /etc/ etc/
    done

    for i in $(find -name '*.qml')
    do
      substituteInPlace $i \
        --replace /usr/share /run/current-system/sw/share
    done
  '';

  #passthru.updateScript = cutefishUpdateScript { inherit name version; };

  meta = with lib; {
    description = "CutefishOS - File manager";
    homepage = "https://cutefishos.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
