function git_add_fzf
    # borrowed most of this from _fzf_search_git_status
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'git_add_fzf: Not in a git repository.' >&2
        commandline -f cancel
        return 1
    else
        set -f preview_cmd '_fzf_preview_changed_file {}'
        if set --query fzf_diff_highlighter
            set preview_cmd "$preview_cmd | $fzf_diff_highlighter"
        end

        set -f selected_paths (
            # Pass configuration color.status=always to force status to use colors even though output is sent to a pipe
            git -c color.status=always status --short |
            _fzf_wrapper --ansi \
                --multi \
                --prompt="Git Status> " \
                --preview=$preview_cmd \
                --nth="2.." \
                $fzf_git_status_opts
        )

        if test $status -eq 0
            # git status --short automatically escapes the paths of most files for us so not going to bother trying to handle
            # the few edges cases of weird file names that should be extremely rare (e.g. "this;needs;escaping")
            set -f cleaned_paths
            for path in $selected_paths
                if test (string sub --length 1 $path) = R
                    # path has been renamed and looks like "R LICENSE -> LICENSE.md"
                    # extract the path to use from after the arrow
                    set --append cleaned_paths (string split -- "-> " $path)[-1]
                else
                    set --append cleaned_paths (string sub --start=4 $path)
                end
            end
            # resolve to our git add command
            commandline -i "git add $cleaned_paths"
            return 0
        else
            # nothing to be done. lets call this a cancel
            commandline -f cancel
            return 1
        end
    end
end
