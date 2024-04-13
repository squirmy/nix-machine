{lib, ...}: {
  options.aaa = lib.options.mkEnableOption "aaa";
  options.aab = lib.options.mkEnableOption "aab";
  options.bba = lib.options.mkEnableOption "bba";
}
