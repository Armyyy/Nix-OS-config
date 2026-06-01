set -l rows
alias | while read -l line
    set -l name (string match -rg "^alias (\S+)" $line)
    set -l val  (string match -rg "^alias \S+ '(.*)'" $line)
    test -z "$val"; and set val —
    test -n "$name"; and set -a rows (printf "%s\t%s" $name $val)
end

if contains -- --csv $argv
    begin
        printf "alias\tcommand\n"
        printf "%s\n" $rows
    end | csvlens -t
else
    set -l header (printf "%-15s  %s" ALIAS COMMAND)
    set -l picked (
        for row in $rows
            set -l parts (string split -m1 (printf "\t") $row)
            printf "%-15s  %s\n" $parts[1] $parts[2]
        end | fzf --header="$header" --reverse --height=~100% --prompt="alias: "
    )
    if test -n "$picked"
        commandline -i (string trim (string split -m1 ' ' $picked)[1])
    end
end
