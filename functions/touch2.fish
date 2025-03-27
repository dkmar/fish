function touch2
   argparse d -- $argv
   set fp $argv[-1]

   if set -q _flag_d
      mkdir -p $fp
   else
      mkdir -p (dirname $fp) && touch $fp
   end
end
