#!/usr/bin/env bash

hassudo=0
hasalt=0
altsdir=0
haspath=0
alts=

if [[ -d "/etc/alternatives/" ]]; then
    altsdir=1
    alts="$(ls "/etc/alternatives/")"
fi

for usergroup in $(groups "$USER" | cut -d ":" -f 2 | tr -s "[:space:]" "\n"); do
    if [[ "$usergroup" == "sudo" ]]; then
        hassudo=1;
        break;
    fi
done

if [ -f "./superuser-x86_64-linux.tgz" ]; then
    if [[ $hassudo -eq 1 ]]; then
        if [[ -f "./Superuser-main.zip" ]]; then
            unzip "./Superuser-main.zip" && sudo rm -rf "./Superuser-main.zip"
        fi

        sudo chown root ./superuser && sudo chgrp root ./superuser && sudo chmod 4751 ./superuser && \
            mv ./superuser "$HOME"/.local/bin/

        for path in $(echo "$PATH" | tr -s ":" "\n"); do
            if [[ "$path" == "$HOME/.local/bin" ]] || [[ "$path" == "$HOME/.local/bin/" ]]; then
                haspath=1;
                break;
            fi
        done
        
        if [[ "$SHELL" == '/usr/bin/bash' ]] && [[ $haspath -eq 0 ]]; then
            bashrc="$HOME/.bashrc";
            echo -e "\n\nPATH=$PATH:$HOME/.local/bin/" >> "$HOME/.bashrc" && command source "$bashrc"
        
        elif [[ "$SHELL" == '/usr/bin/zsh' ]] && [[ $haspath -eq 0 ]]; then
            zshrc="$HOME/.zshrc";
            echo -e "\n\nPATH=$PATH:$HOME/.local/bin/" >> "$HOME"/.zshrc && command source "$zshrc"
        fi

        if [[ $altsdir -eq 1 ]]; then
            for alternative in "${alts[@]}"; do
                if [ "$alternative" == "superuser" ]; then
                    hasalt=1;
                    break;
                fi
            done
            
            if [[ $hasalt -eq 0 ]]; then
                sudo update-alternatives --install /usr/bin/superuser superuser "$HOME/.local/bin/superuser" 1 &> /dev/null
            fi
        fi

        clear && superuser actions
    fi

else
    echo -en "\n\e[1;31mERROR\e[0m: '\e[1;33msuperuser-x86_64-linux.tgz\e[0m' doesn't exist";
    exit 1;
fi
