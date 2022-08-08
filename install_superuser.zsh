#!/usr/bin/env zsh

issudoer=1;
platform="undefined";
usrgrps=( $(groups "$USER") );

if [[ "$(uname)" == "Linux" ]] || [[ "$OSTYPE" = "linux-gnu" ]]; then
    platform="linux";
fi;

for group in [ ${usrgrps[@]} ]; do
    if [[ "$group" == "sudo" ]]; then
        issudoer=0;
    fi;
done;

if [[ "$platform" == "linux" ]] && [[ $issudoer -eq 0 ]]; then
    command git &> /dev/null;

    if command git &> /dev/null && test $? -eq 1; then
        echo "git is not installed. Try 'sudo apt install git'";
        exit 1;

    else
        git clone https://github.com/N0083R/Superuser.git && \
        tar -xzvf $HOME/Superuser/superuser-x86_64-linux.tgz && \
        sudo chown root $HOME/superuser && \
        sudo chgrp root $HOME/superuser && \
        sudo chmod 4751 $HOME/superuser && \
        mv $HOME/superuser $HOME/.local/bin/ && \
        sudo rm -rf $HOME/Superuser && \
        clear && \
        superuser actions
    fi;

else
    echo "Either you are not in the sudoers group or your platform isn't supported.";
    exit 1;
fi;
