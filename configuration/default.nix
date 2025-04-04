{...}: {
  nix-machine.configurations.nix-machine = {
    options = [./options.nix];
    darwin = [./nixpkgs.nix ./nix-darwin];
    nixos = [./nixpkgs.nix ./nixos];
    home = [./home-manager];
  };
}
