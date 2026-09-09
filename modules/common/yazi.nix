{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;

    enableNushellIntegration = true;
    shellWrapperName = "y";

    extraPackages = [ pkgs.glow ];

    flavors.nord = pkgs.yaziPlugins.nord;
    theme.flavor = {
      dark = "nord";
      light = "nord";
    };

    plugins = {
      piper = pkgs.yaziPlugins.piper;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
    };

    keymap.mgr.prepend_keymap = [
      {
        on = "T";
        run = "plugin toggle-pane max-preview";
        desc = "Maximize or restore preview";
      }
    ];

    settings = {
      # Parent directory, file list, preview: give previews half the window.
      mgr.ratio = [ 1 3 4 ];
      preview = {
        wrap = "yes";
        tab_size = 2;
      };

      # Keep the built-in code/media previewers; render Markdown with Glow.
      plugin.prepend_previewers = [
        {
          url = "*.md";
          run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
        }
      ];

      opener.edit = [
        {
          run = "hx %s";
          desc = "Helix";
          block = true;
          for = "unix";
        }
      ];
    };
  };
}
