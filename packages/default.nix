{ pkgs, makeScope, libsForQt5 }:

makeScope libsForQt5.newScope (self: with self; {
  cutefishUpdateScript = { name, version }: pkgs.genericUpdater {
    inherit version;
    pname = "cutefish-${name}";
    attrPath = "cutefish.${name}";
    versionLister = "${pkgs.common-updater-scripts}/bin/list-git-tags https://github.com/cutefishos/${name}";
  };

  fetchFromCutefishGitHub = { name, version, sha256 }: pkgs.fetchFromGitHub {
    inherit sha256;
    owner = "cutefishos";
    repo = name;
    rev = version;
  };

  calculator = callPackage ./calculator { };
  core = callPackage ./core { };
  dock = callPackage ./dock { };
  filemanager = callPackage ./filemanager { };
  icons = callPackage ./icons { };
  kwin-plugins = callPackage ./kwin-plugins { };
  launcher = callPackage ./launcher { };
  qt-plugins = callPackage ./qt-plugins { };
  screenlocker = callPackage ./screenlocker { };
  sddm-theme = callPackage ./sddm-theme { };
  settings = callPackage ./settings { };
  statusbar = callPackage ./statusbar { };
  terminal = callPackage ./terminal { };
  wallpapers = callPackage ./wallpapers { };
  libcutefish = callPackage ./libcutefish { };
  fishui = callPackage ./fishui { };
})
