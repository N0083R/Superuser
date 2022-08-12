# Superuser Setup

Run the command below to download and setup the superuser command line program

``` bash
git clone https://github.com/N0083R/Superuser.git && cd ./Superuser && bash ./setup.sh
```
<hr>

## What Does *setup.sh* Do?
1. Firstly, the ***setup.sh*** script simply decompresses the **superuser-x86_64-linux.tgz** compressed file and removes it. Then changes the ***owner***, ***group***, and ***mode*** of the **superuser** binary file which is then moved into a suitable location, preferably */home/username/.local/bin/*. If */home/username/.local/bin/* isn't on the PATH, then it is added to the PATH.

2. Lastly, if an alternative link to superuser doesn't already exist, then an alternative link to **/home/username/.local/bin/superuser** is created in **/usr/bin/** as **/usr/bin/superuser**. The terminal screen is cleared and `superuser actions` is then executed. The `actions` argument is similar to the  `--help` argument associated with other command line programs.
<hr>

## The Purpose of This Program
It started out as a filesystem search program called `susrch` (super search), which I'd created for myself to replace the common **find** command in Linux. I wanted it to be simple, intuitive and have the ability to search the entire filesystem by default. As I continued to work on the program, it sort of became a swiss army knife in the sense of its capabilities. It combines the functionality of some of the more common cammand line programs that already exist on Linux, for example: `echo`, `cat`, `touch`, `ls`, etc. Though, it may seem as if I'm trying to reinvent the wheel, but sometimes it can be useful to have one command that can do the job of many even if such jobs are simple. This is why I renamed the program to **superuser**, because I found that this program may be of best use for an Administrator or those that have a decent understanding of Linux.
