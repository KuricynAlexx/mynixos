{ config, pkgs, ... }: {

  # 1. Allow unfree packages (Required for proprietary NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # 2. CPU: Enable AMD Microcode updates for your Ryzen 7 7800
  hardware.cpu.amd.updateMicrocode = true;

  # 3. Graphics: Enable Hardware Accelerated Video Decoding (OpenGL/Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necessary for 32-bit Steam games
  };

  # 4. GPU: Load the NVIDIA driver kernel module
  services.xserver.videoDrivers = [ "nvidia" ];

  # 5. NVIDIA Specific Fine-Tuning
  hardware.nvidia = {
    # Modesetting is required for modern Wayland compositors (Hyprland, Sway, GNOME, KDE)
    modesetting.enable = true;

    # Nvidia power management (Experimental, keep false unless you have sleep/suspend issues)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (Recommended for RTX 2000 series and newer)
    open = true;

    # Enable the nvidia-settings control panel GUI
    nvidiaSettings = true;

    # Select the appropriate stable driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}

