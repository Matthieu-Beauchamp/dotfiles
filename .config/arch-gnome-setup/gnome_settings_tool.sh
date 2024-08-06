#! /bin/env bash

# Gnome settings recording ########################################

# see https://askubuntu.com/a/746262

case "$1" in
	dump)
		printf -v date '%(%Y-%m-%d)T' -1 # held in date variable. https://stackoverflow.com/a/1401495
	        backupSettings="$(pwd)/gnome-settings-$date.dconf"
        	dconf dump / > "$backupSettings"
		echo "Saved current settings in $backupSettings"
		;;
  	load)
		settingsFile="$(pwd)/$2"
		echo "Loading settings from $settingsFile"
        	dconf load / < "$settingsFile"
		;;
	watch)
		dconf watch /
		;;
esac
