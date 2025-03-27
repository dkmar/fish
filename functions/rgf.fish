function rgf --description 'rg tui built with fzf and bat'
   set INITIAL_QUERY $argv[1]
   set RG_OPTS $argv[2..] " --column --line-number --no-heading --color=always --smart-case"
   fzf --ansi --disabled --query "$INITIAL_QUERY" \
       --bind "start:reload:rg {q} $RG_OPTS" \
       --bind "change:reload:sleep 0.1; rg {q} $RG_OPTS || true" \
       --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
       --color "hl:-1:underline,hl+:-1:underline:reverse" \
       --prompt '1. ripgrep> ' \
       --delimiter : \
       --preview "bat --color=always {1} --theme='Nord' --highlight-line {2}" \
       --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
       --bind "enter:become($EDITOR {1}:{2})"
    # rg $argv --ignore-case --color=always --line-number --no-heading |
    #     fzf --ansi \
    #         --color 'hl:-1:underline,hl+:-1:underline:reverse' \
    #         --delimiter ':' \
    #         --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
    #         --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    #         --bind "enter:become($EDITOR {1}:{2})"
end
