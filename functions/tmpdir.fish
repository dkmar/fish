function tmpdir --wraps='mktemp -d /tmp/tmp.XXXXXXXXXX' --description 'alias tmpdir=mktemp -d /tmp/tmp.XXXXXXXXXX'
  mktemp -d /tmp/tmp.XXXXXXXXXX $argv
end
