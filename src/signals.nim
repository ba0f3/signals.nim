import posix, tables

type SignalCallback = proc (signal: cint)
var handlers = newTable[cint, seq[SignalCallback]]()

proc signalHandler(signal: cint) {.noconv.} =
  if handlers.hasKey(signal):
    for cb in handlers[signal]:
      cb(signal)

var sa: Sigaction
sa.sa_handler = signalHandler
sa.sa_flags = SA_RESTART
discard sigfillset(sa.sa_mask)

proc register*(signal: cint, cb: SignalCallback) =
  if not handlers.hasKey(signal):
    handlers[signal] = @[]
    discard sigaction(signal.cint, sa)

  if not handlers[signal].contains(cb):
    handlers[signal].add(cb)

proc unregister(signal: cint, cb: SignalCallback) =
  if not handlers.hasKey(signal):
    return

  for i in 0..<handlers[signal].len:
    if handlers[signal][i.cint] == cb:
      handlers[signal].delete(i.int)
      break


proc unregister(signal: cint) =
  if handlers.hasKey(signal):
    handlers.del(signal)
