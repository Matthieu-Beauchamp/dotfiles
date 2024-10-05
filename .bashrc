# THIS FILE MAY BE OVERWRITTEN BY THE ArchGnomeSetup INSTALL SCRIPT
# MODIFY ~/bin/.bashrc_extra.sh INSTEAD
# 
# Arch-Linux default #########################
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Personal ###################################

# extra code to run on shell startup.
if [[ -f ~/bin/.bashrc_extra.sh ]]; then
    source ~/bin/.bashrc_extra.sh
fi

# https://wiki.archlinux.org/title/GNOME/Keyring#SSH_keys
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gcr/ssh"

alias ll='ls -l'
alias la='ls -a'

completionPath=/usr/shared/git/completion/git-completion.bash
if [[ -f $completionPath ]]; then
    source $completionPath
fi
unset completionPath

function addToPath() {
    [[ ":$PATH:" != *":$1:"* ]] && PATH="${PATH}:$1"
}

addToPath "~/.local/bin"
addToPath "~/.local/share/Jetbrains/Toolbox/scripts"
addToPath "~/.local/share/JetBrains/Toolbox/bin"

# Synth-shell #########################################
synthShellRoot=~/.config/synth-shell

##-----------------------------------------------------
## synth-shell-greeter.sh
if [ -f $synthShellRoot/synth-shell-greeter.sh ] && [ -n "$(echo $- | grep i)" ]; then
#    source $synthShellRoot/synth-shell-greeter.sh
    alias greet='source $synthShellRoot/synth-shell-greeter.sh'
fi

##-----------------------------------------------------
## alias
if [ -f $synthShellRoot/alias.sh ] && [ -n "$(echo $- | grep i)" ]; then
    source $synthShellRoot/alias.sh
fi

# Starship #############################################
eval "$(starship init bash)"

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

# Poly #############################################

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

# Load Angular CLI autocompletion.
source <(ng completion script)

# config-tracker ##################################
export CONFIG_TRACKER_HOME=/home/matthieu/.config/config-tracker
alias config-tracker='/home/matthieu/.config/config-tracker/config-tracker.sh'

