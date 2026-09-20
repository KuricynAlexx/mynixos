# home.nix или отдельный модуль plasma.nix
{ config, pkgs, ... }:

{
  # Подключаем plasma-manager как модуль (предполагается, что flake настроен)
  programs.plasma = {
    enable = true;
    
    # Рекомендация из README plasma-manager: делает конфигурацию полностью декларативной.
    # ВНИМАНИЕ: Удалит ручные изменения KDE при входе, заменяя их на этот конфиг.
    overrideConfig = true; 

    # 1. Оформление рабочей среды (Workspace)
    workspace = {
      # На основе тем из репозитория agridyne
      lookAndFeel = "org.pwyde.monochrome"; # Идентификатор темы Monochrome KDE
      colorScheme = "Monochrome";
      cursorTheme = "Bibata-Modern-Ice";
      iconTheme = "Yet-Another-Monochrome-Icon-Set";
      
      # Кастомизация шрифтов
      font = {
        general = {
          family = "Noto Sans";
          pointSize = 10;
        };
      };
    };

    # 2. Оптимизация горячих клавиш (Вместо ручной правки kglobalshortcutsrc)
    shortcuts = {
      kwin = {
        "Window Maximize" = "Meta+Up";
        "Overview" = "Meta+W";
      };
    };

    # 3. Панели "Islands" (Замена Panel Colorizer / стандартных панелей)
    # Автор использует две панели (сверху и снизу). Описываем их структуру:
    panels = [
      # Верхняя панель
      {
        location = "top";
        height = 32;
        alignment = "center";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.systemmonitor" # Слева (как в оригинале)
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"   # Разделитель
          "com.github.catwalkr"          # Виджет CatWalkR (если упакован в nix)
          "org.kde.plasma.controlstation" # Control Station 
        ];
      }
      # Нижняя панель
      {
        location = "bottom";
        height = 40;
        alignment = "center";
        widgets = [
          "org.kde.plasma.icontasks"     # Только иконки запущенных приложений
          "org.kde.plasma.digitalclock"   # Часы снизу слева/справа
        ];
      }
    ];

    # 4. Тонкие настройки компонентов KDE Plasma
    kscreenlocker.appearance.wallpaper = "/home/alexthesnore/Pictures/wallpapers/berserk_guts.png";
  };

  # Системные пакеты пользователя, необходимые для "райса"
  home.packages = with pkgs; [
    bibata-cursors
    # Дополнительные виджеты и плагины KDE можно устанавливать напрямую,
    # если они упакованы в nixpkgs, либо скачивать через home.file
  ];

  # Light / Dark themes
  systemd.user.services.switch-to-dark-theme = {
    Unit.Description = "Switch to KDE Dark theme";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/lookandfeeltool -a org.pwyde.monochrome-dark";
    };
  };

  systemd.user.timers.dark-theme-timer = {
    Unit.Description = "Timer for dark theme";
    Timer = {
      OnCalendar = "22:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.switch-to-light-theme = {
    Unit.Description = "Switch to KDE Dark theme";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/lookandfeeltool -a org.pwyde.monochrome-light";
    };
  };

  systemd.user.timers.light-theme-timer = {
    Unit.Description = "Timer for light theme";
    Timer = {
      OnCalendar = "07:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

