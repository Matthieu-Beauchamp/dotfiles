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

# SSH ########################################

# https://wiki.archlinux.org/title/SSH_keys#SSH_agents
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# https://wiki.archlinux.org/title/GNOME/Keyring#SSH_keys
#   if service is enabled
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gcr/ssh"

# Alias ###################################

alias ll='ls -l'
alias la='ls -a'

# Bash completion #########################

completionPath=/usr/shared/git/completion/git-completion.bash
if [[ -f $completionPath ]]; then
    source $completionPath
fi
unset completionPath

# PATH #####################################

function addToPath() {
    [[ ":$PATH:" != *":$1:"* ]] && PATH="${PATH}:$1"
}

addToPath "~/.local/bin"
addToPath "~/.local/share/Jetbrains/Toolbox/scripts"
addToPath "~/.local/share/JetBrains/Toolbox/bin"

# Starship #############################################
eval "$(starship init bash)"

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
            gio open $polyCours/TODO.ods ;;

        c) cd $polyCours/$arg ;;
        p) cd $polyProjets/$arg ;;
    esac
}

# Load Angular CLI autocompletion.

source <(ng completion script)

# config-tracker ##################################
alias config-tracker='~/.config/config-tracker/config-tracker.sh'

