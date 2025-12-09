# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./programs
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "army";
    homeDirectory = "/home/army";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    brave
    discord
    devenv
    nerd-fonts.jetbrains-mono
    libreoffice-fresh
    mission-center
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = /home/army/Documents/nix-config;
  };

  programs.fish.enable = true;

  programs.nix-your-shell = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs = {
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    nix-index-database.comma.enable = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    colors = "always";
    git = true;
    icons = "always";

    extraOptions = [
      "-lah"
      "--group-directories-first"
      "--colour-scale"
    ];
  };

  xdg.configFile."eza/theme.yml".source =
    let
      repo = pkgs.fetchFromGitHub {
        owner = "eza-community";
        repo = "eza-themes";
        rev = "17095bff4792eecd7f4f1ed8301b15000331c906";
        hash = "sha256-2WTbCQlhwMo5cOn3KwtNiIst0tNfASfZnPNsNBs+gcU=";
      };
    in
    "${repo}/themes/tokyonight.yml";

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    initLua = ./init.lua;
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
    };
    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 65535;
        max_height = 65535;
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      background = "000000";
      background-image = "/home/army/Pictures/Castorice/the_pink_team.1.jpg";
      background-image-opacity = 0.025;
      background-image-fit = "cover";

      selection-foreground = "cell-background";
      selection-background = "cell-foreground";
    };
  };

  programs.fastfetch.enable = true;
  programs.fish.shellAliases.fastfetch = "fastfetch --config examples/25 --logo /home/army/Pictures/Castorice/castorice-ansi";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
