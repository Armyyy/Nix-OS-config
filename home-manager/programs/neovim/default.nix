{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    initLua = ''
      vim.opt.number = false
      vim.opt.relativenumber = false
      -- vim.opt.cursorline = true
      -- vim.opt.cursorcolumn = true
      -- vim.opt.shortmess:remove("S")
    '';
    #+ builtins.readFile ./crosshair.lua;
  };

  # LazyVim lives under its own NVIM_APPNAME to stay separate from plain nvim
  xdg.configFile."lazyvim/init.lua".text = ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"
    vim.opt.rtp:prepend("${pkgs.vimPlugins.lazy-nvim}")
  ''
  + builtins.readFile ./lazy.lua;

  xdg.configFile."lazyvim/lua/plugins/user.lua".source = ./plugins/user.lua;
  xdg.configFile."lazyvim/lua/config/options.lua".text =
    builtins.readFile ./lazyvim-options.lua + builtins.readFile ./crosshair.lua;

  # `nvim --lazy` -> LazyVim, `nvim` -> plain
  programs.fish.functions.nvim = {
    description = "neovim: --lazy opens LazyVim";
    body = ''
      if contains -- --lazy $argv
        set -lx NVIM_APPNAME lazyvim
        command nvim (string match -rv '^--lazy$' -- $argv)
      else
        command nvim $argv
      end
    '';
  };
}
