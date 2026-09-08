{ pkgs, ... }:

let
  # SbarLua currently defaults to Lua 5.5 in unstable. Keep this bar on the
  # mature 5.4 ABI until the upstream 5.5 crash is resolved.
  sbarLua54 = pkgs.sbarlua.override {
    lua55Packages = pkgs.lua54Packages;
  };
in
{
  programs.sketchybar = {
    enable = true;
    configType = "lua";
    config = {
      source = ./sketchybar;
      recursive = true;
    };

    luaPackage = pkgs.lua5_4;
    sbarLuaPackage = sbarLua54;
    extraPackages = [ pkgs.aerospace ];
  };
}
