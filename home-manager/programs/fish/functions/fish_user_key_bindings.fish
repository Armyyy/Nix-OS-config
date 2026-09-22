# fish 4.9.3 aborts the whole shell with
#   panicked at src/reader/reader.rs:2546:79: attempt to subtract with overflow
# when a vi repeat-jump with Till precision runs on an empty command line:
# the forward branch of Reader::jump evaluates `el.len() - 1` on a usize.
# `t`/`T` (and the `ci<x>`/`di<x>`/`yi<x>` chains, which call backward-jump-till)
# leave Till as the remembered precision for the rest of the session, so one `;`
# at an empty normal-mode prompt is enough to kill it.
#
# overlays/fish-jump-till-overflow.patch fixes fish itself; this guard is the
# belt-and-braces copy for any unpatched fish (nix shell, remote host, an older
# generation). It covers the single-key `;` and `,`; the operator-pending forms
# (`d;`, `c;`, `y;`) are only fixed by the patch.

function __fish_guarded_repeat_jump
    test -z "$(commandline)"; and return
    commandline -f repeat-jump
end

function __fish_guarded_repeat_jump_reverse
    test -z "$(commandline)"; and return
    commandline -f repeat-jump-reverse
end

for mode in default visual
    bind -M $mode ';' __fish_guarded_repeat_jump
    bind -M $mode ',' __fish_guarded_repeat_jump_reverse
end
