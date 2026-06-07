# NixOS Config

NixOS + home-manager + nh (nix helper). User: army.

## Apply changes
```
nh home switch       # home-manager only
nh os switch -a      # full NixOS system
```

Never run `nh home switch` or `nh os switch` — user applies changes themselves.

## Structure
```
flake.nix                        # flake entry point
nixos/configuration.nix          # system config
home-manager/
  home.nix                       # imports all modules
  programs/                      # one dir per program
    <program>/default.nix
  programs/fish/
    default.nix                  # function definitions + descriptions
    conf.d/aliases.nix           # shell aliases
    conf.d/init.fish             # shellInit
    conf.d/interactive.fish      # interactiveShellInit
    functions/<name>.fish        # function bodies (sourced via readFile)
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
- Fish function descriptions: set in `default.nix` `functions.<name>.description`, not in `.fish` files
- Override module-generated fish functions (e.g. lg, yy): use `lib.mkForce { description = "..."; body = "..."; }` in the program's own `default.nix`
