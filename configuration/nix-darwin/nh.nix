{...}: {
  environment.shellAliases.nh = "nh-darwin";

  programs.nh = {
    enable = true;
    clean.enable = true;
  };
}
