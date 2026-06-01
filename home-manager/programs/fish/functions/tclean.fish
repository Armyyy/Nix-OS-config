set detached (tmux ls 2>/dev/null | grep -v attached)
if test -z "$detached"
    echo "no detached sessions"
    return 0
end

echo "detached sessions:"
echo ""
printf "\e[2m%s\e[0m\n" $detached
echo ""
read -l -P "kill all? [y/N] " confirm
if test "$confirm" = y -o "$confirm" = Y
    tmux ls | grep -v attached | cut -d: -f1 | xargs -I{} tmux kill-session -t {}
    echo "done"
end
