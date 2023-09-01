# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o nounset
set -o noclobber
set -o pipefail


# Aliases

# https://wiki.archlinux.org/title/sudo#Reduce_the_number_of_times_you_have_to_type_a_password
alias sudo='sudo --validate && sudo '

# Prompt before overwriting files
alias cp='cp --interactive'
alias mv='mv --interactive'

# ls: use colors, long format, and indicators on file types
alias ls='ls --color=auto'
alias ll='ls --all --format=long --classify=auto'

# grep: use colors, recursive, and line numbers
alias grep='grep --color=auto'
alias rgrep='grep --color=auto --recursive --line-number'

# https://wiki.archlinux.org/title/pacman#Usage
alias pacman='pacman --color=auto'
alias pacman-check='pacman --query --check --check'
alias pacman-clean-cache='pacman --sync --clean'
alias pacman-info='pacman --sync --info --info'
alias pacman-info-local='pacman --query --info --info'
alias pacman-install='pacman --sync'
alias pacman-list-explicit='pacman --query --explicit --unrequired'
alias pacman-list-explicit-all='pacman --query --explicit'
alias pacman-list-optional='pacman --query --deps --unrequired --unrequired'
alias pacman-list-orphan='pacman --query --deps --unrequired'
alias pacman-remove='pacman --remove --recursive'
alias pacman-search='pacman --sync --search'
alias pacman-search-files='pacman --files'
alias pacman-set-asdeps='pacman --database --asdeps'
alias pacman-set-asexplicit='pacman --database --asexplicit'
alias pacman-update='pacman --sync --refresh --sysupgrade'


# Custom Prompt
#  - Print the exit code of the previous command
#  - Print a newline between each prompt for visual spacing
#  - Add colors to the host and path
#  - Use a multi-line prompt so that commands always start at the left side of
#    the screen even with a long host or path
#  - Print the name of the current git branch if in a git directory
#
# See also:
#  - https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
#  - https://tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
#  - http://en.wikipedia.org/wiki/ANSI_escape_code
#
# Full breakdown:
# (the "\[" and "\]" surrounding ANSI escape codes tells bash that these don't
# take up space; without them, line wrapping gets messed up)
# PS1 =
#   $(if [[ "$?" == "0" ]]; then echo -n "\[\e[32m\][$?]"; else echo -n "\[\e[01;31m\][$?]"; fi)
#                  <set green> OR <set bold; red>, then [<previous_exit_code>]
#                  ($? must be part of the echo command, otherwise $? will
#                  always be 0 because the echo succeeded)
#   \[\e[00m\]     <reset>
#   \n\n           \n\n (literal)
#   \[\e[01;34m\]  <set bold; blue>
#   \u@\h          <username>@<abbreviated_hostname>
#   \[\e[00m\]     <reset>
#   :              : (literal)
#   \[\e[01;36m\]  <set bold; cyan>
#   \w             <full_working_directory>
#   \[\e[00m\]     <reset>
#   \[\e[01;35m\]  <set bold; magenta>
#   $(git branch --no-color 2>/dev/null | sed -e "/^[^*]/d" -e "s|* \(.*\)| (\1)|")
#                  <git_branch_name> (" (<branch_name>)" or "")
#                  (The full "git branch" command is better than
#                  "git branch --show-current" because it also works in a
#                  "detached HEAD" state)
#   \[\e[00m\]     <reset>
#   \n>            \n> (literal)
PS1='$(if [[ "$?" == "0" ]]; then echo -n "\[\e[32m\][$?]"; else echo -n "\[\e[01;31m\][$?]"; fi)\[\e[00m\]\n\n\[\e[01;34m\]\u@\h\[\e[00m\]:\[\e[01;36m\]\w\[\e[00m\]\[\e[01;35m\]$(git branch --no-color 2>/dev/null | sed -e "/^[^*]/d" -e "s|* \(.*\)| (\1)|")\[\e[00m\]\n> '


# Workaround for VS Code bug present in v1.81.1.
# https://github.com/microsoft/vscode/issues/185324
if [[ "${TERM_PROGRAM-}" == 'vscode' ]]; then
  set +o nounset
fi
