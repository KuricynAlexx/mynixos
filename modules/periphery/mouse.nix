{ config, pkgs, ... }:

{
  hardware.openrazer = {
    enable = true;
    # Optional: if you want a specific user to have access to device configuration
    users = [ "alexthesnore" ];
  };
}

