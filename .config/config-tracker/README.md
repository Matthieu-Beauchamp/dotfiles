# config-tracker

Allows tracking dotfiles with Git by using a bare repository. The repository should reside in `~/.config/config-tracker/repo` and use a work-tree rooted at `~`.

Based on https://www.atlassian.com/git/tutorials/dotfiles

## Installing on a new machine

```sh
git clone --bare git@github.com:Matthieu-Beauchamp/dotfiles.git ~/.config/config-tracker/repo
alias config-tracker='/usr/bin/git --git-dir=~/.config/config-tracker/repo --work-tree=~'
config-tracker checkout
```

Some files may conflict (`.bashrc`, ...), delete or rename them (`.bashrc.bak`, ...)

Make sure your `.bashrc` contains the following
```sh
alias config-tracker='~/.config/config-tracker/config-tracker.sh'
```

## Usage



### 

