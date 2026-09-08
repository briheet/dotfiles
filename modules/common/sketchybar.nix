{...}: {
  programs.sketchybar = {
    enable = true;
    config = ''
      source "$CONFIG_DIR/colors.sh"

      FONT="Iosevka Nerd Font"
      BAR_PADDING=8
      ITEM_PADDING=5
      ICON_PADDING=4
      LABEL_PADDING=4
      PLUGIN_DIR="$CONFIG_DIR/plugins"

      # A transparent canvas with Nord "floating island" groups.
      sketchybar --bar \
        position=top \
        height=36 \
        color="$BAR_BG" \
        blur_radius=0 \
        padding_left="$BAR_PADDING" \
        padding_right="$BAR_PADDING"

      sketchybar --default \
        padding_left="$ITEM_PADDING" \
        padding_right="$ITEM_PADDING" \
        icon.font="$FONT:Bold:13.0" \
        icon.color="$NORD8" \
        icon.padding_left="$ICON_PADDING" \
        icon.padding_right="$ICON_PADDING" \
        label.font="$FONT:Medium:12.0" \
        label.color="$NORD6" \
        label.padding_left="$LABEL_PADDING" \
        label.padding_right="$LABEL_PADDING" \
        background.height=26 \
        background.corner_radius=8

      # AeroSpace workspaces are shown when AeroSpace is available. The active
      # workspace is updated through its native workspace-change event.
      if command -v aerospace >/dev/null 2>&1; then
        sketchybar --add event aerospace_workspace_change
        SPACE_ITEMS=()
        WORKSPACES=(1 2 3 4 5 6 7 8 9)

        for sid in "''${WORKSPACES[@]}"; do
          item="space.$sid"
          SPACE_ITEMS+=("$item")

          sketchybar --add item "$item" left \
            --subscribe "$item" aerospace_workspace_change \
            --set "$item" \
              width=28 \
              padding_left=2 \
              padding_right=2 \
              icon.drawing=off \
              label="$sid" \
              label.color="$NORD4" \
              label.font="$FONT:Bold:12.0" \
              background.color="$NORD8" \
              background.height=22 \
              background.corner_radius=7 \
              background.drawing=off \
              click_script="aerospace workspace $sid" \
              script="$PLUGIN_DIR/aerospace.sh $sid"
        done

        sketchybar --add bracket workspaces "''${SPACE_ITEMS[@]}" \
          --set workspaces \
            background.color="$SURFACE" \
            background.corner_radius=9 \
            background.height=28 \
            background.border_color="$BORDER" \
            background.border_width=1 \
            background.drawing=on
      fi

      # Current application.
      sketchybar --add item front_app left \
        --set front_app \
          icon="󰀻" \
          icon.color="$NORD8" \
          label.max_chars=28 \
          script="$PLUGIN_DIR/front_app.sh" \
        --subscribe front_app front_app_switched

      sketchybar --add bracket app_group front_app \
        --set app_group \
          background.color="$SURFACE" \
          background.corner_radius=9 \
          background.height=28 \
          background.border_color="$BORDER" \
          background.border_width=1 \
          background.drawing=on

      # Compact, event-driven system widgets.
      sketchybar --add item clock right \
        --set clock \
          icon="󰥔" \
          icon.color="$NORD8" \
          update_freq=10 \
          script="$PLUGIN_DIR/clock.sh"

      sketchybar --add item volume right \
        --set volume \
          icon.color="$NORD7" \
          script="$PLUGIN_DIR/volume.sh" \
        --subscribe volume volume_change

      sketchybar --add item battery right \
        --set battery \
          update_freq=120 \
          script="$PLUGIN_DIR/battery.sh" \
        --subscribe battery system_woke power_source_change

      sketchybar --add item network right \
        --set network \
          icon="󰖩" \
          icon.color="$NORD9" \
          label.max_chars=18 \
          update_freq=60 \
          script="$PLUGIN_DIR/wifi.sh" \
        --subscribe network system_woke wifi_change

      RIGHT_ITEMS=(clock volume battery network)
      sketchybar --add bracket system_group "''${RIGHT_ITEMS[@]}" \
        --set system_group \
          background.color="$SURFACE" \
          background.corner_radius=9 \
          background.height=28 \
          background.border_color="$BORDER" \
          background.border_width=1 \
          background.drawing=on

      sketchybar --update
    '';
  };

  xdg.configFile = {
    "sketchybar/colors.sh".text = ''
      # Nord Polar Night
      export NORD0=0xff2e3440
      export NORD1=0xff3b4252
      export NORD2=0xff434c5e
      export NORD3=0xff4c566a

      # Nord Snow Storm
      export NORD4=0xffd8dee9
      export NORD5=0xffe5e9f0
      export NORD6=0xffeceff4

      # Nord Frost
      export NORD7=0xff8fbcbb
      export NORD8=0xff88c0d0
      export NORD9=0xff81a1c1
      export NORD10=0xff5e81ac

      # Nord Aurora
      export NORD11=0xffbf616a
      export NORD12=0xffd08770
      export NORD13=0xffebcb8b
      export NORD14=0xffa3be8c
      export NORD15=0xffb48ead

      export BAR_BG=0x00000000
      export SURFACE=0xee2e3440
      export BORDER=0xff434c5e
    '';

    "sketchybar/plugins/aerospace.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        source "$CONFIG_DIR/colors.sh"

        focused="''${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

        if [ "$1" = "$focused" ]; then
          sketchybar --animate tanh 12 \
            --set "$NAME" \
              background.color="$NORD8" \
              background.drawing=on \
              label.color="$NORD0"
        else
          sketchybar --animate tanh 12 \
            --set "$NAME" \
              background.drawing=off \
              label.color="$NORD4"
        fi
      '';
    };

    "sketchybar/plugins/battery.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        source "$CONFIG_DIR/colors.sh"

        percentage="$(pmset -g batt | sed -n 's/.*[[:space:]]\([0-9][0-9]*\)%.*/\1/p' | head -n 1)"

        if [ -z "$percentage" ]; then
          sketchybar --set "$NAME" drawing=off
          exit 0
        fi

        if pmset -g batt | grep -q "AC Power"; then
          icon="󰂄"
          color="$NORD14"
        elif [ "$percentage" -le 15 ]; then
          icon="󰁺"
          color="$NORD11"
        elif [ "$percentage" -le 30 ]; then
          icon="󰁼"
          color="$NORD13"
        elif [ "$percentage" -le 60 ]; then
          icon="󰁾"
          color="$NORD7"
        elif [ "$percentage" -le 85 ]; then
          icon="󰂀"
          color="$NORD7"
        else
          icon="󰁹"
          color="$NORD14"
        fi

        sketchybar --set "$NAME" drawing=on icon="$icon" icon.color="$color" label="$percentage%"
      '';
    };

    "sketchybar/plugins/clock.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        sketchybar --set "$NAME" label="$(date '+%a %d %b  %H:%M')"
      '';
    };

    "sketchybar/plugins/front_app.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        if [ "$SENDER" = "front_app_switched" ]; then
          app="$INFO"
        else
          app="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)"
        fi

        sketchybar --set "$NAME" label="''${app:-Desktop}"
      '';
    };

    "sketchybar/plugins/volume.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        if [ "$SENDER" = "volume_change" ]; then
          volume="$INFO"
        else
          volume="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
        fi

        muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

        if [ "$muted" = "true" ] || [ "''${volume:-0}" -eq 0 ]; then
          icon="󰖁"
        elif [ "$volume" -ge 60 ]; then
          icon="󰕾"
        elif [ "$volume" -ge 30 ]; then
          icon="󰖀"
        else
          icon="󰕿"
        fi

        sketchybar --set "$NAME" icon="$icon" label="''${volume:-0}%"
      '';
    };

    "sketchybar/plugins/wifi.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        source "$CONFIG_DIR/colors.sh"

        wifi_name="$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/^Current Wi-Fi Network: //')"

        if [ -z "$wifi_name" ] || echo "$wifi_name" | grep -q "not associated"; then
          if ipconfig getifaddr en0 >/dev/null 2>&1; then
            wifi_name="Wi-Fi"
            color="$NORD9"
          else
            wifi_name="Offline"
            color="$NORD11"
          fi
        else
          color="$NORD9"
        fi

        sketchybar --set "$NAME" icon.color="$color" label="$wifi_name"
      '';
    };
  };
}
