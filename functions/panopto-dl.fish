function panopto-dl
   set outfile $argv[2]
   set -q out; or set out video.mp4
   ffmpeg -loglevel quiet -f hls -i $argv[1] -c copy $outfile
end
