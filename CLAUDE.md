# NixOS Config

NixOS + home-manager + nh (nix helper). User: army.

## Apply changes
```
nh home switch
```

## Structure
```
flake.nix                        # flake entry point
nixos/configuration.nix          # system config
home-manager/
  home.nix                       # imports all modules
  programs/                      # one dir per program
    <program>/default.nix
  fonts/
  nixpkgs/
  systemd/
```

## Conventions
- Each program has `home-manager/programs/<name>/default.nix`
- Add new program: create dir + default.nix, import in `home-manager/programs/default.nix`
- Zed keymap/settings: `home-manager/programs/zed-editor/default.nix`
- Claude Code config: `home-manager/programs/claude-code/default.nix`
- Shell env vars: `home.sessionVariables` in `home-manager/home.nix` (universal) or `shellInit` in fish (fish-only)
- Fish config: `home-manager/programs/fish/default.nix`
