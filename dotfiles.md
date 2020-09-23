# dotfiles

From https://www.atlassian.com/git/tutorials/dotfiles. Use a bare git repo to
track, version control and deploy (checkout) your dotfiles. There is no need for
extra tooling or symlinks, and different branches can be used for different
computers.

## Installation

Clone the dotfiles repo, add aliases for commands to work with the local repo,
and don't show untracked files in the status to ignore everything else in
`$HOME`.

```Shell
git clone --bare https://github.com/NarvinSingh/dotfiles $HOME/.dotfiles
alias df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfcf='df checkout -f'
df config --local status.showUntrackedFiles no
```

## Usage

Load dotfiles, overwriting changes in `$HOME`

```Shell
dfcf
```

`df` is `git` for the local dotfiles repo, so you can run any git commands, for
example:

Add a dotfile

```Shell
df add <dotfile>
```

Check status

```Shell
df status
```

Commit changes

```Shell
df commit -m "Added <dotfile>"
```

