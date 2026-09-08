{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = false;
      palette = "nord";
      continuation_prompt = "[∙](nord3) ";

      format = builtins.concatStringsSep "" [
        "[╭─](nord3)"
        "$username"
        "$hostname"
        "[ in ](nord3)"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$git_state"
        "$nix_shell"
        "$line_break"
        "[╰─](nord3)"
        "$character"
      ];
      right_format = "$status$cmd_duration";

      palettes.nord = {
        nord0 = "#2e3440";
        nord1 = "#3b4252";
        nord2 = "#434c5e";
        nord3 = "#4c566a";
        nord4 = "#d8dee9";
        nord5 = "#e5e9f0";
        nord6 = "#eceff4";
        nord7 = "#8fbcbb";
        nord8 = "#88c0d0";
        nord9 = "#81a1c1";
        nord10 = "#5e81ac";
        nord11 = "#bf616a";
        nord12 = "#d08770";
        nord13 = "#ebcb8b";
        nord14 = "#a3be8c";
        nord15 = "#b48ead";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold nord7";
        style_root = "bold nord11";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname]($style)";
        style = "bold nord7";
        trim_at = ".";
      };

      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold nord9";
        read_only = " ";
        read_only_style = "bold nord11";
        truncation_length = 4;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[on](nord3) [$symbol$branch]($style) ";
        symbol = " ";
        style = "bold nord8";
        truncation_length = 32;
        truncation_symbol = "…";
      };

      git_commit = {
        only_detached = true;
        format = "[at](nord3) [$hash$tag]($style) ";
        style = "bold nord10";
        tag_disabled = false;
        tag_symbol = "  ";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold nord13";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "≡";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bold nord12";
      };

      nix_shell = {
        format = "[via](nord3) [$symbol$name]($style) ";
        symbol = " ";
        style = "bold nord15";
      };

      status = {
        disabled = false;
        format = "[$symbol$status]($style) ";
        symbol = "✘ ";
        style = "bold nord11";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[took](nord3) [$duration]($style)";
        style = "bold nord13";
      };

      character = {
        success_symbol = "[❯](bold nord8)";
        error_symbol = "[❯](bold nord11)";
        vimcmd_symbol = "[❮](bold nord8)";
        vimcmd_replace_one_symbol = "[❮](bold nord15)";
        vimcmd_replace_symbol = "[❮](bold nord15)";
        vimcmd_visual_symbol = "[❮](bold nord13)";
      };
    };
  };
}
