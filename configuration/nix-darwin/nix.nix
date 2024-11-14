{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # nix-darwin switches from the initially installed nix version to
  # a version that it places it in the store. This uses the latest
  # version from unstable.
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # Use the already fetched nixpkgs when referring to nixpkgs outside of a flake
  nix.nixPath = lib.mkDefault ["nixpkgs=${inputs.nixpkgs}"];

  nix.settings = {
    # The following settings are taken from https://github.com/DeterminateSystems/nix-installer
    build-users-group = lib.mkDefault "nixbld";
    experimental-features = lib.mkDefault "nix-command flakes";
    always-allow-substitutes = lib.mkDefault true;
    bash-prompt-prefix = lib.mkDefault "(nix:$name)\040";
    max-jobs = lib.mkDefault "auto";
    extra-nix-path = lib.mkDefault "nixpkgs=flake:nixpkgs";

    # Additional settings
    flake-registry = lib.mkDefault (builtins.toFile "global-registry.json" ''{"flakes":[],"version":2}'');

    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = lib.mkDefault false;

    trusted-substituters = ["https://nix-community.cachix.org"];
    trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  nix.extraOptions = ''
    accept-flake-config = true
  '';

  # set up a launchd service to optimize the store
  nix.optimise.automatic = true;

  # Enable nix-daemon to support multi-user mode nix.
  # This is the recommended nix installation option.
  services.nix-daemon.enable = lib.mkDefault true;
}
