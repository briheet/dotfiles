{ inputs, config, pkgs, ... }:
{
  imports = [ inputs.cats.homeManagerModules.default ];

  programs.cats = {
    enable = true;
    service.enable = true;
    desktop = {
      enable = true;
      position = "top-right";
      margin = 24;
      large.enable = true;
      medium.enable = true;
      small.enable = true;
      small.variants = [ "spend" ];
      medium.variants = [ "providers" ];
      font = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        family = "JetBrainsMono Nerd Font";
        size = 12;
      };
    };
    settings = {
      theme = "nord";
      budget-usd = 20;
      data-dir = "${config.home.homeDirectory}/Library/Application Support/Cats";
    };
  };
}
