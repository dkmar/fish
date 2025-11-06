# guard for unnecessary init
set -q MY_ABBRS_INITIALIZED; and return

abbr -a -- ls eza
abbr -a -- lsl eza -l
abbr -a -- lsa eza -la
abbr -a -- lsd eza -l --sort=modified --reverse
abbr -a -- tree eza -T
abbr -a -- tree1 eza -T --level=1
abbr -a -- tree2 eza -T --level=2
abbr -a -- tree3 eza -T --level=3

abbr --add --command z -- docs documents
abbr --add --command z -- adl adv

abbr -a -- less bat
abbr -a -- gs git status
abbr -a --set-cursor -- gcm git commit -m \'%\'
abbr -a -- ga git_add_fzf
abbr -a -- gp git push
abbr -a -- ai aichat -r concise --
abbr -a -- xcode xed
abbr -a -- fast fast --upload
abbr -a -- aider aider --env-file /Users/dkmar/.config/aider/.env
abbr -a -- findall find . -type f -not -path "\"./.git*/*\""
abbr -a -- wget curl -L -O
abbr -a -- collapse-spaces "tr '\n' ' ' | tr -s ' '"
abbr -a -- ytdl yt-dlp -o '"%(title)s.%(ext)s"'
abbr -a -- mp3dl yt-dlp -o '"%(title)s.%(ext)s"' --extract-audio
abbr -a -- exists test -e
abbr -a -- ais aichat -r shell --
abbr -a -- brd br --sort-by-date
abbr -a -- table csvlens --no-headers -d auto
abbr -a -- sum awk "'{t+=\$1} END {print t}'"
abbr --add --set-cursor -- each while read -l x\n%\nend
abbr --add --set-cursor -- anyb 'open -a AnyBar && anybar yellow;' % '; anybar green'
set -g MY_ABBRS_INITIALIZED true
