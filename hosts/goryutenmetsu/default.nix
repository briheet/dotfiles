# This file contains macos system specific behaviour
{ pkgs, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };

    users.briheet = import ./home.nix;
  };

  # Discord
  nixpkgs.config.allowUnfree = true;

  # Package bundle .app
  environment.systemPackages = with pkgs; [
    discord
    ghostty-bin
    slack
    dbeaver-bin
    raycast
    shottr
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  # System docs
  documentation = {
    enable = true;
    doc.enable = false;
    info.enable = false;
    man.enable = true;
  };

  # Environment
  environment = {
    shells = [ pkgs.nushell ];
  };

  # Networking
  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
      allowSigned = true;
      allowSignedApp = true;
    };
    computerName = "Briheet's MacBook Pro";
    hostName = "goryutenmetsu.local";
    localHostName = "goryutenmetsu";
  };

  system.stateVersion = 6;

  # Enable experimental Nix features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Users
  users.users.briheet = {
    name = "briheet";
    home = "/Users/briheet";
  };

  # Global programs
  programs = {
    direnv.enable = true;
  };

  # Display
  power.sleep = {
    display = 10;
    computer = 30;
    harddisk = "never";
  };

  # Systems
  system = {
    primaryUser = "briheet";

    # Menu and system
    defaults.NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "WhenScrolling";
      _HIHideMenuBar = true;

      # Inverse scrolling
      "com.apple.swipescrolldirection" = false;
    };

    # Dock stuff
    defaults.dock.autohide = true;

    # Keyboard stuff
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    # Trackpad stuff
    defaults.trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };

  # Time
  time.timeZone = "Asia/Calcutta";

}
