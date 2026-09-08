{ ... }: {
  imports = [
    ../../modules/common/nushell.nix
    ../../modules/common/tmux.nix
    ../../modules/common/yazi.nix
    ../../modules/common/tools.nix
    ../../modules/common/helix.nix
    ../../modules/common/aerospace.nix
    ../../modules/common/wallpaper.nix
    ../../modules/common/sketchybar.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/zellij.nix
  ];

  home.username = "briheet";
  home.homeDirectory = "/Users/briheet";
  home.stateVersion = "25.05";
}
