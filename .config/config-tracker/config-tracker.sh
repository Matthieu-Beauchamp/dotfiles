#! /bin/env bash

CONFIG_TRACKER_HOME=~/.config/config-tracker

function invoke_git() {
    /usr/bin/git --git-dir=$CONFIG_TRACKER_HOME/repo --work-tree=$HOME "$@"
}

function custom() {
    invoke_git "$@"
}

# packages #########################

function banner-exec() {
    echo
    echo "############################################################"
    echo "## $1"
    echo "############################################################"
    echo
    $1
}

function save-all() {
    banner-exec save-pacman
    banner-exec save-yay
    banner-exec save-npm
    banner-exec save-pipx
}

function install-all() {
    banner-exec install-pacman
    banner-exec install-yay
    banner-exec install-npm
    banner-exec install-pipx
}

function save-pacman() {
    pacman -Q --quiet --explicit --native > $CONFIG_TRACKER_HOME/pacman.pkglist
}
function install-pacman() {
    sudo pacman -S - < $CONFIG_TRACKER_HOME/pacman.pkglist
}

function save-yay() {
    pacman -Q --quiet --explicit --foreign > $CONFIG_TRACKER_HOME/yay.pkglist
}
function install-yay() {
    yay -S - < $CONFIG_TRACKER_HOME/yay.pkglist
}

function save-npm() {
    # Do not use for installing, some are handled by pacman
    npm list -g --depth=0 --json | jq '.dependencies | keys | .[]' > $CONFIG_TRACKER_HOME/npm.pkglist
}
function install-npm() {
    xargs sudo npm -g install < $CONFIG_TRACKER_HOME/npm.pkglist
}

function save-pipx() {
    pipx list --short | sed 's/\([^ ]*\).*/\1/' > $CONFIG_TRACKER_HOME/pipx.pkglist
}
function install-pipx() {
    xargs pipx install < $CONFIG_TRACKER_HOME/pipx.pkglist
}


function main() {
    if [ $# == 0 ]; then
        main --help
        exit
    fi

    case $1 in
        -h | --help)
            echo "Usage: config-tracker [cmd] [options...]"
            echo "cmd can be:"
            echo "  edit [editor]       Edit this script with the provided editor or the git configured editor"
            echo "  <git command>       Use any git command and its options"
            echo "  install [pkg-type]  Install packages from package lists"
            echo "                        pkg-type: all | pacman | yay | pipx | npm"
            echo "  save [pkg-type]     Save package lists"
            echo "                        pkg-type: all | pacman | yay | pipx | npm"
            exit
            ;;
        edit)
            shift
            if [ $# == 1 ]; then
                "$1" "${BASH_SOURCE[0]}"
            else
                $(git config core.editor) "${BASH_SOURCE[0]}"
            fi
            ;;
        save)
            shift
            if [ $# == 0 ]; then
                main save all
            fi

            case $1 in
                all) save-all ;;
                pacman) save-pacman ;;
                yay) save-yay ;;
                npm) save-npm ;;
                pipx) save-pipx ;;
            esac
            ;;
        install)
            shift
            if [ $# == 0 ]; then
                main install all
            fi

            case $1 in
                all) install-all ;;
                pacman) install-pacman ;;
                yay) install-yay ;;
                npm) install-npm ;;
                pipx) install-pipx ;;
            esac
            ;;
        *) custom "$@" ;;
    esac
}

main "$@"

