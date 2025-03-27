function anybar --argument-names color --argument-names port
  [ -n "$port" ]; or set port 1738
  echo -n $color | nc -4u -w0 localhost $port
end
