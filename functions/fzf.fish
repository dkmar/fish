function fzf --wraps='fzf'
    set -l flag_cmdline _CMDLINE
    set -l OPTS $FZF_DEFAULT_OPTS "--bind 'alt-c:become:[ \$FZF_SELECT_COUNT -eq 0 ]; and echo -n {} | pbcopy; or echo -n {+} | pbcopy' --bind 'alt-enter:become:echo $flag_cmdline; [ \$FZF_SELECT_COUNT -eq 0 ]; and echo {}; or echo {+}'"
    set -l res (FZF_DEFAULT_OPTS=$OPTS command fzf $argv)
    or return $status

    # success but no items -> we pressed alt-c and copied them
    if test -z "$res"
        return 0
    end
    # should we append the selected items to the command line?
    if test "$res[1]" = "$flag_cmdline"
        set --erase res[1]
        commandline -a $res
        return 0
    end
    # print the items
    echo $res
end
