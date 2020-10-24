User-Specific Configuration Files Repo
======================================

See [How to store dotfiles](https://www.atlassian.com/git/tutorials/dotfiles).

Create a git repo in the XDG base directory `$HOME/.config` to track, version
control and deploy (checkout) your user-specific configuration. There is no
need for extra tooling or symlinks, and different branches can be used for
different computers.

All of the applications for which you want to track configuration files must
store their configuration files in `$HOME/.config`. Otherwise, a bare repo
in `$HOME` can be used to track files relative to `$HOME`. In that case, an
alias for git that sets `--git-dir` to the repo directory and `--work-tree`
to `$HOME` could then be used to manage the repo. For example:

```Shell
git clone --bare https://github.com/NarvinSingh/dotfiles "${HOME}"/.dotfiles
alias cfg='/usr/bin/git --git-dir ${HOME}/.dotfiles --work-tree ${HOME}'
cfg add <dotfile>
cfg status
cfg commit -m "Added <dotfile>"
```

Installation
------------

1. Clone the dotfiles repo into `$HOME/.config`.
2. Don't show untracked files in `git status` to ignore everything else in
   `$HOME/.config`.

```Shell
git clone https://github.com/NarvinSingh/dotfiles "${HOME}"/.config
cd  "${HOME}"/.config
git config --local status.showUntrackedFiles no
```

Usage
-----

### Load config files

This will overwrite the files if they exist in `$HOME\.config`.

```Shell
git checkout -f
```

### Add a config file

```Shell
git add <dotfile>
```

### Check status

Untracked files will not be shown.

```Shell
git status
```

### Commit changes

```Shell
git commit -m "Added <dotfile>"
```

