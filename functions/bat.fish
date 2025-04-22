# bat wrapper that does pretty json automatically
function bat --wraps='bat'
    # case: bat <file>
    # case: pbpaste | bat -l <language>
    if isatty; or contains -- -l $argv
        command bat $argv
        return $status
    end

    # case: cat <file> | bat
    # read from pipe and guess if json (just based on the first 1024 bytes)
    read -z --nchars 1024 chunk
    string match --invert '//*' -- $chunk | # strip comments / handle JSONC
    string join --no-empty '' |             # drop lines breaks -> one long line for regex check
    string match -qr '^\s*[\{\[]\s*(?:"[^"]*"\s*:\s*.+|\[[^\]]*\]|\{[^}]*\}|[0-9]+|true|false|null)\s*'
    and set --prepend argv -l json

    # forward to bat
    begin
        echo -n $chunk  # prefix
        cat             # rest
    end | command bat $argv
end

# wayyyyy slower than the above
# function bat2
#     if isatty
#         command bat $argv
#         return $status
#     end

#     # read from pipe and guess if json
#     read -z input

#     echo $input | head -n 100 | tr -d '\n' | rg --no-ignore --no-line-number --quiet --no-heading '^\s*[\{\[]\s*(?:"[^"]*"\s*:\s*.+|\[[^\]]*\]|\{[^}]*\}|[0-9]+|true|false|null)\s*'
#     and echo -n $input | jless --mode line
#     or echo -n $input | command bat $argv
# end

# '^\s*[\{\[]\s*(?:"[^"]*"\s*:\s*.+|\[[^\]]*\]|\{[^}]*\}|[0-9]+|true|false|null)\s*'
# Explanation:
# - ^\s*: Matches optional whitespace at the start.
# - [\{\[]: Ensures the text begins with { or [, the only valid JSON starting characters.
# - \s*: Allows optional whitespace after the opening brace/bracket.
# - The group (?:"[^"]*"\s*:\s*.+|\[[^\]]*\]|\{[^}]*\}|[0-9]+|true|false|null) checks for:
# - "[^"]*"\s*:\s*.+: A string key followed by a colon and some value (for objects).
# - \[[^\]]*\]: A nested array.
# - \{[^}]*\}: A nested object.
# - [0-9]+: A number.
# - true|false|null: JSON literals.
# This regex is not exhaustive but aims to catch common JSON patterns early.
