{
  lib,
  flakeLib,
}: let
  config = flakeLib.config.resolve {
    path = ../_fixture/first/flat-config;
    scheme = "flat";
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
