#!/usr/bin/env bash

# option "do ...?"
# usage: if option "do this?"; then ...
function option() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
        esac
    done
}

if option "Generate ssh key?"; then
    ssh-keygen
    cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
    echo "Your public key is in the clipboard, remember to add it to Github"
fi

if option "configure git?"; then
    gh auth login

    read -p "Enter git username: " gitUser
    read -p "Enter git email: " gitEmail

    git config --global user.name "$gitUser"
    git config --global user.email "$gitEmail"

    git config --global init.defaultBranch main
    git config --global core.editor nano

    git config --list

    # See https://wiki.archlinux.org/title/Git#Configuration

    dbus-send --session --print-reply --dest=org.freedesktop.DBus / \
        org.freedesktop.DBus.GetConnectionUnixProcessID \
        string:org.freedesktop.secrets

    git config --global crendential.helper /usr/lib/git-core/git-credential-libsecret
fi

if option "Add Nano syntax highlighting?"; then
    echo "include /usr/share/nano/*.nanorc" > ~/.nanorc
fi

if option "Setup cups for printing?"; then
    systemctl enable cups
    systemctl start cups
    gio open http://localhost:631
fi
