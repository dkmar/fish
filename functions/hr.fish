function hr
    set -l cols (tput cols)
    # repeat '-'
    printf "-%.0s" (seq $cols)
end
