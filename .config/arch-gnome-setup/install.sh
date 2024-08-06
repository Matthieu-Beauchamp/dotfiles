#!/bin/env bash

# Currently, Arch should be properly setup with GNOME installed.
# see https://wiki.archlinux.org/title/Installation_guide
# and (for gnome) https://itsfoss.com/install-arch-linux/

# This should not be run as root,
# otherwise the user's home directory will not be properly setup


# This script works in tandem with the config-tracker that stores all
# configuration files in a git repo and is able to install them all.
# This script is meant for package installation and system configuration.

# https://stackoverflow.com/a/246128
scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $scriptDir/functions.sh

# Current wallpaper:
# https://initiate.alphacoders.com/images/133/cropped-1920-1080-1330761.png?dl=1
# For backups / restoring
pac get timeshift

# Requirements ################################################################

# gvim required for shared clipboard: https://vi.stackexchange.com/a/3078
pac get gvim git curl


# git config ##################################################################
pac get lazygit
if option "configure git?"; then
	pac get github-cli
	gh auth login

	git config --global core.editor "vim"
	read -p "Enter git username: " gitUser
	read -p "Enter git email: " gitEmail
	git config --global user.name "$gitUser"
	git config --global user.email "$gitEmail"
	git config --global init.defaultBranch main
	git config --list


	# See 4.11: https://wiki.archlinux.org/title/Git#Configuration
	pac get gnome-keyring libsecret

	dbus-send --session --print-reply --dest=org.freedesktop.DBus / \
    		org.freedesktop.DBus.GetConnectionUnixProcessID \
    		string:org.freedesktop.secrets

	git config --global crendential.helper /usr/lib/git-core/git-credential-libsecret
fi


# console environnement #######################################################

pac get nano nano-syntax-highlighting
echo "include /usr/share/nano/*.nanorc" > ~/.nanorc

pac get bash-completion
pac get ttf-firacode-nerd # For starship

# Install vim-plug
mkdir -p ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Setup starship
pac get starship

if option "Install synth-shell?"; then
	pac get bc
	git clone --recursive https://github.com/andresgongora/synth-shell.git
	chmod +x synth-shell/setup.sh
	cd synth-shell
	./setup.sh
	cd .. && rm -rf synth-shell
fi

# Gives the dracula theme: https://draculatheme.com/terminator
pac get terminator

pac get qterminal
dracula="Dracula.colorscheme"
curl https://github.com/dracula/qterminal/blob/main/$dracula \
    > /usr/share/qtermwidget5/color-schemes/$dracula
unset dracula

# Terminal startup scripts
mkdir -p ~/.local/bin


# languages  #######################################################

pac get gcc clang cmake python 

pac get perf gdb lcov valgrind doxygen
aur get hotspot https://aur.archlinux.org/hotspot.git

pac get nodejs-lts-hydrogen npm

pac get texlive perl-yaml-tiny perl-file-homedir


# ide #############################################################

pac get neovim python-pynvim wl-clipboard
pac get ripgrep

if option "Install vscode?"; then
	pac get base-devel
	aur get visual-studio-code-bin https://aur.archlinux.org/visual-studio-code-bin.git
	aur get code-features https://aur.archlinux.org/code-features.git
	echo "Opening code, login and enable settings-sync"
	code &
fi


# jetbrains toolbox

pac get fuse2
curl https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.0.2.16660.tar.gz > toolbox.tar.gz
tar -xf toolbox.tar.gz && rm toolbox.tar.gz
cd jetbrains-toolbox* && ./jetbrains-toolbox && cd .. && rm -rf jetbrains-toolbox*


# Misc apps ######################################################

pac get tree zip unzip
pac get firefox discord spotify-launcher obsidian
pac get pinta gparted thunderbird libreoffice-still

mkdir ~/Downloads
if option "Set firefox download directory?"; then
	firefox --preferences
fi

if option "Setup thunderbird?"; then
	thunderbird;
fi


# printing #######################################################

# https://bbs.archlinux.org/viewtopic.php?id=165667
pac get cups cups-pdf
systemctl start cups
systemctl enable cups

# driver
aur get brother-mfc-9340cdw https://aur.archlinux.org/brother-mfc-9340cdw.git

# add printer manually since gnome fails
firefox http://localhost:631


# audio ##########################################################

pac get alsa-firmware alsa-utils sof-firmware


# grub ###########################################################

if option "Update grub entries?"; then
	pac get os-prober
	sudo cat $scriptDir/grub > /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
fi


# Gnome extensions ################################################

# see https://linux.m2osw.com/transform-gnome-settings-command-lines?page=1

pac get gettext glib2 gnome-tweaks gnome-shell dconf

if option "Install gnome user theme?"; then
	mkdir -p ~/.themes
	git clone https://github.com/vinceliuice/Orchis-theme
	cd Orchis-theme
	./install.sh -d ~/.themes -t purple -c dark -s compact -l --tweaks macos dracula
	cd .. && rm -rf Orchis-theme
	echo "You may need to manually enable user themes in gnome-extensions-app"
fi

# if needed to add more applications to be blurred,
# open the gnome extensions app,
# > blur-my-shell > applications > whitelist
# open the application to be blurred,
# use ctrl+F2 and type 'lg' (looking glass)
# move to the windows widget, click on the title of the window,
# scroll to the bottom to find the wm_class property
# this works for X11 and Wayland backends unlike 'xprop | grep WM_CLASS'
aur get gnome-shell-extension-blur-my-shell https://aur.archlinux.org/gnome-shell-extension-blur-my-shell.git

aur get gnome-shell-extension-tiling-assistant https://aur.archlinux.org/gnome-shell-extension-tiling-assistant.git
aur get gnome-shell-extension-no-overview https://aur.archlinux.org/gnome-shell-extension-no-overview.git

