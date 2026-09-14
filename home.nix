{ config, pkgs, ... }: {
  imports =
    [
    # ./modules/environments/kde-plasma.nix
    ./modules/periphery/desktop.nix
    ];

  # Информация о пользователе и его домашней директории
  home.username = "alexthesnore";
  home.homeDirectory = "/home/alexthesnore";

  # 1. Простые пользовательские приложения (без сложной настройки конфигурации)
  home.packages = with pkgs; [
    home-manager
    telegram-desktop
    # discord
    # vlc
    zed-editor
  ];

  # 2. Сложные программы, которые мы хотим не просто установить, а сразу настроить
  programs.firefox = {
    enable = true;
    # Здесь можно сразу включить расширения или настроить стартовую страницу
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "AlexTheSnore";
      user.email = "KuricynAlexx@gmail.com";

      # Насильно заставляем Git использовать правильный SSH-клиент OpenSSH
      core.sshCommand = "ssh -i ~/.ssh/id_nixos";

      # Автоматически подставлять текущую ветку при git push (удобно)
      push.autoSetupRemote = true;

      # Безопасный дефолтный метод слияния веток
      pull.rebase = false;

      # Необязательно: Если вы хотите автоматически подписывать свои коммиты этим SSH-ключом
      gpg = {
        format = "ssh";
      };
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_nixos.pub";
    };
  };

  # Обязательный параметр Home Manager (версия, на которой вы создали конфиг)
  home.stateVersion = "24.11"; 
}

