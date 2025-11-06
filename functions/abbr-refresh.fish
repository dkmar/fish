function abbr-refresh
   # clear existing
   abbr --erase (abbr --list)
   # reset INIT flag
   set -e MY_ABBRS_INITIALIZED
   # set abbrs
   source ~/.config/fish/conf.d/abbrs.fish
end
