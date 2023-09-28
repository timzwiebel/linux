# Bash Configuration
[TOC]


# Install `~/.bashrc` (and add `bin/` to `PATH`)
If you want to use my [custom binaries/scripts](../../bin/README.md) and/or my
``.bashrc` file, add the following lines somewhere in your `~/.bashrc`:
```shell
export TIMZWIEBEL_LINUX="<path_to_this_repository>"  # e.g., "${HOME}/linux"

export PATH="${PATH}:${TIMZWIEBEL_LINUX}/bin"

source "${TIMZWIEBEL_LINUX}/config/bash/.bashrc"
```

Alternatively, you can simply copy/paste parts of my `.bashrc` file into your
`~/.bashrc` file.


# Links
- [Shell Libraries](../../lib/shell/README.md)
