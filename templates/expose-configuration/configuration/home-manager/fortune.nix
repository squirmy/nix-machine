{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.mine.fortune.enable {
  home.packages = [
    pkgs.fortune
  ];
}
