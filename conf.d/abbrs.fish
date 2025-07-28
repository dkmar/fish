# guard for unnecessary init
set -q MY_ABBRS_INITIALIZED; and return

abbr -a -- ls eza
abbr -a -- lsl eza -l
abbr -a -- lsa eza -la
abbr -a -- tree eza -T
abbr -a -- less bat
abbr -a -- gs git status
abbr -a --set-cursor -- gcm git commit -m \'%\'
abbr -a -- ga git_add_fzf
abbr -a -- gp git push
abbr -ac abbr refresh '; set -e MY_ABBRS_INITIALIZED; and source ~/.config/fish/conf.d/abbrs.fish'
abbr -a -- choose choose --one-indexed
abbr -a -- ai aichat -r concise --
abbr -a -- xcode xed
abbr -a -- fast fast --upload
abbr -a -- aider aider --env-file /Users/dkmar/.config/aider/.env
abbr -a -- findall find . -type f -not -path "\"./.git*/*\""
abbr -a -- wget curl -O
abbr -a -- mflux mflux-generate --model dev --steps 25 --low-ram --width 832 --height 1216 --metadata --prompt
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
abbr --add --command z -- docs documents
set -g MY_ABBRS_INITIALIZED true
