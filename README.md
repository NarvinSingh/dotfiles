Dotfiles Bare Repo
==================

See [How to store dotfiles](https://www.atlassian.com/git/tutorials/dotfiles).

Use a bare git repo to track, version control and deploy (checkout) your
dotfiles. There is no need for extra tooling or symlinks, and different
branches can be used for different computers.

Installation
------------

1. Clone the dotfiles repo.
2. Add aliases for commands to work with the local repo.
3. Don't show untracked files in `git status` to ignore everything else in
   the work tree.

```Shell
git clone --bare https://github.com/NarvinSingh/dotfiles $HOME/.config/dotfiles
alias cfg='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/.config'
alias cfgc='cfg checkout -f'
cfg config --local status.showUntrackedFiles no
```

Usage
-----

### Load dotfiles

This will overwrite the dotfiles in the work tree.

```Shell
cfgc
```

### Run git commands

Use the `cfg` alias in place of `git` to maintian the dotfiles repo,
for example:

#### Add a dotfile

```Shell
cfg add <dotfile>
```

#### Check status

```Shell
cfg status
```

#### Commit changes

```Shell
cfg commit -m "Added <dotfile>"
```

