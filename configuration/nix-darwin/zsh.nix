{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.nix-machine.shells.zsh.enable {
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
}
