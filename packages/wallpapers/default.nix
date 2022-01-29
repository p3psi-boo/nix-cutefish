{ stdenv, 
  lib, 
  fetchFromCutefishGitHub, 
  cutefishUpdateScript,
  cmake
}:

let
  name = "wallpapers";
  version = "0.4";
in

stdenv.mkDerivation {
  inherit version;
  pname = "cutefish-${name}";

  src = fetchFromCutefishGitHub {
    inherit name version;
    sha256 = "sha256-vYe7uZZRqrxevHq3fO2YhyJLQr2OSafYbwaeA4/f6vQ=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    for i in $(find -name CMakeLists.txt)
    do
      substituteInPlace $i \
        --replace /usr/ "" \
        --replace /etc/ etc/
    done
  '';

  passthru.updateScript = cutefishUpdateScript { inherit name version; };

  meta = with lib; {
    description = "CutefishOS - System Wallpaper";
    homepage = "https://cutefishos.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
