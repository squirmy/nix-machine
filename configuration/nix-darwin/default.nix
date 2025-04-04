{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./nix.nix ./zsh.nix];

  # Set the user's name & home directory. This should be
  # in sync with home manager.
  users.users.${config.nix-machine.username} = {
    name = config.nix-machine.username;
    home = config.nix-machine.homeDirectory;
  };

  # Always include bash in /etc/shells if nix-machine is being used to enable shells
  environment.shells = lib.mkIf config.nix-machine.shells.zsh.enable [pkgs.bashInteractive];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
