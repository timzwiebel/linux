# https://man.archlinux.org/man/bash.1#set~2
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


# Custom Prompt:
#   - Print a newline between each prompt for visual spacing
#   - Print the exit code of the previous command
#   - Print the approximate time that the previous command finished
#   - Print the shell name & version
#   - Print the number of jobs managed by the shell
#   - Print the user, hostname, and working directory
#   - Print the name of the current git branch if in a git directory
#   - Use colors for improved readability
#   - Use a multi-line prompt so that commands always start at the left side of
#     the screen even with a long hostname or working directory
# https://wiki.archlinux.org/title/Bash/Prompt_customization

# Returns the current Git branch name
#
# Globals: none
# Arguments: none
# Outputs:
#   the current Git branch name wrapped in parentheses and preceded by a space,
#   or nothing if not in a Git directory
# Returns: default
_git_branch_name() {
  # The `git branch` command seems to be the most versatile way to get the
  # current branch (e.g., it works in a "detached HEAD" state). However, it does
  # not work in a new repository with no commits, so fallback to
  # `git branch --show-current` if `git branch` returns "".
  # https://stackoverflow.com/a/19585361
  local branch="$( \
      command -v git >/dev/null && command -v sed >/dev/null && \
      git branch --no-color 2>/dev/null | sed -n -e '/^\* /s|||p' || \
      :)"
  if [[ -z "${branch}" ]]; then
    branch="$( \
        command -v git > /dev/null && \
        git branch --no-color --show-current 2>/dev/null || \
        :)"
  fi
  if [[ -n "${branch}" ]]; then
    printf '%s' " (${branch})"
  fi
}

PS1="$(
  source "${HOME}/linux/lib/shell/control_sequence.sh"
  source "${HOME}/linux/lib/shell/bash_prompt.sh"

  make_prompt() {
    local -r jobs_text="jobs: ${BASH_PROMPT_JOB_COUNT}"
    local -r prompt=(
      # Blank line
      '\n'
      # Exit code of the previous command surrounded in square brackets (green
      # if 0, otherwise bold red)
      "${BASH_PROMPT_NON_PRINTING_START}"
      "${CS_INTRODUCER}"
      '$(ec="$?"; if (( ec == 0 )); then printf "%s" "'
      "${SGR_ATTR_COLOR_DARK_GREEN}"
      "${SGR_END}"
      "${BASH_PROMPT_NON_PRINTING_END}"
      '[${ec}]'
      '"; else printf "%s" "'
      "$(control_sequence::concat_sgr_attrs \
          "${SGR_ATTR_BOLD}" "${SGR_ATTR_COLOR_RED}")"
      "${SGR_END}"
      "${BASH_PROMPT_NON_PRINTING_END}"
      '[${ec}]'
      '"; fi)'
      "${BASH_PROMPT_CS_RESET}"
      # Approximate time that the previous command finished, and shell name &
      # version (gray)
      "$(bash_prompt::sgr "${SGR_ATTR_COLOR_GRAY}")"
      " | ${BASH_PROMPT_TIME} | ${BASH_PROMPT_SHELL_AND_VERSION} | "
      # The number of jobs managed by the shell (gray if 0, otherwise default)
      '$(if (( '
      "${BASH_PROMPT_JOB_COUNT}"
      ' == 0 )); then printf "%s" "'
      "${jobs_text}${BASH_PROMPT_CS_RESET}"
      '"; else printf "%s" "'
      "${BASH_PROMPT_CS_RESET}${jobs_text}"
      '"; fi)'
      # Next line
      '\n'
      # user@hostname (bold blue)
      "$(bash_prompt::format_text \
          "${BASH_PROMPT_USER}@${BASH_PROMPT_ABBREVIATED_HOSTNAME}" \
          "${SGR_ATTR_BOLD}" \
          "${SGR_ATTR_COLOR_BLUE}")"
      # Literal colon
      ':'
      # Working directory (bold cyan)
      "$(bash_prompt::format_text \
          "${BASH_PROMPT_WORKING_DIRECTORY}" \
          "${SGR_ATTR_BOLD}" \
          "${SGR_ATTR_COLOR_CYAN}")"
      # Git branch name (or empty)
      "$(bash_prompt::format_text \
          '$(_git_branch_name)' \
          "${SGR_ATTR_BOLD}" \
          "${SGR_ATTR_COLOR_MAGENTA}")"
      # Next line
      '\n'
      # Prompt character followed by a space
      "${BASH_PROMPT_CHARACTER} "
    )

    printf '%s' "${prompt[@]}"
  }

  make_prompt
)"


# Workaround for VS Code bug present in v1.81.1.
# https://github.com/microsoft/vscode/issues/185324
if [[ "${TERM_PROGRAM-}" == 'vscode' ]]; then
  set +o nounset
fi
