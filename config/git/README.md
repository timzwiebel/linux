# Git

[TOC]


## Install
> IMPORTANT: The `.gitconfig` file in this repository uses my name/email
> address. You should use your own name/email address.

```shell
ln -s linux/config/git/.gitconfig .gitconfig
```

> TIP: If you already have a `.gitconfig` file and you want to use parts of your
> git config conditionally (e.g., enable some aliases only in a particular
> repository), then you can split the config file into pieces and use
> `[includeIf]` sections
> ([examples](https://git-scm.com/docs/git-config#_example)).


## Configuration
Git settings are stored in `.gitconfig`. These are some of the basic ones:
```
[core]
  editor = vim

[init]
  defaultBranch = main

[user]
  email = john.doe@gmail.com
  name = John Doe
```


## SSH
SSH can be used for both signing your commits as well as authenticating with
remote repositories.

### Signing commits
`.gitconfig`:
```
[commit]
  gpgSign = true

[gpg]
  format = ssh

[user]
  signingkey = /home/johndoe/.ssh/id_ed25519.pub
```

### Authenticating
Use the "SSH" URL when cloning a repository. It should look something like this:
```
git@github.com:johndoe/myrepository.git
```


## Optional: Better Diffs/Merges

### Terminal
If you want a better experience for diffing on the command line, consider
[Delta](https://github.com/dandavison/delta)

`.gitconfig`:
```
[core]
  pager = delta

[delta]
  light = false
  navigate = true
  side-by-side = true
```

### GUI
If you want to use a GUI for diffing and merging, consider
[Meld](https://meldmerge.org)

> TODO(timzwiebel): Update the config to automatically choose Meld or Delta
> depending on whether there's a `$DISPLAY`

`.gitconfig`:
```
[diff]
  tool = meld

[difftool "meld"]
  cmd = meld "${LOCAL}" "${REMOTE}"

[merge]
  tool = meld

[mergetool "meld"]
  cmd = meld "${LOCAL}" "${BASE}" "${REMOTE}" --output "${MERGED}"
```


## Git Commands
Below are the most common commands used while working with git. These can be
simplified by using aliases.

`.gitconfig`:
```
[alias]
  # Add
  add-all = add --all
  add-all-tracked = add --update

  # Branch Create/Delete/List/Switch
  bc = switch --create
  bd = branch --delete
  bl = branch
  bs = switch

  # Diff
  d = difftool HEAD
  d-all = difftool --dir-diff HEAD

  # Discard Changes
  discard = restore
  discard-all = !git restore .

  # Graph
  g = log --graph --abbrev-commit --pretty=oneline
  g-all = g --all
  g-full = log --graph --pretty=fuller
  g-full-all = g-full --all

  # Log
  l = log --abbrev-commit --pretty=oneline
  l-full = log --pretty=fuller

  # Pending
  p = difftool --dir-diff --cached

  # Resolve
  resolve = mergetool

  # Remove
  rem = restore --staged
  rem-all = reset

  # Root
  root = rev-parse --show-toplevel

  # Status
  s = status

  # Submit
  submit = push --recurse-submodules=on-demand

  # Sync
  sync = pull --rebase --prune --recurse-submodules
```

### Initializing repositories

#### Start a new local git repository
```shell
git init
```

#### Download an existing remote git repository
> TIP: Remember to use the "SSH" URL

```shell
git clone <url> [<dir>]
```

### Syncing

#### Sync the local repository with the remote repository
```shell
git sync  # git pull --rebase --prune --recurse-submodules
```

### Status

#### View the status of the current branch
```shell
git s  # git status
```

### Root Directory

#### Print the root/top-level directory of the local repository
```shell
git root  # git rev-parse --show-toplevel
```

### Branching

#### Switch to a different branch
```shell
git bs <branch>  # git switch <branch>
```

#### Create a new branch (and switch to it)
```shell
git bc <branch>  # git switch --create <branch>
```

#### List all branches
```shell
git bl  # git branch
```

#### Delete a branch
```shell
git bd <branch>  # git branch --delete <branch>
```

### Viewing commit history

#### View the commit logs
- View the **abbreviated** commit history of the current branch:
  ```shell
  git l  # git log --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the current branch:
  ```shell
  git l-full  # git log --pretty=fuller
  ```

#### View the commit logs as a graph
- View **abbreviated** commit history of the **current branch** as a graph:
  ```shell
  git g  # git log --graph --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the **current branch** as a graph:
  ```shell
  git g-full  # git log --graph --pretty=fuller
  ```
- View the **abbreviated** commit history of **all branches** as a graph:
  ```shell
  git g-all  # git log --graph --abbrev-commit --pretty=oneline --all
  ```
- View the **full** commit history of **all branches** as a graph:
  ```shell
  git g-full-all  # git log --graph --pretty=fuller --all
  ```

### Staging files

#### Stage files for commit
- Stage **a file** for commit:
  ```shell
  git add <file> [<file> ...]
  ```
- Stage **all changed files (both tracked and untracked)** for commit:
  ```shell
  git add-all  # git add --all
  ```
- Stage **only changed tracked files** for commit:
  ```shell
  git add-all-tracked  # git add --update
  ```

#### Unstage files for commit
- Unstage **files** for commit:
  ```shell
  git rem <file> [<file> ...]  # git restore --staged <file> [<file> ...]
  ```
- Unstage **all files** for commit:
  ```shell
  git rem-all  # git reset
  ```

### Discarding changes
- Discard changes to a file:
  ```shell
  git discard <file> [<file> ...]  # git restore <file> [<file> ...]
  ```
- Discard all changes (to the current directory):
  ```shell
  git discard-all  # git restore .
  ```

### Diffing changes
- Diff all staged files against local HEAD:
  ```shell
  git p  # git difftool --dir-diff --cached
  ```
- Diff a single file, regardless of whether it's staged (local HEAD vs file):
  ```shell
  git d <file>  # git difftool HEAD <file>
  ```
- Diff all changed files (tracked only; diffing an untracked file wouldn't make
  sense because it's a new file), regardless of whether they're staged (local
  HEAD vs files):
  ```shell
  git d-all  # git difftool --dir-diff HEAD
  ```

### Submitting changes

#### Commit all staged files to the local repository
```shell
git commit
```

#### Submit all local commits to the remote repository
> TODO(timzwiebel): add notes about how to submit changes to a submodule

```shell
git submit  # git push --recurse-submodules=on-demand
```
