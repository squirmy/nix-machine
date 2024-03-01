{
  lib,
  config,
  ...
}:
lib.mkIf config.nix-machine.shells.zsh.enable {
  programs.zsh.enable = true;
}
