{
  lib,
  flakeLib,
}: let
  config = flakeLib.config.merge {
    first = {
      options = [../_fixture/first/provided-config/options.nix];
      darwin = [../_fixture/first/provided-config/nix-darwin.nix];
      home = [../_fixture/first/provided-config/home-manager.nix];
      path = null;
    };
    second = {
      path = ../_fixture/second/flat-config;
      scheme = "flat";
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
