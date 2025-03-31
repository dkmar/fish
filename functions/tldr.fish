function tldr --description 'tldr or man if no results'
   command tldr $argv 2>/dev/null
   and return

   # Check if the man page is a fish man page. if so open in devdocs, otherwise man.
   if string match -q "/opt/homebrew/Cellar/fish/*/share/fish/man/man*" (man -w $argv 2>/dev/null)
       open "devdocs-macos://search?doc=fish&term=$argv"
   else
       man $argv
   end
end
