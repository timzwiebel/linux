# Git Configuration


# Install `~/.gitconfig`
If you want to use my `.gitconfig` file, add the following lines to your
`~/.gitconfig`:
```ini
[include]
	path = <path_to_this_repository>/config/git/.gitconfig

[user]
	email = <your_email>
	name = <your_name>
```

For any settings duplicated in both `~/.gitconfig` and `config/git/.gitconfig`,
the last value will take effect (except for the few multi-valued configuration
values, in which case all values found across all configuration files will be
used). Therefore, it's probably a good idea to put the `[include]` section at
the top of your `~/.gitconfig`.

Alternatively, you can simply copy/paste parts of my `.gitconfig` file into your
`~/.gitconfig` file.

> **&#8505;&#65039;<!-- information emoji --> TIP:** If you want to split your
> Git config into multiple files and/or use parts of your Git config
> conditionally (e.g., enable some aliases only when working in a particular
> repository), then you can use `[include]` and `[includeIf]` sections
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
	allowedSignersFile = ~/.ssh/allowed_signers

[tag]
	forceSignAnnotated = true
	gpgSign = true

[user]
	signingKey = ~/.ssh/id_ed25519.pub
```

> **&#8505;&#65039;<!-- information emoji --> NOTE:** If you sign commits/tags
> from the command line using the `-S[<keyid>]`/`--gpg-sign[=<keyid>]` flags
> (instead of configuring your `.gitconfig` file as shown above), `[<keyid>]`
> will default to using your email address (from `user.email` in your
> `~/.gitconfig`) as the `keyid` in order to locate the proper SSH key to use.

> **&#8505;&#65039;<!-- information emoji --> NOTE:** While `git` has supported
> [signing pushes](https://stackoverflow.com/questions/27299355/why-does-git-need-signed-pushes)
> since
> [v2.2.0](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.2.0.txt),
> sadly as of September 2023, neither
> [GitHub](https://github.com/orgs/community/discussions/23515) nor GitLab seem
> to support signed pushes.


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

> **&#10071;&#65039;<!-- red exclamation mark emoji --> IMPORTANT:** These
> commands will behave differently depending on the settings in your
> `.gitconfig` and/or the command line flags used. Be sure to read each section
> about the various commands for a full understanding.

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
	check = "!f() { printf 'Staged:\\n' && git diff --check --staged && printf '(no errors)\\n'; printf '\\nUnstaged:\\n' && git diff --check && printf '(no errors)\\n'; } && f"

	# Commit (with a check before)
	submit = "!f() { git diff --check --staged && git commit \"$@\"; } && f"

	# Diff
	d = difftool HEAD
	d-all = difftool --dir-diff HEAD
	d-commit = difftool --dir-diff
	d-staged = difftool --dir-diff --staged

	# Discard Changes
	discard = restore
	discard-all = "!f() { git restore \"$(git root)\"; } && f"

	# Graph (Log)
	g = gg --max-count=20
	gg = log --graph --abbrev-commit --pretty=oneline
	g-all = gg-all --max-count=20
	gg-all = gg --all
	g-full = log --graph --pretty=fuller --show-signature
	g-full-all = g-full --all

	# Log
	l = ll --max-count=20
	ll = log --abbrev-commit --pretty=oneline
	l-full = log --pretty=fuller --show-signature

	# Resolve (Merge)
	resolve = mergetool

	# Remove (opposite of `git add`)
	rem = restore --staged
	rem-all = reset --mixed

	# Root
	root = rev-parse --show-toplevel

	# Status
	s = "!f() { git status && printf '\\nStash:\\n' && stash=\"$(git stash list --abbrev-commit --pretty=oneline --color=never)\" && printf \"${stash:-(nothing stashed)}\\n\"; } && f"
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

> **&#8505;&#65039;<!-- information emoji --> TIP:** You can set a default
> branch name for `git init` in your `.gitconfig`. For example:
> ```
> [init]
> 	defaultBranch = main
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
> **&#8505;&#65039;<!-- information emoji --> TIP:** Remember to prefer using
> the "SSH" URL, **not** the one that starts with `https` (see [SSH](#ssh))

```shell
git clone <url> [<directory>]
```

## Pulling changes from the remote repository into the local repository
**TL;DR:** generally use `git pull` with rebasing and pruning.
```shell
git pull  # git pull --rebase --prune --prune-tags
```

> **&#8505;&#65039;<!-- information emoji --> TIP:** You can specify the default
> behavior of `git pull` in your `.gitconfig`. For example:
> ```
> [fetch]
> 	prune = true
> 	pruneTags = true
>
> [pull]
> 	rebase = true
> ```

### Pull: overview
`git fetch` is used to download commit history from the remote repository. The
local branch's commit history must then be updated with the new commit history
from the remote repository. If the commit histories have diverged, the user
needs to reconcile the differences with either `git merge` or `git rebase`.
`git pull` conveniently combines these two operations (`fetch` +
`merge`/`rebase`) into a single command.

### Pull strategy: default
By default, `git pull` will attempt to simply fast-forward the current branch to
match the remote one. However, if the commit histories have diverged, the user
needs to reconcile the differences by either merging or rebasing.

### Pull strategy: merge
By using `git pull --merge`, `git` will merge the two commit histories. For
example:
```
      A---B---C main on origin
     /
D---E---F---G main
    ^
    origin/main in your repository
```

After `git pull --merge`, the local commit history will look like this:
```
      A---B---C origin/main
     /         \
D---E---F---G---H main
```

This scenario is very common. For example, imagine that Person 2 implements a
feature in `A`, `B`, and `C`, and then Person 2 pushes those changes while
Person 1 is still working on a different feature in `F` and `G`. When Person 1
wants to ensure that their changes are compatible with Person 2's changes, they
can run `git pull --merge`, resulting in the local commit history seen above.

However, the resulting local commit history is probably **not** what you want.
It's usually cleaner and simpler (in the long run) to keep the commit history
linear in these scenarios. Imagine the branching/merging mess that will occur
after pulling and merging multiple times during the development of a large
feature. No one will want to review that pull request!

After all, Person 1 didn't actively *choose* to base their change on `E`. The
fact that `E` happened to be the tip of `main` when they started their work,
that Person 2 happened to push their changes before Person 1 finished their
work, and that Person 1 happened to `git pull --merge` when `C` was the tip of
the remote repository is all purely coincidental. Put simply, **there's no
reason to take all of the branches and merge commits from each time a developer
decided to `git pull --merge` and preserve all of that in the public/remote
commit history, making it more complex for reviewers and maintainers**.

So instead of merging, Person 2 can (and should) rebase instead. Keep reading
below.

### Pull strategy: rebase
As seen in the example in the section above, `git pull --merge` often leads to
unnecessarily complex commit history that will end up becoming part of the
public/remote commit history.

As mentioned above, in the example, Person 1 should use `git pull --rebase` to
keep the local commit history clean. Rebasing will also help keep the
public/remote commit history more linear and easier to review/maintain when
Person 1 does finally push their changes.

Again using the example above, after a `git pull --rebase`, the local commit
history will look like this:
```
D---E---A---B---C---F'---G' main
                ^
                origin/main
```

It might seem inconvenient to `git pull --rebase` instead of `git pull --merge`
because you might find yourself repeating similar merge steps for each commit
that needs to be rebased. However, the trade-off for one person having to do a
little extra work is usually worth it in the long run because it allows for a
clean linear commit history in the public/remote commit history. This simplifies
everyone else's lives and makes it easier to review and maintain in the future.
It also encourages good practices such as pulling often and splitting large
changes into smaller more manageable pieces.

Remember that you can specify the default behavior of `git pull` in your
`.gitconfig`. See the TIP callout in the
[Pulling changes from the remote repository into the local repository](#pulling-changes-from-the-remote-repository-into-the-local-repository)
section.

There are a few caveats to consider when rebasing, described in the IMPORTANT
and NOTE callouts below:

> **&#10071;&#65039;<!-- red exclamation mark emoji --> IMPORTANT:** Rebasing
> rewrites commit history. Generally, you should avoid rewriting commit history
> on branches that other people are working on. (Therefore, you should generally
> try to only rebasing within your local commit history and avoid rebasing
> anything within the public/remote commit history.) Make sure you read the
> WARNING callout in the [Rebasing](#rebasing) section.

> **&#8505;&#65039;<!-- information emoji --> NOTE:** When rebasing, `git` will
> put the newly rebased commits into a single linear branch. You can control
> this behavior with `--rebase-merges`. Unless you're rebasing a complicated
> commit history with branches/merges that you want to preserve, you probably
> don't need to worry about this, but it is worth mentioning so you aren't
> surprised.

### Pruning
When using `git fetch` or `git pull`, it usually makes sense to also prune your
local repository so that it matches the remote repository. This can be done with
the `--prune` and `--prune-tags` flags to `fetch`/`pull`.

Remember that you can specify the default behavior of `git fetch` (which also
affects `git pull`) in your `.gitconfig`. See the TIP callout in the
[Pulling changes from the remote repository into the local repository](#pulling-changes-from-the-remote-repository-into-the-local-repository)
section.

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
  git l  # git log --abbrev-commit --pretty=oneline --max-count=20
  ```
  ```shell
  git ll  # git log --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the current branch:
  ```shell
  git l-full  # git log --pretty=fuller --show-signature
  ```

### View the commit logs as a graph
- View **abbreviated** commit history of the **current branch** as a graph:
  ```shell
  git g  # git log --graph --abbrev-commit --pretty=oneline --max-count=20
  ```
  ```shell
  git gg  # git log --graph --abbrev-commit --pretty=oneline
  ```
- View the **full** commit history of the **current branch** as a graph:
  ```shell
  git g-full  # git log --graph --pretty=fuller --show-signature
  ```
- View the **abbreviated** commit history of **all branches** as a graph:
  ```shell
  git g-all  # git log --graph --abbrev-commit --pretty=oneline --all --max-count=20
  ```
  ```shell
  git gg-all  # git log --graph --abbrev-commit --pretty=oneline --all
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
  git rem-all  # git reset --mixed
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

### Tips for committing
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
> **&#8505;&#65039;<!-- information emoji --> TIP:** Remember to run
> `git diff --check [--staged]` before committing (see
> [Tips](#tips-for-committing))
```shell
git submit  # git diff --check --staged && git commit --gpg-sign[=<keyid>]
```

### Submit all local commits to the remote repository
```shell
git push
```
> TODO(timzwiebel): use `--atomic`?

## Rebasing

> **&#9888;&#65039;<!-- warning emoji --> WARNING:** `git rebase` rewrites the
> commit history. It **can be harmful** to do it in shared branches. It can
> cause complex and hard-to-resolve merge conflicts. Therefore, it should
> generally only be used on commits that haven't yet been pushed to a shared
> repository.
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

> **&#10071;&#65039;<!-- red exclamation mark emoji --> IMPORTANT:** Note that
> any commits already present upstream will be skipped. For example:
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
> **&#8505;&#65039;<!-- information emoji --> NOTE:** This example is included
> for completeness, but it's probably easier to use the "interactive mode"
> described in [Rewrite commit history](#rewrite-commit-history).

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

> **&#8505;&#65039;<!-- information emoji --> TIP:** In between steps, make sure
> that everything builds and that tests pass before proceeding to the next step.
> Add a new line containing the `break` command to add extra interrupts to the
> rebase.

When you're ready, use `git rebase --continue` to move to the next step. Or use
`git rebase --abort` to revert back to the state before the rebase began.

# Subprojects
Git supports two methods for integrating child repositories into a parent
repository: **subtrees** and **submodules**.

## Subtrees
Subtrees make a full copy of the child repository as a subdirectory of the
parent repository and effectively merge the contents (and history) of the child
repository into the parent repository. The subdirectory is treated like any
other directory and git does not perform any special tracking. This means that
the full contents of the child repository are duplicated in the parent
repository. The full history of the child repository is also duplicated in the
parent repository unless the `--squash` option is used during
`git subtree add`, in which case the history of the child repository is squashed
into a single commit.

Example commands:
```shell
git subtree add --prefix=<subdirectory> <remote_url> <remote_branch>
git subtree pull --prefix=<subdirectory> <remote_url> <remote_branch>
git subtree push --prefix=<subdirector> <remote_url> <remote_branch>
```

> **&#8505;&#65039;<!-- information emoji --> TIP:** Have `git` track the remote
> repository so you can give it a name instead of specifying the remote URL each
> time.
>
> ```shell
> git remote add <name> <remote_url>
> ```

Subtrees can be useful when you don't own the child repository and are unlikely
to push changes to it. Changes are only pulled when you explicitly rerun
`git subtree pull` (since git doesn't keep track of the fact that the
subdirectory came from somewhere else).

## Submodules
Submodules check out a repository in a subdirectory of the parent repository.
Details about the child repository are stored in a `.gitmodules` file in the
parent repository. Also, a reference to a particular commit in the child
repository is stored in the parent repository.

Example commands:
```shell
git submodule add [--branch <branch>] [--name <name>] <remote_url> <subdirectory>
git submodule init <subdirectory>
git submodule status <subdirectory>
git submodule update [<options>] <subdirectory>
```

You can also `cd` into the subdirectory and run normal git commands (e.g., `git
status`, `git pull`, `git commit`, `git push`, etc.).

> **&#8505;&#65039;<!-- information emoji --> TIP:** Many `git` commands can be
> made recursive with the `--recurse-submodules` flag. The default behavior can
> also be specified in your `.gitconfig` using either the
> `<command>.recruseSubmodules` or `submodule.recurse` options.
