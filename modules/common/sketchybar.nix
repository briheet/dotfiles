{ config, pkgs, ... }:

let
  lua = pkgs.lua5_5;
  # Upstream's makefile embeds its bundled Lua, ignoring Nix's Lua flags.
  # Link against the interpreter's runtime so both share the same Lua ABI.
  sbarLua = pkgs.sbarlua.overrideAttrs {
    buildPhase = ''
      runHook preBuild
      mkdir -p bin
      $CC -std=c99 -O3 -shared -fPIC src/*.c \
        -I${lua}/include -L${lua}/lib -llua \
        -framework CoreFoundation -o bin/sketchybar.so
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      install -Dm755 bin/sketchybar.so "$out/lib/lua/${lua.luaversion}/sketchybar.so"
      runHook postInstall
    '';
  };
in
{
  xdg.configFile."sketchybar/features.lua".text = ''
    return { aerospace = ${if config.programs.aerospace.enable then "true" else "false"} }
  '';

  programs.sketchybar = {
    enable = true;
    configType = "lua";
    config = {
      source = ./sketchybar;
      recursive = true;
    };

    luaPackage = lua;
    sbarLuaPackage = sbarLua;
    extraPackages = [ pkgs.aerospace ];
  };
}
