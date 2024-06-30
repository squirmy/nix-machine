{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  # nix-darwin switches from the initially installed nix version to
  # a version that it places it in the store. This uses the latest
  # version from unstable.
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # Use the already fetched nixpkgs when referring to nixpkgs outside of a flake
  nix.nixPath = lib.mkDefault ["nixpkgs=${inputs.nixpkgs}"];
  nix.registry.nixpkgs.flake = lib.mkDefault inputs.nixpkgs;

  nix.settings = {
    # The following settings are taken from https://github.com/DeterminateSystems/nix-installer
    build-users-group = lib.mkDefault "nixbld";
    experimental-features = lib.mkDefault "nix-command flakes";
    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = lib.mkDefault false;
    always-allow-substitutes = lib.mkDefault true;
    bash-prompt-prefix = lib.mkDefault "(nix:$name)\040";
    max-jobs = lib.mkDefault "auto";
    extra-nix-path = lib.mkDefault "nixpkgs=flake:nixpkgs";

    # Additional settings
    flake-registry = builtins.toFile "global-registry.json" ''{"flakes":[],"version":2}'';
    trusted-users = ["root" config.nix-machine.username];
  };

  # Enable nix-daemon to support multi-user mode nix.
  # This is the recommended nix installation option.
  services.nix-daemon.enable = lib.mkDefault true;
}
