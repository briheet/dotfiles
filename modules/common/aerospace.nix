{pkgs, ...}: {
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings."exec-on-workspace-change" = [
      "/bin/bash"
      "-c"
      "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
  };
}
