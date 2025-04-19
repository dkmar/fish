function toggle_line_wrapping
    if set -q LINE_WRAPPING_DISABLED
        set -e LINE_WRAPPING_DISABLED
        # enable line wrapping
        tput smam
    else
        set -g LINE_WRAPPING_DISABLED
        # disable line wrapping
        tput rmam
    end
end
