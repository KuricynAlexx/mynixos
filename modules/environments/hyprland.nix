{ config, lib, pkgs, ... }: {
  services.xserver.enable = lib.mkDefault false;

  # services.displayManager.sddm.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Запуск tuigreet с автоматическим поиском Wayland и X11 сессий
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --user-menu --sessions ${pkgs.hyprland}/share/wayland-sessions:${pkgs.sway}/share/wayland-sessions";
        user = "alexthesnore";
      };
    };
  };

  # Опционально: отключаем спам системных логов systemd при загрузке, 
  # чтобы они не перекрывали интерфейс tuigreet
  boot.kernelParams = [ "consoleenv=ram" "quiet" ];

  programs.hyprland.enable = true;

  # requirements for hyprland:
  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
  ];
}
