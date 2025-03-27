function _fasd_update_pwd --on-variable PWD
   fasder --add "$PWD"
end

function _fasd_update --on-event fish_preexec
   # split commandline into tokens
   echo $argv[1] | read --tokenize --list -- tokens

   # skip if its a cd command to avoid double counting
   set -l exclude_cmds cd z
   contains $tokens[1] $exclude_cmds; and return
   # also early exit if there's only the leading command here
   test (count $tokens) = 1; and return

   # get normalized, absolute path candidates for the rest of the tokens
   # and keep only those that are existing files or directories
   set -l candidates (path resolve -- $tokens[2..] | path filter -t file,dir)
   for fp in $candidates
      # only add if this path isn't to an executable
      if not type -q $fp
         fasder --add "$fp"
      end
   end
end
