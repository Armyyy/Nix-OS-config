function fish_command_not_found
    set -l cmd $argv[1]

    # Fast path 1: path-like command (./foo, /usr/bin/foo) — not a missing package
    if string match -q '*/*' -- $cmd
        printf "fish: Unknown command: %s\n" (string escape -- $cmd) >&2
        return 127
    end

    # Fast path 2: cache check (10 min TTL)
    set -l cache_dir /tmp/fish_cnf_cache
    set -l cache_file $cache_dir/(string escape --style=url -- $cmd)
    if test -f $cache_file
        set -l mtime (stat -c %Y $cache_file 2>/dev/null)
        if test -n "$mtime" && test (math (date +%s) - $mtime) -lt 600
            printf "fish: Unknown command: %s\n" (string escape -- $cmd) >&2
            set -l cached (cat $cache_file)
            test -n "$cached" && printf "%s\n" $cached >&2
            return 127
        end
    end

    mkdir -p $cache_dir

    # Slow path: nix-locate search (result cached for next time)
    set -l attrs (nix-locate --minimal --no-group --type x --type s --whole-name --at-root "/bin/$cmd" 2>/dev/null)
    set -l count (count $attrs)

    printf "fish: Unknown command: %s\n" (string escape -- $cmd) >&2

    set -l msg ""
    if test $count -eq 1
        set msg "nix-shell -p $attrs[1]  # provides '$cmd'"
        printf "%s\n" $msg >&2
    else if test $count -gt 1
        set -l lines "Multiple packages provide '$cmd':"
        for attr in $attrs
            set lines $lines "  nix-shell -p $attr"
        end
        set msg (string join \n $lines)
        printf "%s\n" $msg >&2
    end

    printf "%s" $msg > $cache_file
    return 127
end
