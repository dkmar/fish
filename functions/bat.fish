# bat wrapper that does pretty json automatically
function bat --wraps='bat'
    # case: bat <file>
    # case: pbpaste | bat -l <language>
    if isatty || string match -qr -- '.* -l .+' "$argv"
        command bat $argv
        return $status
    end

    # case: cat <file> | bat
    # read from pipe and guess if json
    tee /tmp/_bat |             # stash the full input
      head --bytes 1024 |       # lets just examine the first bit
      rg --invert-match '^//' | # strip leading comments from JSONC
      tr -d '\n' |              # drop lines breaks -- one long line
      rg -q '^\s*[\{\[]\s*(?:"[^"]*"\s*:\s*.+|\[[^\]]*\]|\{[^}]*\}|[0-9]+|true|false|null)\s*'
    and set --prepend argv -l json

    command bat $argv /tmp/_bat
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
