import std/[os, strformat]

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

proc Open*(Open: string = "", Read: string = "", Write: string = "", Append: string = ""): void =
  var
    fileContents: string
    newfile: File

  if Open.len == 0 and Read.len > 0 and Write.len == 0 and Append.len == 0:
    if fileExists(expandTilde(Read)):
      fileContents = readFile(expandTilde(Read))
      stdout.write(fileContents)
      stdout.flushFile
      quit(0)

    else:
      stderr.writeLine("\n{red}ERROR{reset}: {yellow}the file{reset} '{green}{Read}{reset}' {yellow}doesn't exist{reset}\n".fmt)
      stderr.flushFile
      quit(1)

  elif Open.len > 0 and Read.len == 0 and Write.len == 0 and Append.len > 0:
    if fileExists(expandTilde(Open)):
      newfile = open(expandTilde(Open), fmAppend)
      newfile.write(Append)
      newfile.close()
      quit(0)

    else:
      stderr.writeLine("\n{red}ERROR{reset}: {yellow}the file{reset} '{green}{Open}{reset}' {yellow}doesn't exist{reset}\n".fmt)
      stderr.flushFile
      quit(1)

  elif Open.len > 0 and Read.len == 0 and Write.len > 0 and Append.len == 0:
    newfile = open(expandTilde(Open), fmWrite)
    newfile.write(Write)
    newfile.close()
    quit(0)

  elif Open.len == 0 and Read.len > 0 and Write.len > 0 and Append.len == 0:
    if fileExists(expandTilde(Read)):
      fileContents = readFile(expandTilde(Read))
      newfile = open(expandTilde(Write), fmWrite)
      newfile.write(fileContents)
      newfile.close()
      quit(0)

    else:
      stderr.writeLine("\n{red}ERROR{reset}: {yellow}the file{reset} '{green}{Read}{reset}' {yellow}doesn't exist{reset}\n".fmt)
      stderr.flushFile
      quit(1)

  else:
    stderr.writeLine("\n{red}ERROR{reset}: {yellow}an unexpected error occured{reset}\n".fmt)
    stderr.flushFile
    quit(1)

setControlCHook(sigintHandler)
