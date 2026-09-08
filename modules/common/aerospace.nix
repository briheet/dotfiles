{ lib, pkgs, ... }:
let
  workspaces = [
    "1" "2" "3" "4" "5" "6" "7" "8" "9"
  ];
  workspaceBindings = lib.mergeAttrsList (map (key: {
    "alt-${key}" = "workspace ${key}";
    "alt-shift-${key}" = "move-node-to-workspace ${key}";
  }) workspaces);
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings."config-version" = 2;
    settings.persistent-workspaces = workspaces;
    # Custom configs do not inherit AeroSpace's default keyboard bindings.
    settings.mode = {
      main.binding = workspaceBindings // {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";
        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        alt-shift-semicolon = "mode service";
      };
      service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];
        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];
      };
    };
    # Reserve the 36-point SketchyBar plus 6 points of breathing room.
    # The MacBook's notch already reserves the bar's height on its display.
    settings.gaps.outer.top = [
      { monitor."^built-in retina display$" = 6; }
      42
    ];
    settings."exec-on-workspace-change" = [
      "/bin/bash"
      "-c"
      "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
  };
}
