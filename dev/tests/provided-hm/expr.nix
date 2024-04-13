{
  lib,
  flakeLib,
}: let
  config = flakeLib.merge-config.default {
    squirmy = {
      options = ../_fixture/provided-config/options.nix;
      nixDarwin = ../_fixture/provided-config/nix-darwin.nix;
      homeManager = ../_fixture/provided-config/home-manager.nix;
      path = null;
    };
  };

  testOptions = {lib, ...}: {
    options.names = lib.mkOption {
      type = lib.types.lines;
    };
  };

  eval = lib.evalModules {
    modules = [testOptions] ++ config.homeManager;
  };
in {
  inherit (eval) options config;
}
