# suppress "Welcome to fish, the friendly interactive shell" banner
set -g fish_greeting ''

# vi modal editing. Declared here rather than left to the stray
# ~/.config/fish/conf.d/fish_frozen_key_bindings.fish that fish wrote during the
# 4.3 universal->global migration. Must stay above the tmux exec below, which
# never returns. Setting this fires fish's binding reload, which in turn runs
# fish_user_key_bindings (see ../functions/fish_user_key_bindings.fish).
set -g fish_key_bindings fish_vi_key_bindings

# -U (universal) required — fish color vars ignore -g (global)
set -U fish_color_autosuggestion '444'

# auto-start tmux on interactive shell (each terminal gets own session)
# isatty stdin — skip when Zed/scripts spawn fish headlessly to capture env
if status is-interactive && isatty stdin && test -z "$TMUX" && command -q tmux
  exec tmux new-session
end

# Alternative: auto-attach to single shared session instead of new session per terminal
# if status is-interactive && test -z "$TMUX" && command -q tmux
#   set -g fish_escape_delay_ms 10
#   exec tmux new-session -A -s main
# end
