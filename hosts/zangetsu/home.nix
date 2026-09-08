{...}: {
  imports = [
    ../../modules/common/helix.nix
    ../../modules/common/nushell.nix
    ../../modules/common/starship.nix
    ../../modules/common/tmux.nix
  ];

  home = {
    username = "briheet";
    homeDirectory = "/home/briheet";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
