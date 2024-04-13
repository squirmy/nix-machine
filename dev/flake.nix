{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    namaka.url = "github:nix-community/namaka/v0.2.0";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    call-flake.url = "github:divnix/call-flake";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake.checks = inputs.namaka.lib.load {
        src = ./tests;
        inputs = {
          inherit (inputs.nixpkgs) lib;
          flakeLib = (inputs.call-flake ../.).lib;
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
          motd = "";
        };
      };
    };
}
