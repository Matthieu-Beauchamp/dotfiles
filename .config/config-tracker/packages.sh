#!/usr/bin/env bash

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

