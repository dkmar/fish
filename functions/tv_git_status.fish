function tv_git_status
   set -f --export SHELL (command --search fish)
   git -c color.status=always status --short | tv --preview '_fzf_preview_changed_file {}'
end
