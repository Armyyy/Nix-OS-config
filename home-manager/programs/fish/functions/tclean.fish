if contains -- --pick $argv
    set fmt "%-20s  %-7s  %-26s  %-26s  %s"
    set header (printf "$fmt" NAME WINDOWS CREATED LAST_ACTIVE ATTACHED)

    set selections (
        tmux ls -F "#{session_attached}|#{session_activity}|#{session_name}|#{session_windows}|#{t:session_created}|#{t:session_activity}|#{?session_attached,yes,no}|#{session_group}" 2>/dev/null \
            | awk -F'|' '$8 == "" || $8 == $3' \
            | sort -t'|' -k1,1rn -k2,2rn \
            | while read -l line
                set p (string split '|' $line)
                if test "$p[1]" = "1"
                    printf "\e[32m$fmt\e[0m\n" $p[3] $p[4] $p[5] $p[6] $p[7]
                else
                    printf "\e[2m$fmt\e[0m\n" $p[3] $p[4] $p[5] $p[6] $p[7]
                end
            end \
            | fzf --ansi --multi --header="$header" --reverse --height=50% --prompt="kill: "
    )

    for sel in $selections
        set clean (string replace -ra '\x1b\[[0-9;]*m' '' $sel)
        set name (string split ' ' (string trim $clean))[1]
        tmux kill-session -t $name
        echo "killed $name"
    end
else
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
end
