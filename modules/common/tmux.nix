{ pkgs, ... }:
{

  programs.tmux = {

    enable = true;
    clock24 = true;

    keyMode = "vi";
    mouse = true;
    prefix = "C-b";

    secureSocket = true;

    shell = "${pkgs.nushell}/bin/nu";
    terminal = "tmux-256color";

    extraConfig = ''
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none

        # Status bar
        set -g status-position bottom

        #Mouse
        set -g mouse on

        # Plane
        set -g base-index 1
        set -g pane-base-index 1

        # Escape time
        set -sg escape-time 10
      '';

    plugins = [
      pkgs.tmuxPlugins.nord
      pkgs.tmuxPlugins.yank
    ];

  };

}
