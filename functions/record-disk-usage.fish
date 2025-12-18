function record-disk-usage
   # Find the most recent previous SSD log
   count /tmp/ssd-*.txt >/dev/null; and set prev_log (ls -t /tmp/ssd-*.txt 2>/dev/null | head -n 1)

   # Get current smartctl output
   set -l current_output (smartctl -A /dev/disk0 | string collect)
   set -l log_file /tmp/ssd--(date +%b%d_%Hh%Mm%Ss).txt

   # Save to file
   echo "$current_output" | tee $log_file

   # If previous log exists, calculate and display difference
   if set -q prev_log
      # Extract Data Units Written from previous log (remove commas)
      set -l prev_units (grep 'Data Units Written:' $prev_log | string match -gr 'Data Units Written:\s+([\d,]+)' | string replace -a ',' '')
      # Extract Data Units Written from current output (remove commas)
      set -l curr_units (echo "$current_output" | grep 'Data Units Written:' | string match -gr 'Data Units Written:\s+([\d,]+)' | string replace -a ',' '')

      if test -n "$prev_units" -a -n "$curr_units"
         # Each data unit is 512KB (512 * 1000 bytes per NVMe spec)
         # Difference in GB = (curr - prev) * 512000 / 1000000000
         set -l diff_units (math "$curr_units - $prev_units")
         set -l diff_gb (math --scale=2 "$diff_units * 0.000512")

         # Calculate elapsed time since last log
         set -l prev_timestamp (stat -f %m $prev_log)
         set -l curr_timestamp (date +%s)
         set -l elapsed_secs (math "$curr_timestamp - $prev_timestamp")

         # Convert to days, hours, minutes
         set -l days (math --scale=0 "$elapsed_secs / 86400")
         set -l remaining (math "$elapsed_secs % 86400")
         set -l hours (math --scale=0 "$remaining / 3600")
         set -l remaining (math "$remaining % 3600")
         set -l mins (math --scale=0 "$remaining / 60")

         # Build elapsed time string
         set -l elapsed_str ""
         test $days -gt 0; and set elapsed_str "$days"d
         test $hours -gt 0; and set elapsed_str "$elapsed_str $hours"h
         test $mins -gt 0 -o -z "$elapsed_str"; and set elapsed_str "$elapsed_str $mins"m
         set elapsed_str (string trim $elapsed_str)

         echo ""
         echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
         echo "Previous log: $prev_log"
         echo "Time elapsed: $elapsed_str"
         echo "Data written: $diff_gb GB"
         echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      end
   end

   # launch and dont insist that it be foregrounded. we would prefer to launch it hidden
   # but it seems to not load the stats while hidden.
   pgrep -x "Activity Monitor" >/dev/null; and set ALREADY_RUNNING 1;
   open -a 'Activity Monitor'
   sleep 0.5
   # open disk tab
   osascript -e 'tell application "System Events" to click (radio button 4 of radio group 1 of group 1 of toolbar 1 of window 1 of process "Activity Monitor")' >/dev/null
   # get windowID
   set wID (swift -e '
      import Foundation
      import CoreGraphics

      let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as! [[String: Any]]
      for window in windows {
          if let id = window[kCGWindowNumber as String] as? Int,
             let owner = window[kCGWindowOwnerName as String] as? String {
              print("ID: \(id) - \(owner)")
          }
      }' | string match -gr 'ID: ([0-9]+) - Activity Monitor'
   )
   # early exit if smth didnt work
   test -n "$wID"; or return 1
   # give time to load stats before bringing to foreground if not already running.
   not set -q ALREADY_RUNNING; and sleep 8
   osascript -e 'tell application "Activity Monitor" to activate'; sleep 0.5
   # screenshot and kill
   screencapture -l $wID "/tmp/$(date +%b%d_%Hh%Mm%Ss).png"
   sleep 0.5
   pkill 'Activity Monitor'
end
