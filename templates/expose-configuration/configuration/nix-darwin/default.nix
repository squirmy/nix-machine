{...}: {
  # configuration to apply to nix-darwin
  # https://daiderd.com/nix-darwin/manual/index.html
  imports = [
    ./macos.nix
  ];
}
