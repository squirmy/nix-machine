{
  lib,
  config,
  ...
}:
lib.mkIf config.mine.macos.enable {
  security.pam.services.sudo_local.touchIdAuth = true;
}
