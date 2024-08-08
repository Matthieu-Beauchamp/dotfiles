#! /bin/env bash

# https://www.atlassian.com/git/tutorials/dotfiles

# Note that to use X11 instead of Wayland (ie to be able to screenshare),
# we must set `WaylandEnable=false` in /etc/gdm/custom.conf

function invoke_git() {
    /usr/bin/git --git-dir=$CONFIG_TRACKER_HOME/repo --work-tree=$HOME "$@"
}

function config_files() {
    # Rooted at $HOME/
    configFiles=(
        .bashrc
        .bash_profile
        bin/.bashrc_extra.sh

        .clang-format

        .vimrc
        .config/vim-configs
        .config/nvim
        .config/lvim

        .config/kitty
        .config/terminator
        .config/qterminal.org
        .config/powerline

        .config/starship.toml
        .config/synth-shell

        .config/arch-gnome-setup

        "$CONFIG_TRACKER_HOME/config-tracker.sh"
    )

    for f in "${configFiles[@]}"; do
        echo "$f"
    done
}

function init() {
    if [ -n "$CONFIG_TRACKER_HOME" ]; then
        echo "config-tracker seems to be already configured with repo in $CONFIG_TRACKER_HOME. Cancelling"
        echo "Clean the following lines from your ~/.bashrc and restart your shell"
        grep config-tracker.sh --line-number < "$HOME/.bashrc" 
        grep CONFIG_TRACKER_HOME --line-number < "$HOME/.bashrc" 
        exit 1
    fi

    {
    echo "" 
    echo "# config-tracker ##################################"
    echo "export CONFIG_TRACKER_HOME=$1"
    echo "alias config-tracker='$1/config-tracker.sh'"
    } >> "$HOME/.bashrc"

    mkdir -p "$1"
    git init --bare "$1/repo"
    mv "${BASH_SOURCE[0]}" "$1/"

    CONFIG_TRACKER_HOME=$1
    invoke_git config --local status.showUntrackedFiles no

    echo "Initialized config tracker to use repository in $1/repo"
    echo "Initialized config tracker script in $1/config-tracker.sh"
    echo "Restart your shell"
}

function update() {
    for f in $(config_files); do
        invoke_git add "$f"
    done

    if [ -n "$1" ]; then
        invoke_git commit -m "$1"
    else 
        invoke_git commit
    fi

    invoke_git push
}

function restore() {
    invoke_git pull
}

function custom(){
    invoke_git "$@"
}

case $1 in
    -h | --help) 
        echo "Usage: config-tracker [cmd] [options...]"
        echo "cmd can be:"
        echo "  init [dir]      Initialize the config tracker repository in dir or .config/config-tracker"
        echo "  edit [editor]   Edit this script with the provided editor or the git configured editor"
        echo "  update [msg]    Commit and push changes to tracked files with commit message msg if provided"
        echo "  restore         Pull configuration"
        echo "  <git command>   Use any git command and its options"
        ;;
    init) 
        shift
        if [ $# == 1 ]; then
            init "$1"
        else
            init ~/.config/config-tracker
        fi
        ;;
    edit) 
        shift
        if [ $# == 1 ]; then
            "$1" "${BASH_SOURCE[0]}"
        else
            $(git config core.editor) "${BASH_SOURCE[0]}"
        fi
        ;;
    update) update "$2";;
    restore) restore;;
    *) custom "$@";;
esac

