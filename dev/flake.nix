{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    namaka.url = "github:nix-community/namaka/v0.2.0";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    call-flake.url = "github:divnix/call-flake";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
      ];

      perSystem = {
        inputs',
        config,
        pkgs,
        ...
      }: {
        treefmt.config = {
          projectRoot = ./..;
          projectRootFile = "readme.md";
          package = pkgs.treefmt;
          flakeCheck = false;

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            shfmt.enable = true;
            prettier.enable = true;
            taplo.enable = true;
          };
        };

        pre-commit = {
          check.enable = false;
          settings.hooks = {
            treefmt.enable = true;
            shellcheck.enable = true;
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              language = "system";
              pass_filenames = false;
            };
          };
        };

        formatter = config.treefmt.build.wrapper;

        # todo; work out a way to not pollute the env with unnecessary variables
        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.treefmt.build.devShell
          ];
          packages = with pkgs; [
            inputs'.namaka.packages.default
            just
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
