{
  lib,
  flakeLib,
  ...
}: c: let
  inherit (lib.trivial) pipe;

  resolveProvided = c: c;
  resolveFlat = c: flakeLib.config.resolveFlat c.path;
  resolveByName = c: flakeLib.config.resolveByName c.path;

  resolver =
    if c.path != null && c.scheme == "flat"
    then resolveFlat
    else if c.path != null && c.scheme == "by-name"
    then resolveByName
    else resolveProvided;

  # Allow the options to be used in both nix-darwin and home-manager modules.
  applyOptions = c: {
    options = c.options;
    nixos = c.options ++ c.nixos;
    darwin = c.options ++ c.darwin;
    home = c.options ++ c.home;
  };
in
  pipe c [
    resolver
    applyOptions
  ]
