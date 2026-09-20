{ config, lib, pkgs, inputs, ... }: {
  services.xserver.enable = lib.mkDefault true;

  # displayManager:
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Запуск tuigreet с автоматическим поиском Wayland и X11 сессий
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --user-menu --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "alexthesnore";
      };
    };
  };

  # Опционально: отключаем спам системных логов systemd при загрузке, 
  # чтобы они не перекрывали интерфейс tuigreet
  boot.kernelParams = [ "consoleenv=ram" "quiet" ];

  programs.niri = {
    enable = true;
    package = pkgs.niri; # stable version of niri
  };

  # requirements for niri:
  environment.systemPackages = with pkgs; [
    alacritty # default niri terminal
    foot
    fuzzel
    noctalia
    xwayland-satellite
  ];

  programs.xwayland.enable = true;

  # additional noctalia settings:
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # 
  environment.variables = {
    TERMINAL = "foot";
  };
}
