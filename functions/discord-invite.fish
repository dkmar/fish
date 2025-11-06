function discord-invite --description 'open discord invite in app. this is useful when the browser isnt launching the invite link in the app automatically. might require the app to be not running.'
   # get code from tail of https://discord.gg/{invite_code}
   set -l code (string split '/' -- $argv[1])[-1]
   open "discord://discordapp.com/invite/$code"
end
