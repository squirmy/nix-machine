{
  lib,
  config,
  ...
}:
lib.mkIf config.mine.macos.enable {
  security.pam.enableSudoTouchIdAuth = true;
}
