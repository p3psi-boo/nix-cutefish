{ stdenv, lib, fetchFromCutefishGitHub, cutefishUpdateScript,
  cmake, extra-cmake-modules, wrapQtAppsHook,
  qtbase, qtquickcontrols2, qtx11extras, qttools, kwindowsystem, qtgraphicaleffects,
  kglobalaccel, polkit, polkit-qt, pulseaudio,
  xorg, pcre,
  fishui
}:

let
  name = "core";
  version = "0.4";
in

stdenv.mkDerivation {
  inherit version;
  pname = "cutefish-${name}";

  src = fetchFromCutefishGitHub {
    inherit name version;
    sha256 = "sha256-sXOznqS2TO6Z4rlkQz2cBe+2JuuCL5upK5T1kY8/DI4=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    qtbase qtquickcontrols2 qtx11extras qttools kwindowsystem qtgraphicaleffects
    kglobalaccel polkit polkit-qt pulseaudio
    xorg.libSM xorg.libXdmcp xorg.libXtst xorg.libXcursor xorg.xf86inputlibinput pcre
    fishui
  ];

  cmakeFlags = [
    "-DXORGLIBINPUT_INCLUDE_DIRS=${lib.getDev xorg.xf86inputlibinput}/include/xorg"
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

  passthru = {
    providedSessions = [ "cutefish-xsession" ];
    updateScript = cutefishUpdateScript { inherit name version; };
  };

  meta = with lib; {
    description = "CutefishOS - System components and backend";
    homepage = "https://cutefishos.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
