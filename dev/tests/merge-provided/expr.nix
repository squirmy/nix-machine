{
  lib,
  flakeLib,
}: let
  config = flakeLib.config.merge {
    squirmy = {
      options = [../_fixture/provided-config/options.nix];
      darwin = [../_fixture/provided-config/nix-darwin.nix];
      home = [../_fixture/provided-config/home-manager.nix];
      path = null;
    };
  };

  testOptions = {lib, ...}: {
    options.names = lib.mkOption {
      type = lib.types.lines;
    };
  };

  evalDarwin = lib.evalModules {
    modules = [testOptions] ++ config.darwin;
  };
  evalHome = lib.evalModules {
    modules = [testOptions] ++ config.home;
  };
in {
  darwin = {
    inherit (evalDarwin) options config;
  };
  home = {
    inherit (evalHome) options config;
  };
}
