if contains -- --pick $argv
    set fmt "%-20s  %-30s  %-35s  %s"
    set header (printf "$fmt" ID NAME STATUS IMAGE)

    set selections (
        docker ps -a --format "{{.ID}}|{{.Names}}|{{.Status}}|{{.Image}}" \
            | while read -l line
                set p (string split '|' $line)
                if string match -q "Up*" $p[3]
                    printf "\e[32m$fmt\e[0m\n" $p[1] $p[2] $p[3] $p[4]
                else
                    printf "\e[2m$fmt\e[0m\n" $p[1] $p[2] $p[3] $p[4]
                end
            end \
            | fzf --ansi --multi --header="$header" --reverse --height=50% --prompt="rm: "
    )

    for sel in $selections
        set clean (string replace -ra '\x1b\[[0-9;]*m' '' $sel)
        set id (string split ' ' (string trim $clean))[1]
        docker stop $id &>/dev/null
        docker rm $id
    end
else
    set stopped (docker ps -a --filter status=exited --format "{{.ID}}  {{.Names}}  {{.Status}}")
    if test -z "$stopped"
        echo "no stopped containers"
        return 0
    end
    echo "stopped containers:"
    echo ""
    printf "\e[2m%s\e[0m\n" $stopped
    echo ""
    read -l -P "remove all? [y/N] " confirm
    if test "$confirm" = y -o "$confirm" = Y
        docker ps -a --filter status=exited --format "{{.ID}}" | xargs docker rm
        echo "done"
    end
end
