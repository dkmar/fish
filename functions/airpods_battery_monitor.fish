# Function to check AirPods battery and alert if low
function check_airpods_battery
   # https://apple.stackexchange.com/a/479643/681686
   set output (pmset -g accps 2>/dev/null)

   # Check if AirPods are connected (look for "AirPods" but exclude "Case")
   if not string match -q "*AirPods*" $output
      return
   end

   # Extract percentages from AirPods lines, excluding Case lines
   set percentages (string match -r '.*AirPods(?!.*Case).*\s(\d+)%;' $output | string match -r '\d+%' | string replace '%' '')

   if test (count $percentages) -eq 0
      return
   end

   # Find minimum percentage
   set min_charge (math min (string join ',' -- $percentages))

   # Alert if below 40%
   if test $min_charge -le 40
      osascript -e "display dialog \"AirPods battery at $min_charge%\" with title \"Low AirPods Battery\""
   end
end

# Run check every 60 seconds
while true
   check_airpods_battery
   sleep 60
end
