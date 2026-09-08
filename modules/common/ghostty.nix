{ pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      command = "${pkgs.nushell}/bin/nu";

      font-family = "Iosevka Nerd Font";
      font-size = 13;
      # macos-titlebar-style = "hidden";
      cursor-style-blink = false;

      # clipboard stuff
      confirm-close-surface = false;
      copy-on-select = "clipboard";
      clipboard-read = "allow";
      clipboard-write = "allow";

      # Theme stuff
      theme = "Nord";

      # Previous custom theme:
      /*
      background = "#0D0B0D";
      foreground = "#E7E1E6";
      cursor-color = "#F5A9D0";
      cursor-text = "#0D0B0D";
      selection-background = "#493947";
      selection-foreground = "#F2EDF3";
      palette = [
        "0=#171417"
        "1=#D86A91"
        "2=#91B59B"
        "3=#D0A765"
        "4=#A991C7"
        "5=#D98BB8"
        "6=#91AEB5"
        "7=#D8D1D6"

        "8=#625462"
        "9=#FF7FAE"
        "10=#A8C9AF"
        "11=#E0BC79"
        "12=#BBA6E8"
        "13=#F5A9D0"
        "14=#A9C8CE"
        "15=#F2EDF3"
      ];
      */
    };
  };
}
