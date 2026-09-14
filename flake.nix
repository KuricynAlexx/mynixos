{
  description = "Моя конфигурация NixOS с Flakes и Home Manager";

  inputs = {
    # Стабильная ветка Nixpkgs (замените на актуальную версию, например, 26.05)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager, который следит за версией nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Подключаем ваши скопированные файлы
          ./hardware-configuration.nix
          ./configuration.nix

          # Подключаем Home Manager как модуль NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Настройки Home Manager для вашего пользователя
            home-manager.users.alexthesnore = import ./home.nix;
          }
        ];
      };
    };
  };
}

