function dailynote --wraps='osascript -l JavaScript -e \'Application("Craft").activate(); Application("System Events").keystroke("n", { using: ["option down", "command down"] })\'' --description 'alias dailynote=osascript -l JavaScript -e \'Application("Craft").activate(); Application("System Events").keystroke("n", { using: ["option down", "command down"] })\''
  osascript -l JavaScript -e 'Application("Craft").activate(); Application("System Events").keystroke("n", { using: ["option down", "command down"] })' $argv
        
end
