function edit_config
    set config_files \
        ~/.config/ghostty/config \
        ~/.config/fish/config.fish \
        ~/.config/fish/

    set selected_path (string join \n $config_files | fzf)
    if test -n "$selected_path"
        zed "$selected_path"
    end
    commandline --function repaint
end
