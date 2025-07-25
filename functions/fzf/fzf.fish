function fzf --wraps='fzf'
    set -l flag_cmdline _CMDLINE
    set -l OPTS $FZF_DEFAULT_OPTS \
        "--preview 'fzf-preview.sh {}' --preview-window hidden" \
        "--bind 'alt-c:become:[ \$FZF_SELECT_COUNT -eq 0 ]; and echo -n {} | pbcopy; or echo -n {+} | pbcopy'" \
        "--bind 'alt-enter:become:echo $flag_cmdline; [ \$FZF_SELECT_COUNT -eq 0 ]; and echo {}; or echo {+}'"

    # Prepare to capture output line by line
    set -l res
    # Run fzf, piping its output to the while loop.
    # fzf will inherit stdin correctly (either TTY or pipe).
    # The while loop reads fzf's stdout line by line.
    FZF_DEFAULT_OPTS=$OPTS command fzf $argv | while read -l line
        set -a res $line
    end

    set -l fzf_status $pipestatus[1]
    test $fzf_status -eq 0; or return $fzf_status

    # success but no items -> we pressed alt-c and copied them
    if test -z "$res"
        return 0
    end
    # should we insert the selected items to the command line?
    if test "$res[1]" = "$flag_cmdline"
        set --erase res[1]
        commandline -i $res
        return 0
    end
    # print the items
    echo $res
end
