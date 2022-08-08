#!/usr/bin/env bash

issudoer=1;
platform="undefined";
usergroups=( $(groups "$USER") );

if [[ "$(uname)" == "Linux" ]] || [[ "$OSTYPE" == "linux-gnu" ]]; then
    platform="linux";
fi;

for group in [[ "${usergroups[@]}" ]]; do
    if [[ "$group" == "sudo" ]]; then
        issudoer=0;
    fi;
done;

if [[ "$platform" == "linux" ]] && [[ $issudoer -eq 0 ]]; then
    command git &> /dev/null;

    if [[ $? -eq 1 ]]; then
        echo "git is not installed. Try 'sudo apt install git'";
        exit 1;

    else
        git clone https://github.com/N0083R/Superuser.git && \
        tar -xzvf $HOME/Superuser/superuser-x86_64-linux.tgz && \
        sudo chown root $HOME/superuser && \
        sudo chgrp root $HOME/superuser && \
        sudo chmod 4751 $HOME/superuser && \
        mv $HHOME/superuser $HOME/.local/bin/
        for entry in $(ls /etc/alternatives); do
            if [[ "$entry" != "superuser" ]]; then
                sudo update-alternatives --install /usr/bin/superuser superuser ~/.local/bin/superuser 1 &>/dev/null
            fi
        done
        clear && superuser actions;
    fi;

else
    echo "Either you are not in the sudoers group or your platform isn't supported.";
    exit 1;
fi;
