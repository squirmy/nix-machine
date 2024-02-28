{lib, ...}: let
  configurationOptions = {
    fortune.enable = lib.options.mkEnableOption "fortune";
    macos.enable = lib.options.mkEnableOption "macos";
  };
in {
  options.squirmy = lib.mkOption {
    type = lib.types.submodule {options = configurationOptions;};
    default = {};
  };
}
