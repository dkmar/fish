function icat --description 'alias icat=/Applications/kitty.app/Contents/MacOS/kitten icat'
    if test -t 0  # Check if stdin is a terminal
        # No stdin input, just pass arguments normally
        /Applications/kitty.app/Contents/MacOS/kitten icat $argv
    else
        # Stdin has data, pipe it to the command
        read -l url
        echo $url
        /Applications/kitty.app/Contents/MacOS/kitten icat (echo -n $url)
    end
end
