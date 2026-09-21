{ config, lib, pkgs, ... }: {
  # imports =
  #  [ # Include the results of the hardware scan.
  #  ];

  # Default for system:
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # for home-management and flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:win_space_toggle"; # Переключение по Alt + Shift
  };

  # --- PROGRAMS --- #
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    amnezia-vpn
    mangohud  # for showing fps
  ];

  programs.firefox.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.amnezia-vpn = {
    enable = true;
  };

  programs.throne = {
    enable = true;
    tunMode.enable = true; # Enables necessary root wrappers/capabilities for TUN mode
  };

  # system fonts:
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # GPU SETTINGS:
  # 1. Enable hardware acceleration (graphics) for 32-bit apps (Steam games)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # 2. Enable the Steam program module
  services.xserver.enable = true;  # neccessary for steam
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    
    # Open ports in the firewall for Steam Remote Play (Local Streaming)
    remotePlay.openFirewall = true; 
    
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = false; 
    
    # Optimize game performance (Enables 'gamemode' integration if you use it)
    extest.enable = true; 
  };

  # --- GENERAL ENV VARIABLES --- #
  #environment.variables = {
  #};

  # --- LIST SERVICES THAT YOU WANT TO ENABLE --- #

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Networking:
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
