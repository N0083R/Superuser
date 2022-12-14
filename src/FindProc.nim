import std/[os, strutils, strformat, times, terminal]

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

proc Find*(name: string = "", use: string = "/", mode: string = "strict", limit: int = 0, Write: string = "") {.noReturn.} =
  var
    dirsFound: seq[string]
    filesFound: seq[string]
    file: File
    startTime: float
    endTime: string
    info: PathComponent
    entryDirName: string
    entryFileName: string
    strictDirName: string
    passiveDirName: string
    strictFileName: string
    passiveFileName: string
    counter: int
    dot: string = "."

  if name != "" and name.startsWith("/") or name.endsWith("/"):
    stderr.writeLine("\n{red}ERROR{reset}: {yellow}found leading or trailing{reset} '{red}/{reset}'\n".fmt)
    stderr.flushFile
    quit(1)

  if Write.len > 0:
    if fileExists(expandTilde("./"&Write)):
      file = open(expandTilde("./"&Write), fmAppend)

    else:
      file = open(expandTilde("./"&Write), fmWrite)


  stdout.hideCursor()
  startTime = cpuTime()

  for entry in walkDirRec(expandTilde(use), yieldFilter={pcFile, pcDir, pcLinkToFile, pcLinkToDir}, relative = false, checkdir = false):
    stdout.writeLine("{yellow}Searching for{reset} '{blue}{name}{reset}': {blue}{dot}{reset}".fmt)
    stdout.flushFile
    cursorUp(1)
    dot &= "."

    if dot.len == 21:
      dot = "."
      eraseLine()

    try:
      info = getFileInfo(expandTilde(entry), followSymlink = false).kind
      entryDirName = "{entry}/".fmt
      strictDirName = "/{name}/".fmt
      passiveDirName = "/{name}".fmt
      entryFileName = entry
      strictFileName = "/{name}".fmt
      passiveFileName = "{name}".fmt

      if info == pcDir:
        if (mode == "strict" and entryDirName.endsWith(strictDirName)) or (mode == "passive" and entryDirName.contains(passiveDirName)):
          counter.inc()
          dirsFound.add(entry)
          if Write.len > 0:
            var tempname: string = entry & "/\n"
            stdout.writeLine("\n{yellow}Writing{reset}{red}!{reset}".fmt)
            file.write(tempname)
            cursorUp(1)
            eraseLine()
            cursorUp(1)

          else:
            stdout.writeLine("<", blue, "Folder", reset, "> ", green, "Path", reset, ": ", blue, entry & "/", reset, "\n")
            stdout.flushFile

          if limit > 0 and counter == limit:
            break

      elif info == pcLinkToDir:
        if (mode == "strict" and entryDirName.endsWith(strictDirName)) or (mode == "passive" and entryDirName.contains(passiveDirName)):
          counter.inc()
          dirsFound.add(entry)
          if Write.len > 0:
            var tempname: string = entry & "/\n"
            stdout.writeLine("\n{yellow}Writing{reset}{red}!{reset}".fmt)
            file.write(tempname)
            cursorUp(1)
            eraseLine()
            cursorUp(1)

          else:
            stdout.writeLine("<", blue, "Symlink->Folder", reset, "> ", green, "Path", reset, ": ", blue, entry & "/", reset, "\n")
            stdout.flushFile

          if limit > 0 and counter == limit:
            break

      elif info == pcFile:
        if (mode == "strict" and entryFileName.endsWith(strictFileName)) or (mode == "passive" and entryFileName.contains(passiveFileName)):
          counter.inc()
          filesFound.add(entry)
          if Write.len > 0:
            var tempname: string = entry & "\n"
            stdout.writeLine("\n{yellow}Writing{reset}{red}!{reset}".fmt)
            file.write(tempname)
            cursorUp(1)
            eraseLine()
            cursorUp(1)

          else:
            stdout.writeLine("<", blue, "File", reset, "> ", green, "Path", reset, ": ", blue, entry, reset, "\n")
            stdout.flushFile

          if limit > 0 and counter == limit:
            break

      elif info == pcLinkToFile:
        if (mode == "strict" and entryFileName.endsWith(strictFileName)) or (mode == "passive" and entryFileName.contains(passiveFileName)):
          counter.inc()
          filesFound.add(entry)
          if Write.len > 0:
            var tempname: string = entry & "\n"
            stdout.writeLine("\n{yellow}Writing{reset}{red}!{reset}".fmt)
            file.write(tempname)
            cursorUp(1)
            eraseLine()
            cursorUp(1)

          else:
            stdout.writeLine("<", blue, "Symlink->File", reset, "> ", green, "Path", reset, ": ", blue, entry, reset, "\n")
            stdout.flushFile

          if limit > 0 and counter == limit:
            break

    except OSError:
      continue

  endTime = "{cpuTime() - startTime:.2f}".fmt
  eraseLine()
  stdout.styledWriteLine("{yellow}Searching{reset}: {green}Done!{reset}".fmt)
  cursorUp(1)

  var found: string = intToStr(dirsFound.len + filesFound.len)
  if Write.len > 0:
    file.close()

    if parseInt(found) > 0:
      stdout.writeLine("\n{yellow}Writing{reset}: {green}Done!{reset}".fmt)
      cursorUp(2)
      sleep(2000)
      eraseLine()

    elif parseInt(found) == 0:
      var tempname: string = "./" & Write

      if readFile(expandTilde(tempname)).len == 0:
        removeFile(tempname)

    stdout.writeLine("\n{green}Wrote{reset} {cyan}{found}{reset} paths to '{yellow}{Write}{reset}' in {green}{endTime}{reset} seconds".fmt)
    stdout.flushFile

  else:
    sleep(2000)
    eraseLine()
    stdout.writeLine("\n{green}Found{reset} {cyan}{found}{reset} paths in {green}{endTime}{reset} seconds".fmt)
    stdout.flushFile

  stdout.showCursor()
  quit(0)

setControlCHook(sigintHandler)
