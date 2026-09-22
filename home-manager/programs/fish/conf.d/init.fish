set -gx EDITOR hx

# fish's directory history ($dirprev) is per-process, so nested shells —
# `nix shell` / `nix develop` spawned by nix-your-shell — start empty and
# `cd -` has nothing to go back to. Pass the stack down through the env.
if test -n "$__FISH_DIRPREV"
    set -g dirprev (string split \x1e -- $__FISH_DIRPREV)
    set -g __fish_cd_direction prev
end

function __fish_export_dirprev --on-variable dirprev
    set -gx __FISH_DIRPREV (string join \x1e -- $dirprev)
end
__fish_export_dirprev
