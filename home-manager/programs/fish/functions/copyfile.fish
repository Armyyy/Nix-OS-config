if test (count $argv) -eq 0
    echo "copyfile: need at least one file/dir" >&2
    return 1
end
set -l paths
for f in $argv
    if not test -e $f
        echo "copyfile: no such file/dir: $f" >&2
        return 1
    end
    set -a paths (realpath $f)
end
set -U FILE_CLIPBOARD $paths
printf 'copied %d item(s):\n' (count $paths)
printf '  %s\n' $paths
