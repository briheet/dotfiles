{ ... }:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    withPython3 = false;
    withRuby = false;

    # Lua setup
    initLua = builtins.readFile ./nvim/init.lua;
  };
}
