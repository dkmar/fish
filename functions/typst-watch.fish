function typst-watch
   set fname (path basename -E $argv)
   watchexec -e typ "typst compile $fname.typ -f svg; and open $fname.svg"
end
