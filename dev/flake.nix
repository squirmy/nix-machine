{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    namaka.url = "github:nix-community/namaka/v0.2.0";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake.checks = inputs.namaka.lib.load {
        src = ./tests;
        inputs = {
          flakeLib = inputs.haumea.lib.load {
            src = ../lib;
            inputs = {
              inherit (inputs.nixpkgs) lib;
            };
          };
          inherit (inputs.nixpkgs) lib;
        };
      };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        inputs.devshell.flakeModule
      ];

      perSystem = {inputs', ...}: {
        devshells.default = {
          packages = [
            inputs'.namaka.packages.default
          ];
        };
      };
    };
}
