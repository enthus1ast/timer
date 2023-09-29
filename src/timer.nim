import times
import os
import strutils
import terminal
import sound/sound

proc parse(str: string): TimeInterval =
  var intPart: int
  var otherPart: string

  var intPartStr: string
  for ch in str:
    if ch in Digits:
      intPartStr.add ch
    if ch in {'m', 'h', 's'}:
      otherPart = $ch
      break
  intPart = parseInt(intPartStr)
  if otherPart == "s":
    return intPart.seconds
  elif otherPart == "m":
    return intPart.minutes
  elif otherPart == "h":
    return intPart.hours
  else:
    raise newException(ValueError, "Could not parse time")

assert parse("12m") == 12.minutes
assert parse("5m" ) == 5.minutes
assert parse("9s" ) == 9.seconds


proc write(str: string) =
  stdout.write "\r"
  stdout.write " ".repeat(terminalWidth())
  stdout.write "\r"
  stdout.write str
  stdout.flushFile

proc countDown(ti: TimeInterval) =
  var snd = newSoundWithUrl("file://" & getAppDir() / "alarm.ogg")
  var startDate = now()
  # let endDate = startDate + 2.seconds
  let endDate = startDate + ti
  while true:
    let ll = (endDate - startDate) - (now() - startDate) 
    if ll.inSeconds <= 0:
      write("\ndone\n")
      snd.play()
      sleep(5_000)
      break
    else:
      write($ll)
      sleep(500)

try:
  let duration = paramStr(1).parse
  countDown(duration)
except:
  echo getCurrentExceptionMsg()
  echo """
  usage:
    timer 10m
    timer 30s
    timer 1h
  """
