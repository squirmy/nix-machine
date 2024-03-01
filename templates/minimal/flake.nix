{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-machine.url = "github:squirmy/nix-machine";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-darwin"];
      imports = [inputs.nix-machine.flakeModule];

      nix-machine.macos."hostname" = {
        nix-machine = {
          username = "username";
          homeDirectory = "/Users/username";
          nixpkgs.hostPlatform = "aarch64-darwin";
          shells.zsh.enable = true;
        };
      };

      nix-machine.configurations.private = {
        # configuration to apply to nix-darwin
        # https://daiderd.com/nix-darwin/manual/index.html
        nixDarwin = {...}: {
          security.pam.enableSudoTouchIdAuth = true;
        };

        # configuration to apply to home-manager
        # https://mipmip.github.io/home-manager-option-search/
        homeManager = {pkgs, ...}: {
          home.packages = [
            pkgs.fortune
          ];
        };
      };
    };
}
