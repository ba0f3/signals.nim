signals
========

```
nimble install signals
```

> a small helper for unix signals handling

### Usage

Create a file named example.nim with source code bellow:
```nim
import posix, signals

proc sighup_callback(s: cint) =
  echo "SIGHUP triggered"
  
var gonna_quit = false
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
```

Complie and run it:
```shell
nim c -r example
```

Open another terminal, and try to kill it w/ SIGHUP and SIGINT (or press Ctrl+C on its own terminal)
```shell
pkill -HUP example
pkill -INT example
```
