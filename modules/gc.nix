{ config, lib, pkgs, ... }: {
  # Автоматическая оптимизация хранилища (поиск дубликатов файлов и создание hardlink'ов)
  nix.settings.auto-optimise-store = lib.mkDefault true;

  # Настройки сборщика мусора
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly"; # Запуск раз в неделю (можно "daily", если мало места)
    
    # Флаги для глубокой очистки
    options = lib.mkDefault "--delete-generations +5";
  };

  # Защита от внезапного переполнения диска (Доступно в современных версиях Nix)
  # Если свободного места станет меньше 10 ГБ, Nix автоматически удалит старый мусор,
  # пока свободное место не вернется к отметке в 30 ГБ.
  nix.settings = {
    min-free = lib.mkDefault (10 * 1024 * 1024 * 1024); # 10 GB
    max-free = lib.mkDefault (30 * 1024 * 1024 * 1024); # 30 GB
  };
}

