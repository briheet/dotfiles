{ pkgs, ... }:
{

  home.packages = with pkgs; [
    (nerd-fonts.victor-mono)
    # For now just add for zed
    awscli2
    shottr
    glow
    railway
    devenv
    graphviz
    pkg-config
    hwloc
    ffmpeg
    delta
    protobuf
    delve
    bun
    cargo-flamegraph
    lld
    lldb
    gh
    vim
    git
    nodejs
    docker
    docker-compose
    lazygit
    ripgrep
    ranger
    tree
    btop
    subversion
    clippy
    # obsidian
    pnpm
    hyperfine
    direnv
    uv
  ];

}
