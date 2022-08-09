import std/[os, strutils, strformat]

proc sigintHandler() {.noconv.} =
  stdout.writeLine("\u001b[2K")
  stdout.flushFile
  quit(0)

const
  red: string = "\e[1;31m"
  green: string = "\e[1;32m"
  yellow: string = "\e[1;33m"
  blue: string = "\e[1;34m"
  magenta: string = "\e[1;35m"
  cyan: string = "\e[1;36m"
  reset: string = "\e[0m"

proc EntryInfo*(entry: string): void =
  var
    info: FileInfo
    str: string
    size: string
    tmp: seq[string]

  try:
    info = getFileInfo(expandTilde(entry), followSymlink = false)

  except OSError:
    stderr.writeLine("\n", red, "ERROR", reset, ": ", "'", blue, entry, reset, "'", yellow, " is not a valid file or directory", reset)
    stderr.flushFile
    quit(1)

  size = "{info.size.float / 1000:.1f}KB".fmt
  tmp = expandTilde(entry).split("/")

  str.add([pcFile: '-', 'l', pcDir: 'd', 'l'][info.kind])

  for pos, perm in [fpUserRead, fpUserWrite, fpUserExec, fpGroupRead, fpGroupWrite, fpGroupExec, fpOthersRead, fpOthersWrite, fpOthersExec]:
    str.add(if perm in info.permissions: "rwx"[pos mod 3] else: '-')

  for val in 0 .. tmp.len:
    try:
      if tmp[val] == "" or tmp[val] == " ":
        tmp.delete(val)

    except IndexDefect:
      break

  stdout.writeLine("\nEntry Info:\n‾‾‾‾‾‾‾‾‾‾\n")
  stdout.writeLine("Entry: {tmp[^1]}".fmt)
  stdout.writeLine(" Type: <", if info.kind == pcDir: "Directory>" else: "File>")
  stdout.writeLine(" Permissions: {str}".fmt)
  stdout.writeLine(" Size: {size}".fmt)
  stdout.flushFile
  quit(0)

setControlCHook(sigintHandler)
