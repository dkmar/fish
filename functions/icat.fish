function icat --description 'Wrap kitten icat to read files, URLs or raw image data'
    argparse "s/save" -- $argv
    or return

    # ───────────────────────────────────────────────────────
    # 1) Interactive use: if STDIN is a TTY, just forward everything
    if isatty
        /Applications/kitty.app/Contents/MacOS/kitten icat $argv
        return
    end

    # ───────────────────────────────────────────────────────
    # 2) Slurp *all* stdin into a temp file
    set -q _flag_save
    and set tmp (mktemp /tmp/icat.XXXXXX)
    or set tmp /tmp/_icat
    sponge $tmp  # just in case they're catting /tmp/_icat lol

    # ───────────────────────────────────────────────────────
    # 3) Peek first 10 bytes to detect a URL (look for "://")
    if head --bytes 10 $tmp | string match -qr '://'
        # — URL case — strip newline and curl image
        set -l url (string trim (cat $tmp))
        curl -L --fail $url > $tmp
    end
    # — raw image data — feed the blob *and* any flags into kitty
    /Applications/kitty.app/Contents/MacOS/kitten icat $argv < $tmp

    # ───────────────────────────────────────────────────────
    # 4) Cleanup
    # rm $tmp
    if set -q _flag_save
        echo "Saved image data to: $tmp"
    end
end

# function icat --description 'alias icat=/Applications/kitty.app/Contents/MacOS/kitten icat'
#     if isatty
#         # icat <file|url>
#         /Applications/kitty.app/Contents/MacOS/kitten icat $argv
#         return
#     end

#     # case 1: echo url | icat
#     # case 2: curl url | icat
#     #         cat file | icat
#     tee /tmp/_icat |         # stash the full input
#       head --bytes 10 |      # lets just examine the first bit
#       string match -qr '://' # test if it's a url
#     and /Applications/kitty.app/Contents/MacOS/kitten icat --stdin=no $argv -- (cat /tmp/_icat)
#     or /Applications/kitty.app/Contents/MacOS/kitten icat < /tmp/_icat
# end
