import posix, signals

var gonna_quit = false
proc sighup_callback(s: cint) =
  echo "SIGHUP ", s

proc sigint_callback(s: cint) =
  if not gonna_quit:
    gonna_quit = true
    echo "Press Ctrl+C again to exit"
  else:
    quit("Quitting...")

register(SIGHUP, sighup_callback)
register(SIGINT, sigint_callback)


echo "Hello"
while true:
  echo "loop"
  discard sleep(3)
