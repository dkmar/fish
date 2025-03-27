function typst-watch-dark
   watchexec -e typ "typst compile $argv.typ -f svg - | svg-invert > $argv.svg; and open $argv.svg"
end
