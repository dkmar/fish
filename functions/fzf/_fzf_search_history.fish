function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # history merge incorporates history changes from other fish sessions
    # it errors out if called in private mode
    if test -z "$fish_private_mode"
        builtin history merge
    end

    if not set --query fzf_history_time_format
        # Reference https://devhints.io/strftime to understand strftime format symbols
        set -f fzf_history_time_format "%m-%d %H:%M:%S"
    end

    set flag_history_edit _EDIT_HISTORY
    # Delinate time from command in history entries using the vertical box drawing char (U+2502).
    # Then, to get raw command from history entries, delete everything up to it. The ? on regex is
    # necessary to make regex non-greedy so it won't match into commands containing the char.
    set -f time_prefix_regex '^.*? │ '

    # Delinate commands throughout pipeline using null rather than newlines because commands can be multi-line

    # 1.  Build the list that fzf will see
    # Calculate indent for pretty wrapping
    set -l lhs_indent_size (string length (date +"$fzf_history_time_format | "))
    set -l wrap_prefix (string repeat -n $lhs_indent_size ' ')

    set -f commands_selected (
        builtin history --null --show-time="$fzf_history_time_format │ " |
        sd '\n' "\n$wrap_prefix" |
        _fzf_wrapper --read0 \
            --print0 \
            --multi \
            --no-cycle \
            --wrap-sign="$wrap_prefix" \
            --highlight-line \
            --scheme=history \
            --prompt="History> " \
            --query=(commandline) \
            --preview="string replace --regex '$time_prefix_regex' '' -- {} | fish_indent --ansi" \
            --preview-window="bottom:3:wrap" \
            --bind="shift-delete:become:echo $flag_history_edit; [ \$FZF_SELECT_COUNT -eq 0 ]; and echo {}; or cat {+f}" \
            $fzf_history_opts |
        string split0 |
        # remove timestamps from commands selected
        string replace --regex $time_prefix_regex ''
    )


    if test $status -eq 0
        if test "$commands_selected[1]" = "$flag_history_edit"
            for cmd in $commands_selected[2..]
                history delete --exact --case-sensitive -- $cmd
            end
        else
            commandline --replace -- $commands_selected
        end
    end

    commandline --function repaint
end
