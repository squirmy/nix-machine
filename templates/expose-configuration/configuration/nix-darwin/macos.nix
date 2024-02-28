{
  lib,
  config,
  ...
}:
lib.mkIf config.squirmy.macos.enable {
  security.pam.enableSudoTouchIdAuth = true;
}
