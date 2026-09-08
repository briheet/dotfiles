{config, ...}: {
  programs.nushell = {
    enable = true;
    extraEnv = ''
      $env.PATH = (
        $env.PATH
        | prepend "${config.home.homeDirectory}/.local/bin"
        | prepend "/etc/profiles/per-user/${config.home.username}/bin"
        | prepend "/run/current-system/sw/bin"
        | append "/usr/local/bin"
      )
    '';

    extraConfig = ''
      let nord0 = "#2e3440"
      let nord2 = "#434c5e"
      let nord3 = "#4c566a"
      let nord4 = "#d8dee9"
      let nord6 = "#eceff4"
      let nord7 = "#8fbcbb"
      let nord8 = "#88c0d0"
      let nord9 = "#81a1c1"
      let nord10 = "#5e81ac"
      let nord11 = "#bf616a"
      let nord12 = "#d08770"
      let nord13 = "#ebcb8b"
      let nord14 = "#a3be8c"
      let nord15 = "#b48ead"

      $env.config.color_config = {
        foreground: $nord6
        background: $nord0
        cursor: $nord4

        shape_string: $nord14
        shape_string_interpolation: { fg: $nord14 attr: b }
        shape_raw_string: $nord14
        shape_record: $nord6
        shape_list: $nord6
        shape_table: $nord6
        shape_bool: { fg: $nord7 attr: b }
        shape_int: { fg: $nord15 attr: b }
        shape_float: { fg: $nord15 attr: b }
        shape_range: { fg: $nord15 attr: b }
        shape_binary: { fg: $nord15 attr: b }
        shape_datetime: $nord12
        shape_custom: $nord7
        shape_nothing: { fg: $nord7 attr: b }
        shape_literal: $nord6
        shape_operator: $nord9
        shape_filepath: $nord7
        shape_directory: $nord7
        shape_globpattern: { fg: $nord13 attr: b }
        shape_glob_interpolation: { fg: $nord13 attr: b }
        shape_garbage: { fg: $nord6 bg: $nord11 attr: b }
        shape_variable: $nord4
        shape_vardecl: { fg: $nord8 attr: b }
        shape_matching_brackets: { fg: $nord8 attr: bu }
        shape_pipe: { fg: $nord9 attr: b }
        shape_internalcall: { fg: $nord8 attr: b }
        shape_external: $nord8
        shape_external_resolved: { fg: $nord8 attr: b }
        shape_externalarg: $nord4
        shape_match_pattern: $nord14
        shape_block: $nord6
        shape_signature: { fg: $nord8 attr: b }
        shape_keyword: { fg: $nord9 attr: b }
        shape_closure: { fg: $nord8 attr: b }
        shape_redirection: { fg: $nord9 attr: b }
        shape_flag: { fg: $nord9 attr: b }

        bool: $nord7
        int: $nord15
        string: $nord14
        float: $nord15
        glob: $nord13
        closure: $nord8
        binary: $nord4
        binary_null_char: $nord3
        binary_printable: $nord14
        binary_whitespace: $nord7
        binary_ascii_other: $nord9
        binary_non_ascii: $nord13
        custom: $nord7
        nothing: $nord3
        datetime: $nord12
        filesize: $nord7
        list: $nord6
        record: $nord6
        duration: $nord15
        range: $nord15
        semver: $nord7
        semver-range: $nord7
        cell-path: $nord4
        block: $nord8

        hints: { fg: $nord3 attr: i }
        search_result: { fg: $nord6 bg: $nord2 attr: b }
        header: { fg: $nord8 attr: b }
        separator: $nord3
        row_index: { fg: $nord9 attr: b }
        empty: $nord10
        leading_trailing_space_bg: { attr: n }
        banner_foreground: $nord6
        banner_highlight1: $nord8
        banner_highlight2: $nord15
      }

      $env.LS_COLORS = (
        [
          "di=1;38;2;129;161;193"
          "ln=1;38;2;136;192;208"
          "so=38;2;180;142;173"
          "pi=38;2;143;188;187"
          "ex=1;38;2;163;190;140"
          "bd=38;2;235;203;139"
          "cd=38;2;235;203;139"
          "or=1;38;2;191;97;106"
          "mi=1;38;2;191;97;106"
          "*.tar=38;2;208;135;112"
          "*.tgz=38;2;208;135;112"
          "*.zip=38;2;208;135;112"
          "*.gz=38;2;208;135;112"
          "*.bz2=38;2;208;135;112"
          "*.xz=38;2;208;135;112"
          "*.7z=38;2;208;135;112"
          "*.jpg=38;2;180;142;173"
          "*.jpeg=38;2;180;142;173"
          "*.png=38;2;180;142;173"
          "*.gif=38;2;180;142;173"
          "*.svg=38;2;180;142;173"
          "*.mp3=38;2;163;190;140"
          "*.flac=38;2;163;190;140"
          "*.wav=38;2;163;190;140"
        ]
        | str join ":"
      )

      $env.config = ($env.config | upsert hooks.env_change.PWD (
        ($env.config.hooks.env_change.PWD? | default [])
        | append {||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
          }
      ))

      $env.config.show_banner = false

      alias lz = lazygit
    '';
  };
}
