{ lib, pkgs, ... }:

let
  delta = "${lib.getExe pkgs.delta} --dark --paging=never --syntax-theme=Nord";
in
{
  programs.lazygit = {
    enable = true;

    settings = {
      # Nix installs Helix as hx; do not inherit the shell's EDITOR (nano).
      os.editPreset = "helix (hx)";

      gui = {
        # Give the diff more room while retaining the standard panels and keys.
        sidePanelWidth = 0.25;
        expandFocusedSidePanel = true;
        expandedSidePanelWeight = 2;
        showCommandLog = false;
        showRandomTip = false;
        showFileTree = true;
        showNumstatInFilesView = true;
        nerdFontsVersion = "3";
        border = "rounded";
        scrollOffMargin = 5;
        wrapLinesInStagingView = true;

        theme = {
          activeBorderColor = [
            "#88c0d0"
            "bold"
          ];
          inactiveBorderColor = [ "#4c566a" ];
          searchingActiveBorderColor = [
            "#ebcb8b"
            "bold"
          ];
          optionsTextColor = [ "#81a1c1" ];
          selectedLineBgColor = [ "#3b4252" ];
          inactiveViewSelectedLineBgColor = [ "#3b4252" ];
          defaultFgColor = [ "#d8dee9" ];
          unstagedChangesColor = [ "#bf616a" ];
          cherryPickedCommitFgColor = [ "#8fbcbb" ];
          cherryPickedCommitBgColor = [ "#434c5e" ];
          markedBaseCommitFgColor = [ "#ebcb8b" ];
          markedBaseCommitBgColor = [ "#434c5e" ];
        };
      };

      git = {
        # Read changed files continuously, with unchanged code around each edit.
        # Lazygit applies this context size to all diff views, including unstaged.
        diffContextSize = 999999;
        # Cycle with Lazygit's existing renderer binding (|).
        diffRenderers = [
          {
            name = "Nord unified";
            colorArg = "always";
            command = "${delta} --line-numbers";
          }
          {
            name = "Nord side-by-side";
            colorArg = "always";
            command = "${delta} --side-by-side --line-numbers";
          }
          {
            name = "Plain Git";
            type = "rawGit";
          }
        ];
      };
    };
  };
}
