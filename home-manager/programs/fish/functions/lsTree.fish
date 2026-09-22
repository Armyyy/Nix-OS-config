# lsTree - eza tree one level deep, rooted at the cwd name instead of "."
set -l has_target 0
for arg in $argv
    if not string match -q -- '-*' $arg; and test -e $arg
        set has_target 1
        break
    end
end

if test $has_target -eq 1
    eza --tree --level=1 $argv
    return
end

set -l parent (path dirname $PWD)
if test $parent = /
    eza --tree --level=1 $argv -- $PWD
else
    eza --tree --level=1 $argv -- $PWD | string replace -- $parent/ ""
end
