{lib, ...}: let
  shellsOptions = {
    zsh.enable = lib.options.mkEnableOption "zsh";
  };

  configurationOptions = {
    nixpkgs.hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "aarch64-darwin";
    };
    nixpkgs.allowUnfree = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable unfree software.";
      type = lib.types.bool;
    };
    trampoline.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable trampoline.";
      type = lib.types.bool;
    };
    username = lib.mkOption {
      type = lib.types.str;
    };
    homeDirectory = lib.mkOption {
      type = lib.types.str;
    };
    shells = lib.mkOption {
      type = lib.types.submodule {options = shellsOptions;};
      default = {};
    };
  };
in {
  options.nix-machine = lib.mkOption {
    type = lib.types.submodule {options = configurationOptions;};
    default = {};
  };
}
