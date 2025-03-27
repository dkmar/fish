function tldr --description 'tldr or man if no results'
   command tldr $argv 2>/dev/null; or man $argv
end
