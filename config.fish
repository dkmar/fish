# env
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx BUN_INSTALL "$XDG_DATA_HOME/bun"
set -gx GOCACHE "$XDG_CACHE_HOME/go-build"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOBIN "$GOPATH/bin"
set -gx GOMODCACHE "$GOPATH/pkg/mod"

## clean up home folder dotfiles
set -gx PYTHON_HISTORY "$XDG_DATA_HOME/python/python_history"
set -gx HISTFILE "$XDG_CACHE_HOME/sh_history"
set -gx LESSHISTFILE -
set -gx _FASDER_DATA "$XDG_DATA_HOME/.fasder"
set -gx TODO_PATH "$XDG_DATA_HOME/todo"
set -gx JUPYTER_PLATFORM_DIRS 1
set -gx MPLCONFIGDIR "$XDG_CACHE_HOME/matplotlib"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"

set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | LESS=\"-I\" bat -p -lman'"
set -gx EDITOR "zed"
set -gx VISUAL "zed --wait"
set -gx FZF_DEFAULT_OPTS '--multi --bind "ctrl-p:toggle-preview" --bind "ctrl-o:become(zed {})" --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
set fzf_directory_opts

# path
fish_add_path -P $XDG_BIN_HOME
fish_add_path -a $CARGO_HOME/bin
fish_add_path -a $BUN_INSTALL/bin
fish_add_path -a $GOBIN

# ---- interactive ----
status is-interactive || exit 0

# source event handlers
source $__fish_config_dir/functions/_fasd_update_freq.fish

# keys
bind ctrl-x kill_region ## cut line to clipboard
bind ctrl-comma edit_config
bind ctrl-b br
bind ctrl-shift-r history-pager
bind alt-up history-token-search-backward
bind alt-down history-token-search-forward
bind alt-r fuck
bind ctrl-p _fzf_search_processes
bind alt-shift-backspace backward-kill-token
bind alt-shift-left backward-token
bind alt-shift-right forward-token
bind ctrl-o 'zed .'
bind alt-backspace backward-kill-path-component
bind f9 'commandline -i "\("'
bind f10 'commandline -i "\)"'
bind ctrl-h __tldr repaint  # alin's tldr helper
bind ctrl-alt-h __fish_man_page
bind super-shift-f 'tv text'

# utils
## Initialize zoxide for fast jumping with 'z'.
if type -q zoxide
    if not test -r $__fish_cache_dir/zoxide_init.fish
        zoxide init fish >$__fish_cache_dir/zoxide_init.fish
    end
    source $__fish_cache_dir/zoxide_init.fish
end
## tv fuzzy finder
if type -q tv
   if not test -r $__fish_cache_dir/tv_init.fish
      # don't use the history binding cause the fzf history widget is better.
      tv init fish | string match --invert '*\\cR tv_shell_history' >$__fish_cache_dir/tv_init.fish
   end
   source $__fish_cache_dir/tv_init.fish
end

## pueued
if ! pgrep -q pueued
    pueued &
end

# prompt
set fish_greeting
set -g hydro_symbol_start '╭── '
# manually set the newline part of status so we can color it separately
set -g _hydro_newline "\n$hydro_color_normal╰"
set -g hydro_symbol_prompt '$'
set -g fish_prompt_pwd_dir_length 16
set -g hydro_symbol_git_dirty 🞶

# cleanup history
if status is-login
   echo 'all' | history delete --prefix 'aichat ' -- &> /dev/null
end
