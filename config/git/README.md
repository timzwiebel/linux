# Git Configuration
[TOC]


# Install
> **IMPORTANT:** The `.gitconfig` file in this repository uses **my** name/email
> address. You should use **your own** name/email address. Therefore, it's
> probably not useful for anyone else to use much from this `config/git`
> directory directly. But it might be helpful as a template for your own Git
> configuration.

```shell
ln -s "${TIMZWIEBEL_LINUX}/config/git/.gitconfig" ~/.gitconfig
```

> **TIP:** If you want to split your Git config into multiple files and/or use
> parts of your Git config conditionally (e.g., enable some aliases only when
> working in a particular repository), then you can use `[include]` and
> `[includeIf]` sections
> ([examples](https://git-scm.com/docs/git-config#_example)).


# Basic Configuration
Git settings are stored in `~/.gitconfig`. Here is an example of a basic
`.gitconfig`:
```
[core]
  editor = vim

[user]
  email = john.doe@gmail.com
  name = John Doe
```


# SSH
[SSH keys](../ssh/README.md#generating-keys) can be used for both authenticating
with remote repositories as well as signing your commits and tags so that they
can be verified.

## Authenticating
Upload your public SSH key to your account on your repository host (e.g.,
GitHub/GitLab). After that, simply use the "SSH" URL when cloning repositories
(**not** the one that starts with `https`). It should look something like this:
```
git@github.com:johndoe/myrepository.git
```

## Signing commits and tags
Signing commits and tags allows them to be verified
([GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification),
[GitLab](https://docs.gitlab.com/ee/user/project/repository/signed_commits)).
This is an example `.gitconfig` set up for signing both commits and tags with
SSH keys:
```
[commit]
  gpgSign = true

[gpg]
  format = ssh

[gpg "ssh"]
  allowedSignersFile = /home/johndoe/.ssh/allowed_signers

[tag]
  forceSignAnnotated = true
  gpgSign = true

[user]
  signingKey = /home/johndoe/.ssh/id_ed25519.pub
```


# Optional: Better Diffs/Merges

## Pager
If you want a better experience anywhere a pager is used on the command line
(e.g., when using `git diff`), consider using
[Delta](https://github.com/dandavison/delta). Here's an example `.gitconfig`:
```
[core]
  pager = delta

[delta]
  light = false
  navigate = true
  side-by-side = true
```

## Diff/Merge Tool
If you want a better experience for diffing and merging on the command line,
here's an example `.gitconfig` that uses
[`vimdiff`](https://vimhelp.org/diff.txt.html):
```
[diff]
  tool = vimdiff

[difftool]
  prompt = false

[merge]
  tool = vimdiff

[mergetool "vimdiff"]
  layout = LOCAL,MERGED,REMOTE
```

## Diff/Merge GUI Tool
If you want to use a GUI for diffing and merging, consider using
[Meld](https://meldmerge.org). Here's an example `.gitconfig` that uses Meld
when a display is available, but falls back to `vimdiff`:
```
[diff]
  guitool = meld
  tool = vimdiff

[difftool]
  prompt = false
  guiDefault = auto

[merge]
  guitool = meld
  tool = vimdiff

[mergetool]
  guiDefault = auto

[mergetool "meld"]
  useAutoMerge = auto

[mergetool "vimdiff"]
  layout = LOCAL,MERGED,REMOTE
```


# Git Commands
Below are the most common commands used while working with `git`. These can be
simplified by using aliases. Here is a list of the aliases in my `.gitconfig`:

> **IMPORTANT:** These commands will behave differently depending on the
> settings in your `.gitconfig` and/or the command line flags used. Be sure to
> read each section about the various commands for a full understanding.

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

  # Check
  check = diff --check --staged
  check-all = "!f() { echo 'Staged:' && git diff --check && echo '(no errors)'; echo -e '\\nUnstaged:' && git diff --check --staged && echo '(no errors)'; } && f"

  # Check and Commit
  submit = "!f() { git check && git commit \"$@\"; } && f"

  # Diff
  d = difftool HEAD
  d-all = difftool --dir-diff HEAD
  d-commit = difftool --dir-diff
  d-staged = difftool --dir-diff --staged

  # Discard Changes
  discard = restore
  discard-all = "!f() { git restore \"$(git root)\"; } && f"

  # Graph
  g = log --graph --abbrev-commit --pretty=oneline
  g-all = g --all
  g-full = log --graph --pretty=fuller --show-signature
  g-full-all = g-full --all

  # Log
  l = log --abbrev-commit --pretty=oneline
  l-full = log --pretty=fuller --show-signature

  # Resolve
  resolve = mergetool

  # Remove
  rem = restore --staged
  rem-all = reset

  # Root
  root = rev-parse --show-toplevel

  # Status
  s = status
```

## Referencing commits
There are several ways to reference a specific commit in a `git` command:
- The commit hash (either the full 40-character commit hash or the 7-character
  abbreviated commit hash)
- A branch name (uses the tip of the branch)
- `HEAD` (uses the tip of the current branch)
- Ancestors of a commit (using `~`), for example:
  - `main~` or `main~1` (the first parent of the tip of the `main` branch)
  - `HEAD~3` (the third parent of the tip of the current branch)

## Initializing repositories

### Start a new local repository
```shell
git init [--initial-branch=<branch_name>]
```

> **TIP:** You can set a default branch name for `git init` in your
> `.gitconfig`. For example:
> ```
> [init]
>   defaultBranch = main
> ```
>
> Both
> [GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches#about-the-default-branch)
> and
> [GitLab](https://docs.gitlab.com/ee/user/project/repository/branches/default.html)
> use `main` by default, however
> [`git`](https://git-scm.com/docs/git-init#Documentation/git-init.txt---initial-branchltbranch-namegt)
> still uses `master` by default (at least as of September 2023). However, there
> are [efforts](https://sfconservancy.org/news/2020/jun/23/gitbranchname) to
> change `git` to also use `main` by default.

### Download an existing remote repository
> **TIP:** Remember to prefer using the "SSH" URL, **not** the one that starts
> with `https` (see [SSH](#ssh))

```shell
git clone <url> [<directory>]
```

## Pulling

### Pull changes from the remote repository into the local repository
**TL;DR:** generally use `git pull` with pruning, rebasing, and recursion (if
you're using submodules).
```shell
git pull  # git pull --rebase --prune --recurse-submodules
```

> TODO(timzwiebel): expand this section

## Status

### View the status of the current branch
```shell
git s  # git status
```

## Root Directory

### Print the root/top-level directory of the local repository
```shell
git root  # git rev-parse --show-toplevel
```

## Branching

### Switch to a different branch
```shell
git bs <branch>  # git switch <branch>
```

### Create a new branch (and switch to it)
```shell
git bc <branch>  # git switch --create <branch>
```

### List all branches
```shell
git bl  # git branch
```

### Delete a branch
```shell
git bd <branch>  # git branch --delete <branch>
```

## Viewing commit history

### View the commit logs
- View the **abbreviated** commit history of the current branch:
  ```shell
  git l  # git log --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the current branch:
  ```shell
  git l-full  # git log --pretty=fuller --show-signature
  ```

### View the commit logs as a graph
- View **abbreviated** commit history of the **current branch** as a graph:
  ```shell
  git g  # git log --graph --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the **current branch** as a graph:
  ```shell
  git g-full  # git log --graph --pretty=fuller --show-signature
  ```
- View the **abbreviated** commit history of **all branches** as a graph:
  ```shell
  git g-all  # git log --graph --abbrev-commit --pretty=oneline --all
  ```
- View the **full** commit history of **all branches** as a graph:
  ```shell
  git g-full-all  # git log --graph --pretty=fuller --show-signature --all
  ```

## Staging files

### Stage files for commit
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

### Unstage files for commit
- Unstage **files** for commit:
  ```shell
  git rem <file> [<file> ...]  # git restore --staged <file> [<file> ...]
  ```
- Unstage **all files** for commit:
  ```shell
  git rem-all  # git reset
  ```

## Discarding changes
- Discard changes to a file:
  ```shell
  git discard <file> [<file> ...]  # git restore <file> [<file> ...]
  ```
- Discard all changes (to the current directory):
  ```shell
  git discard-all  # git restore "$(git rev-parse --show-toplevel)"
  ```

## Diffing changes
`git diff` will use a pager to show read-only diffs. `git difftool` will use
whatever tool(s) you specify. See
[Optional: Better Diffs/Merges](#optional-better-diffsmerges) for more
information on specifying a diff/merge tool.

- Diff all staged files against local HEAD:
  ```shell
  git d-staged  # git difftool --dir-diff --staged
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
- Diff two commits (see [Referencing commits](#referencing-commits); if the
  second commit isn't specified, the working tree is used):
  ```shell
  git d-commit <commit_1> [<commit_2>]  # git difftool --dir-diff <commit_1> [<commit_2>]
  ```

## Submitting changes

### Tips for submitting
Before going into the specifics, it's helpful to read through the
[Contributing to a Project](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)
section of the Pro Git book, available for free on the official Git website.

**TL;DR:**
- Run `git diff --check [--staged]` before committing
- Commit messages should look like this (mostly copied from the book, which
  [copied from Tim Pope](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)):
  ```
  Capitalized, short (50 chars or less) summary

  More detailed explanatory text, if necessary. Wrap it to 72 characters.
  In some contexts, the first line is treated as the subject of an email
  and the rest of the text as the body. The blank line separating the
  summary from the body is critical (unless you omit the body entirely);
  tools like rebase will confuse you if you run the two together.

  Write your commit message in the imperative: "Fix bug" and not "Fixed
  bug" or "Fixes bug" (as if you're commanding the code to change itself).
  This convention matches up with commit messages generated by commands
  like git merge and git revert.

  Further paragraphs come after blank lines.
  - Bullet points are okay, too
  - Typically a hyphen or asterisk is used for the bullet, followed by a
    single space
  ```

### Commit all staged files to the local repository
> **TIP:** Remember to run `git diff --check [--staged]` before committing (see
> [Tips](#tips-for-submitting))
```shell
git submit  # git diff --check --staged && git commit
```

### Submit all local commits to the remote repository
> **TODO(timzwiebel):** add notes about how to submit changes to a submodule

> TODO(timzwiebel): fix this section

## Rebasing

> **WARNING:** `git rebase` rewrites the commit history. It **can be harmful**
> to do it in shared branches. It can cause complex and hard-to-resolve merge
> conflicts. Therefore, it should generally only be used on commits that haven't
> yet been pushed to a shared repository.
>
> If you do end up rewriting commit history in a shared repository, you'll need
> to force push. When you do, ensure that you use `--force-with-lease` instead
> of `--force`. See [GitLab's
> documentation](https://docs.gitlab.com/ee/topics/git/git_rebase.html) for more
> information (this information applies to any shared repository, e.g., one on
> GitHub, not only to those hosted on GitLab).

### Explanation of rebase commands
Generally, `git rebase` commands look like this:
```shell
git rebase [--onto <new_base_commit>] <upstream_commit> [<branch>]
```

This command results in the following:
1.  If `<branch>` is specified, switch to `<branch>` (if `<branch>` is already
    the current branch, there's no need to specify it)
1.  Find the common ancestor between `<upstream_commit>` and the tip of the
    current branch
1.  Reapply commits between the common ancestor (exclusive) and the tip of the
    current branch (inclusive) onto `<upstream_commit>` (or onto
    `<new_base_commit>` if `--onto` was used).

> **IMPORTANT:** Note that any commits already present upstream will be skipped.
> For example:
> ```
>       A---B---C topic
>      /
> D---E---A'---F main
> ```
>
> Rebasing `topic` onto `main` will result in the following:
> ```
>                B'---C' topic
>               /
> D---E---A'---F main
> ```

Some common examples of rebasing are shown below.

### Rebase one branch onto another branch
Example:
```
      A---B---C topic
     /
D---E---F---G main
```

To rebase `topic` onto `main`, run this command:
```shell
git rebase main topic
```

`E` is the common ancestor of `main` (`G`) and `topic` (`C`), so commits in the
range `(E, C]` (`A` through `C` inclusive) will be rebased onto `main` (`G`).
This results in the following:
```
              A'--B'--C' topic
             /
D---E---F---G main
```

### Rebase part of a branch onto another branch
Example:
```
                        H---I---J topicB
                       /
              E---F---G  topicA
             /
A---B---C---D  main
```

To rebase `topicB` onto `main`, run this command:
```shell
git rebase --onto main topicA topicB
```

`G` is the common ancestor of `topicA` (`G`) and `topicB` (`J`), so commits in
the range `(G, J]` (`H` through `J` inclusive) will be rebased onto `main`
(`D`). This results in the following:
```
             H'--I'--J'  topicB
            /
            | E---F---G  topicA
            |/
A---B---C---D  main
```

### Remove a range of commits
> **NOTE:** This example is included for completeness, but it's probably easier
> to use the "interactive mode" described in
> [Rewrite commit history](#rewrite-commit-history).

Example:
```
E---F---G---H---I---J  topicA
```

To remove `F` through `G`, run this command:
```shell
git rebase --onto topicA~5 topicA~3 topicA
```

`G` is the common ancestor of `topicA~3` (`G`) and `topicA` (`J`), so commits in
the range `(G, J]` (`H` through `J` inclusive) will be rebased onto `topicA~5`
(`E`). This results in the following:
```
E---H'---I'---J'  topicA
```

### Rewrite commit history
Sometimes you might want to rewrite the commit history. For example:
- Edit commits (`edit`)
- Edit commit messages (`reword`)
- Remove commits (`drop`)
- Combine multiple commits (`squash`)
- Split a commit (`edit`)
- Reorder commits

The easiest way to do this is to use "interactive mode" (`-i`/`--interactive`):
```shell
git rebase -i <commit>
```

Example:
```
A---B---C---D---E---F---G---H---I---J
```

To edit commit history starting at `C` (inclusive):
```shell
git rebase -i C~
```

An editor will be launched with the commit history. For example:
```
pick C Implement feature one (broken)
pick D Ipmlement faeture two
pick E Implement feature three
pick F Implement feature four
pick G Fix feature four
pick H Implement feature five (big feature)
pick I Implement feature six
pick J Implement feature seven
```

The commit history can now be changed. For example:
```
edit C Implement feature one (broken)
reword D Ipmlement faeture two
drop E Implement feature three
pick F Implement feature four
squash G Fix feature four
edit H Implement feature five (big feature)
pick J Implement feature seven
pick I Implement feature six
```

The example above will do the following:
1.  Edit "feature one" (`C`) to fix the broken feature
1.  Edit the commit message for "feature two" (`D`)
1.  Remove "feature three" (`E`)
1.  Combine "feature four" and its "fix" (`F` and `G`)
1.  Edit "feature five" (`H`) to split it into multiple commits
1.  Move "feature seven" (`J`) before "feature six" (`I`)

The final result will be:
```
A---B---C'---D'---FG---H1---H2---H3---J'---I'
```

After saving and quitting the editor, the rebase will begin.

Each time the rebase is interrupted (e.g., to edit a commit), you can make
changes to files, then stage them with `git add`, and finally commit them with
`git commit --amend`.

If you `git commit` without `--amend`, you will add new commits to the commit
history. For example, this can be useful for splitting a large commit into
several smaller ones.

> **TIP:** In between steps, make sure that everything builds and that tests
> pass before proceeding to the next step. Add a new line containing the `break`
> command to add extra interrupts to the rebase.

When you're ready, use `git rebase --continue` to move to the next step. Or use
`git rebase --abort` to revert back to the state before the rebase began.
