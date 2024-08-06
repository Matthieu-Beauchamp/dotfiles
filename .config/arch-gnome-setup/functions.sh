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


# Pacman and AUR wrapper #####################

function pac() {
    cmd=$1
    args=${@:2}

    case $cmd in
    get) sudo pacman -S $args ;;
    update) sudo pacman -Syu ;;
    remove) sudo pacman -Rns $args ;;
    esac
}

# aur <cmd> <arg>
#
# cmd:
#   get: install the AUR package with git url $arg
#
#   update/update-checked: if $arg is "all" then update all AUR packages,
#                          else update AUR package with name $arg if it exists.
#                          The checked variant allows checking git diffs and canceling update.
#
#   remove: remove the AUR package with name $arg
#
function aur() {
    aurDir=~/.aur-packages
    if [[ ! -d $aurDir ]]; then
        mkdir $aurDir
    fi

    cmd=$1
    arg=$2

    local curDir=$(pwd -P)
    cd $aurDir

    case $cmd in
    get)
        git clone $arg

        pkgName=${arg##*/}
        pkgName=${pkgName%.git}
        cd $pkgName

        if option "Inspect PKGBUILD?"; then
            less PKGBUILD

            if ! option "Continue building?"; then
                cd $curDir
                return 0
            fi
        fi

        makepkg --syncdeps --install --clean --rmdeps
        git clean -dfx
        ;;
    update-checked)
        if [[ "$arg" == "all" ]]; then
            for d in ./*; do
                if [[ -d $d ]]; then
                    echo "Updating ${d#*/}"
                    aur update-checked "$d"
                fi
            done
        else
            cd $arg
            oldCommit=$(git rev-parse --verify HEAD)
            git pull
            newCommit=$(git rev-parse --verify HEAD)

            if [[ $oldCommit != $newCommit ]]; then
                if option "Inspect diff?"; then
                    git diff $oldCommit

                    if ! option "Continue building?"; then
                        cd $curDir
                        return 0
                    fi
                fi

                makepkg --syncdeps --install --clean --rmdeps
                git clean -dfx
            fi
        fi
        ;;
    update)
        if [[ "$arg" == "all" ]]; then
            for d in ./*; do
                if [[ -d $d ]]; then
                    echo "Updating ${d#*/}"
                    aur update "$d"
                fi
            done
        else
            cd $arg
            oldCommit=$(git rev-parse --verify HEAD)
            git pull
            newCommit=$(git rev-parse --verify HEAD)

            if [[ $oldCommit != $newCommit ]]; then
                makepkg --syncdeps --install --clean --rmdeps
                git clean -dfx
            fi
        fi
        ;;
    remove)
        if option "Force remove everything under $aurDir/$arg ?"; then
            rm -rf $arg
        fi

        pac remove $arg
        ;;
    esac

    cd $curDir
}
