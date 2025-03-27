function kill_region
   echo -n "$(commandline -c)" | pbcopy
   commandline ''
end
