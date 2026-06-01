set -l rows
for f in ~/.config/fish/functions/*.fish
    set -l name (basename $f .fish)
    set -l desc (string match -rg -- '--description="([^"]+)"' (head -1 $f))
    test -z "$desc"; and set desc —
    set -a rows (printf "%s\t%s" $name $desc)
end

if contains -- --csv $argv
    begin
        printf "name\tdescription\n"
        printf "%s\n" $rows
    end | csvlens -t
else
    set -l header (printf "%-20s  %s" FUNCTION DESCRIPTION)
    set -l picked (
        for row in $rows
            set -l parts (string split -m1 (printf "\t") $row)
            printf "%-20s  %s\n" $parts[1] $parts[2]
        end | fzf --header="$header" --reverse --height=~100% --prompt="fn: "
    )
    if test -n "$picked"
        commandline -i (string trim (string split -m1 ' ' $picked)[1])
    end
end
