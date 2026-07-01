if not set -q FILE_CLIPBOARD; or test (count $FILE_CLIPBOARD) -eq 0
    echo "pastefile: clipboard empty (use copyfile first)" >&2
    return 1
end
set -l dest .
if test (count $argv) -ge 1
    set dest $argv[1]
end
for src in $FILE_CLIPBOARD
    if not test -e $src
        echo "pastefile: source gone: $src" >&2
        continue
    end
    cp -r $src $dest
    echo "pasted $src -> $dest"
end
