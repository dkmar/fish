# guard for unnecessary init
set -q MY_ABBRS_INITIALIZED; and return

abbr -a -- ls eza -l
abbr -a -- lsa eza -la
abbr -a -- tree eza -T
abbr -a -- less bat
abbr -a -- gs git status
abbr -a --set-cursor -- gcm git commit -m \'%\'
abbr -a -- ga git_add_fzf
abbr -a -- gp git push
abbr -ac abbr refresh '; set -e MY_ABBRS_INITIALIZED; and source ~/.config/fish/conf.d/abbrs.fish'
abbr -a -- choose choose --one-indexed
abbr -a -- ai aichat -r concise -m gemini:gemini-2.0-flash
abbr -a -- xcode xed
abbr -a -- fast fast --upload
abbr -a -- aider aider --env-file /Users/dkmar/.config/aider/.env
abbr -a -- findall find . -type f -not -path "\"./.git*/*\""
abbr -a -- wget curl -O
abbr -a -- mflux mflux-generate --model dev --steps 25 --low-ram --width 832 --height 1216 --metadata --prompt
abbr -a -- collapse-spaces tr '\n' ' ' | tr -s ' '
abbr -a -- ytdl yt-dlp -o '"%(title)s.%(ext)s"'

set -g MY_ABBRS_INITIALIZED true
