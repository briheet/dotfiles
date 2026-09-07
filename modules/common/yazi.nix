{ ... }:
{
  programs.yazi = {
    enable = true;

    enableNushellIntegration = true;
    shellWrapperName = "y";

    settings.opener.edit = [
      {
        run = "hx %s";
        desc = "Helix";
        block = true;
        for = "unix";
      }
    ];
  };
}
