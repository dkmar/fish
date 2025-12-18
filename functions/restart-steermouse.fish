function restart-steermouse
    killall 'SteerMouse Manager'; sleep 1; open -a '/Applications/SteerMouse.app/Contents/Library/LoginItems/SteerMouse Manager.app'
end
