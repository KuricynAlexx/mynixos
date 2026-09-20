# home.nix или отдельный модуль plasma.nix
{ config, pkgs, ... }:

{
# xdg.dataFile = {
#   # 1. Установка CatWalkR (виджет с анимированным котиком)
#   "plasma/plasmoids/com.github.catwalkr" = {
#     source = pkgs.fetchzip {
#       url = "https://github.com/BLADR-ONE/CatWalk-Enhanced-Plasmoid/releases/download/v1.3.0/org.kde.plasma.catwalkenhanced.zip";
#       sha256 = "sha256:ccb65b81de7d3770ba2a83724e942aa9e1cdac1b79bd692dfb3bd638f67759b4";
#     };
#     recursive = true;
#   };

#   # 2. Установка KDE Control Station (панель управления в стиле macOS/iOS)
#   "plasma/plasmoids/org.kde.plasma.controlstation" = {
#     source = pkgs.fetchzip {
#       url = "";
#       sha256 = "";
#     };
#     recursive = true;
#   };
# };

  home.packages = with pkgs; [
    # plasma  
    kdePackages.plasma-nm       # Управление сетью
    kdePackages.plasma-pa       # Управление аудио
    kdePackages.kdeconnect-kde  # Виджеты интеграции с телефоном
    bibata-cursors
  ];

  # Зависимости, необходимые для корректной работы KDE Control Station
  # plasma:
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
      
    };
    # Кастомизация шрифтов
    fonts = {
      general = {
        family = "Noto Sans";
        pointSize = 10;
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
          # standard widgets:
          "org.kde.plasma.kickoff"
          {
            name = "org.kde.plasma.systemmonitor";
	    config = {
              Appearance = {
                # Задаем тип отображения (например, текстовый или график)
                chartType = "org.kde.plasma.graphicsicalies"; 
              };
              Sensors = {
                # Явно указываем, какие датчики опрашивать
                totalCpuUsage = "cpu/all/usage";
                memoryUsage = "mem/physical/used";
              };
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"       # Разделитель
          # third-party widgets:
          # { name = "com.github.catwalkr"; }  # Виджет CatWalkR (если упакован в nix)
          # { name = "org.kde.plasma.controlstation"; } # Control Station 
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

