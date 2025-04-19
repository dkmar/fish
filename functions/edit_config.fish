function edit_config
    set config_files \
        ~/.config/ghostty/config \
        ~/.config/fish/config.fish \
        ~/.config/fish/ \
        ~/.config/fish/conf.d/abbrs.fish

    set selected_path (string join \n $config_files | command fzf)
    test -n "$selected_path"; or return 0

    switch $selected_path
    case '*abbrs.fish'
        set lines (wc -l $selected_path | choose 0)
        zed $selected_path:$(math $lines - 1)
    case '*'
        zed "$selected_path"
    end
    commandline --function repaint
end
