{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.squirmy.fortune.enable {
  home.packages = [
    pkgs.fortune
  ];
}
