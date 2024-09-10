#!/usr/bin/env bash

function sdocker() {
    sudo docker $@
}

function dockerrun() {
    sdocker run -it --rm $@
}

function dockerarch() {
    dockerrun archlinux /usr/bin/bash
}

function pgadmin() {
    dockerrun \
        -e PGADMIN_DEFAULT_EMAIL=matthieu.beauchamp-boulay@polymtl.ca \
        -e PGADMIN_DEFAULT_PASSWORD=postgresql \
        -e PGADMIN_LISTEN_ADDRESS=127.0.0.1 \
        -e PGADMIN_LISTEN_PORT=5432 \
        dpage/pgadmin4 pgadmin
}

function poly() {

	polyBasePath=~/Documents
	polySession=A24

	polyCours=$polyBasePath/Poly/$polySession
	polyProjets=$polyBasePath/PolyProjets/$polySession

	nArgs=$#

	if [[ $nArgs -ne 1 && $nArgs -ne 2 ]]; then
		echo "incorrect number of arguments" && return -1
	fi

	cmd=$1
	arg=$2

	case $cmd in
		todo) # gio open obsidian://open?vault=PolyH24 ;;
			gio open $polyCours/TODO.ods;;

		c) cd $polyCours/$arg;;
		p) cd $polyProjets/$arg;;
	esac
}
