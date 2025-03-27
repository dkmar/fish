function zd --wraps='fasder -e zed' --description 'alias zd=fasder -e zed'
   argparse d -- $argv
   if set -q _flag_d
      fasder -ed zed $argv
   else
      fasder -e zed $argv
   end

end
