set -l rows

for f in ~/.config/fish/functions/*.fish
    set -l name (basename $f .fish)
    set -l desc (string match -rg -- '--description="([^"]+)"' (head -1 $f))
    test -z "$desc"; and set desc —
    set -a rows (printf "%s\tfunction\t%s" $name $desc)
end

alias | while read -l line
    set -l name (string match -rg "^alias (\S+)" $line)
    set -l val  (string match -rg "^alias \S+ '(.*)'" $line)
    test -z "$val"; and set val —
    test -n "$name"; and set -a rows (printf "%s\talias\t%s" $name $val)
end

set -l sorted (printf "%s\n" $rows | sort)

set -l header (printf "%-20s  %-10s  %s" COMMAND TYPE DESCRIPTION)
set -l picked (
    for row in $sorted
        set -l parts (string split -m 2 (printf "\t") $row)
        printf "%-20s  %-10s  %s\n" $parts[1] $parts[2] $parts[3]
    end | fzf --header="$header" --reverse --height=~100% --prompt="aflist: "
)
if test -n "$picked"
    commandline -i (string trim (string split -m1 ' ' $picked)[1])
end
