function fzf --wraps='fzf'
    set -l flag_cmdline _CMDLINE
    set -l OPTS $FZF_DEFAULT_OPTS \
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

# ~/.config/fish/functions/fzf.fish
function efzf --wraps='fzf' --description "fzf wrapper with custom bindings and commandline insertion (handles pipes)"
    set -l flag_cmdline "_FZF_CMDLINE_FLAG_" # Use a more unique flag
    set -l base_opts $FZF_DEFAULT_OPTS
    # Define common bindings
    set -l common_binds "alt-c:become:[ \$FZF_SELECT_COUNT -eq 0 ]; and echo -n {} | pbcopy; or echo -n {+} | pbcopy"
    # Define opts - these apply whether stdin is a pipe or tty
    set -l OPTS $base_opts "--bind '$common_binds' --bind 'alt-enter:become:echo $flag_cmdline; [ \$FZF_SELECT_COUNT -eq 0 ]; and echo {}; or echo {+}'"

    # Prepare to capture output line by line
    set -l received_lines

    # Run fzf, piping its output to the while loop.
    # fzf will inherit stdin correctly (either TTY or pipe).
    # The while loop reads fzf's stdout line by line.
    FZF_DEFAULT_OPTS=$OPTS command fzf $argv | while read -l line
        set -a received_lines $line
    end

    # IMPORTANT: Check the status of the fzf command itself (the first part of the pipe)
    set -l fzf_status $pipestatus[1]

    # Check fzf exit status (e.g., Ctrl+C -> 130)
    if test $fzf_status -ne 0
        # Propagate non-success exit codes (like 130 for abort, 1 for no match)
        # Suppress fish's default pipe error message for common non-zero exits like 1 or 130
        if test $fzf_status -eq 1 -o $fzf_status -eq 130
           # Mute "Command terminated abnormally" message for these specific statuses
           # Returning the status is often still useful.
           # If you want *no* indication of failure for these, return 0 here conditionally.
        else
           # Print error for other non-zero statuses? Or just return it silently?
           # echo "fzf exited with status $fzf_status" >&2 # Optional: for debugging
        end
        return $fzf_status
    end

    # fzf succeeded (status 0)

    # Check if output is empty. This usually means alt-c was pressed (become:)
    # or Enter was pressed with no selection.
    if test -z "$received_lines"
        # The action (like pbcopy for alt-c) happened via 'become'.
        # We don't need to do anything else here. Return success.
        return 0
    end

    # Check if the first line is our flag for command line insertion (alt-enter)
    if test "$received_lines[1]" = "$flag_cmdline"
        # Remove the flag line
        set --erase received_lines[1]
        # Append the rest to the command line only if there's something left
        if test -n "$received_lines"
            commandline --append -- (string escape -- $received_lines) # escape items
        end
        # Repaint the command line to show the changes
        commandline --current-token --cursor (commandline --cursor)
        commandline -f repaint
        return 0 # Success
    end

    # Default case (no special binding used, just selected items): print them
    # Use printf for safer printing of multiple lines/items
    printf "%s\n" $received_lines
    return 0 # Success
end
