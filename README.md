# Setup

Run the command below to download and setup the superuser command line program

``` bash
git clone https://github.com/N0083R/Superuser.git && cd ./Superuser && bash ./setup.sh
```

#### The above commands will clone the Superuser git repository into `current_directory/Superuser`

#### Then, it's going to switch into the Superuser folder and run the `setup.sh` script in a `bash` environment

#### The `setup.sh` script simply unpacks the `.tgz` file, removes it and changes the `owner | group | mode` of the superuser binary file and moves it to a suitable location, preferably `/home/username/.local/bin/`

#### Finally, it then creates an alternative link in `/usr/bin/` to `/home/username/.local/bin/superuser/` as `superuser`, it clears the screen and executes the `superuser` command with the `actions` argument, which is similar to the `--help` argument for most command line programs
