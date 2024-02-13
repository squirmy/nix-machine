{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && config.nix-machine.trampoline.enable) {
  # Install MacOS applications to the user Applications folder. Also update Docked applications
  # Why: Applications installed by home-manager don't show up in spotlight. This
  # module works around the issue. Can be removed if this is included in home-manager.
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  # Credit: https://github.com/pperanich & https://github.com/hraban
  home.extraActivationPath = with pkgs; [
    rsync
    dockutil
    gawk
  ];

  home.activation.trampolineApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${builtins.readFile ./trampoline-apps.sh}
    fromDir="$HOME/Applications/Home Manager Apps"
    toDir="$HOME/Applications/Home Manager Trampolines"
    sync_trampolines "$fromDir" "$toDir"
  '';
}
