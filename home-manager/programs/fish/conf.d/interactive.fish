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
