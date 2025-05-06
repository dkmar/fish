function copyimg
    osascript -e "set the clipboard to (read \"$argv[1]\" as TIFF picture)"
end
