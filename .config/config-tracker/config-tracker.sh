#!/usr/bin/env bash

CONFIG_TRACKER_HOME=~/.config/config-tracker

function invoke_git() {
    /usr/bin/git --git-dir=$CONFIG_TRACKER_HOME/repo --work-tree=$HOME "$@"
}

function custom() {
    invoke_git "$@"
}

source $CONFIG_TRACKER_HOME/packages.sh

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
            echo "  where               Prints the location of the config tracker directory"
            echo "  <git command>       Use any git command and its options"
            echo "  install [pkg-type]  Install packages from package lists"
            echo "                        pkg-type: all | pacman | yay | pipx | npm"
            echo "  save [pkg-type]     Save package lists"
            echo "                        pkg-type: all | pacman | yay | pipx | npm"
            echo "  setup               Interactive system configuration"
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
        where) echo "$CONFIG_TRACKER_HOME" ;;
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
        setup) $CONFIG_TRACKER_HOME/setup.sh ;;
        *) custom "$@" ;;
    esac
}

main "$@"

