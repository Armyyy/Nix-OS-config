for p in $PATH
    if string match -q "/nix/store/*" $p
        set_color brblack
    else
        set_color green
    end
    echo $p
end
set_color normal
