#!/usr/bin/env bash

usergroups=( $(groups "$USER") )
hassudo=0
hasalt=0

for ugroup in ${usergroups[@]}; do
    if [[ "$ugroup" == "sudo" ]]; then
        hassudo=1;
        break;
    fi
done

if [ -f "./superuser-x86_64-linux.tgz" ]; then
    if [[ $hassudo -eq 1 ]]; then
        tar -xzvf ./superuser-x86_64-linux.tgz && \
            sudo chown root ./superuser && sudo chgrp root ./superuser && sudo chmod 4751 ./superuser && \
            mv ./superuser $HOME/.local/bin/

        for alternative in $(ls "/etc/alternatives/"); do
            if [ "$alternative" == "superuser" ]; then
                hasalt=1;
                break;
            fi
        done
        
        if [[ $hasalt -eq 0 ]]; then
            sudo update-alternatives --install /usr/bin/superuser superuser "$HOME/.local/bin/superuser" 1 &> /dev/null
        fi

        clear && superuser actions
    fi

else
    echo -en "\n\e[1;31mERROR\e[0m: '\e[1;33msuperuser-x86_64-linux.tgz\e[0m' doesn't exist";
    exit 1;
fi
