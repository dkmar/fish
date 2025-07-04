# Usage:
# `bump 0.5`
# `bump reset`
# `bump -q`
function bump
    argparse 'q/query' -- $argv
    # Define log file location
    set -l bump_file "$XDG_DATA_HOME/bump/bump.log"
    # Reset command: if the first argument is "reset", clear the log and output zero.
    if test "$argv[1]" = "reset" -o "$argv[1]" = "clear"
        echo -n "" > "$bump_file"
        echo "0 ~ @ " (date '+%A %H:%M %m-%d')
        return 0
    end

    # Get the current time (epoch seconds)
    set -l now (date +%s)

    # Set default quantity to 1 if no argument is provided, otherwise use the first argument.
    set -l qty 1
    if set -q _flag_q
        # querying. dont bump.
        set qty 0
    else
        if test -n "$argv[1]" -a "$argv[1]" -gt 0
            # custom bump quantity
            set qty $argv[1]
        end
        # log the current bump.
        echo "$now $qty" >> "$bump_file"
    end

    # Define threshold for the last 24 hours.
    set -l threshold (math "$now - 86400")

    set -l tmpfile "$bump_file.tmp"; touch "$tmpfile"
    # Process each record from the log.
    set -l last_time 0
    set -l total 0
    while read -l tm cnt
        if test $tm -ge $threshold
            set last_time $tm
            set total (math "$total + $cnt")
            echo "$tm $cnt" >> "$tmpfile"
        end
    end < "$bump_file"

    # Replace the original log with the updated one (only recent entries).
    mv "$tmpfile" "$bump_file"

    # Output the cumulative total and current bump time.
    echo "$total ~ @ $(date -r $last_time '+%A %H:%M %m-%d')"
end
